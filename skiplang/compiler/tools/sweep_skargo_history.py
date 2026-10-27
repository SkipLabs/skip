#!/usr/bin/env python3
"""Replay compiler-source commits through one persistent Skargo build target.

Run this against a clean, disposable checkout. The script checks out revisions
and leaves the checkout at a failing revision for investigation. Passing runs
restore the original branch. Progress and logs live outside the checkout so a
failed run can be resumed.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time


def run(command, cwd, **kwargs):
    return subprocess.run(command, cwd=cwd, check=True, text=True, **kwargs)


def git(repo, *args):
    return run(["git", *args], repo, capture_output=True).stdout.strip()


def save(path, state):
    temporary = path.with_suffix(".tmp")
    temporary.write_text(json.dumps(state, indent=2) + "\n")
    temporary.replace(path)


def digest(path):
    sha = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            sha.update(block)
    return sha.hexdigest()


def read_revisions(path, repo):
    revisions = [git(repo, "rev-parse", line.strip())
                 for line in path.read_text().splitlines()
                 if line.strip() and not line.lstrip().startswith("#")]
    if len(revisions) != len(set(revisions)):
        raise ValueError(f"duplicate revisions in {path}")
    return revisions


def logged(command, cwd, environment, log):
    started = time.monotonic()
    with log.open("w") as output:
        output.write("$ " + " ".join(command) + "\n")
        output.flush()
        process = subprocess.Popen(command, cwd=cwd, env=environment,
                                   stdout=output, stderr=subprocess.STDOUT)
        while True:
            try:
                returncode = process.wait(timeout=30)
                break
            except subprocess.TimeoutExpired:
                print(f"  building for {int(time.monotonic() - started)}s; "
                      f"pid={process.pid}", flush=True)
    if returncode:
        tail = log.read_text(errors="replace").splitlines()[-25:]
        raise RuntimeError(f"exit {returncode}: {log}\n" + "\n".join(tail))
    return round(time.monotonic() - started, 2)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, required=True)
    parser.add_argument("--work", type=Path, required=True)
    parser.add_argument("--anchor", required=True)
    parser.add_argument("--count", type=int, default=100)
    parser.add_argument("--revisions-file", type=Path,
                        help="use an explicit ordered list of commit IDs")
    parser.add_argument("--exclude", action="append", default=[], metavar="REV",
                        help="omit a historical revision with a known source error")
    parser.add_argument("--all-unique-trees", action="store_true",
                        help="select distinct compiler trees across all refs")
    parser.add_argument("--skargo", type=Path, required=True)
    parser.add_argument("--skc", type=Path, required=True)
    parser.add_argument("--target-dir", type=Path,
                        help="persistent Skargo target; defaults to compiler/target")
    options = parser.parse_args()

    repo = options.repo.resolve()
    compiler = repo / "skiplang/compiler"
    work = options.work.resolve()
    target_dir = (options.target_dir.resolve() if options.target_dir
                  else compiler / "target")
    work.mkdir(parents=True, exist_ok=True)
    logs = work / "logs"
    logs.mkdir(exist_ok=True)
    state_path = work / "progress.json"
    anchor = git(repo, "rev-parse", options.anchor)
    excluded = {git(repo, "rev-parse", revision) for revision in options.exclude}
    if not options.skargo.is_file() or not options.skc.is_file():
        parser.error("skargo and skc must be existing files")

    if state_path.exists():
        state = json.loads(state_path.read_text())
        if (options.revisions_file and
                read_revisions(options.revisions_file, repo) != state["revisions"]):
            parser.error("revision file differs from saved progress")
        if (state["anchor"] != anchor or
                len(state["revisions"]) != options.count or
                state.get("all_unique_trees", False) != options.all_unique_trees or
                state.get("target_dir") != str(target_dir) or
                state.get("skc") != str(options.skc.resolve()) or
                state.get("skargo") != str(options.skargo.resolve())):
            parser.error("selection differs from saved progress")
    else:
        if git(repo, "status", "--porcelain", "--untracked-files=no",
               "--ignore-submodules=all"):
            parser.error("checkout has tracked changes")
        if options.revisions_file:
            revisions = read_revisions(options.revisions_file, repo)
        elif options.all_unique_trees:
            candidates = git(repo, "log", "--all", "--format=%H",
                             "--since=2026-07-22", "--",
                             "skiplang/compiler").splitlines()
            seen = set()
            revisions = []
            for revision in candidates:
                if revision in excluded:
                    continue
                tree = git(repo, "rev-parse", f"{revision}:skiplang/compiler")
                if tree not in seen:
                    seen.add(tree)
                    revisions.append(revision)
                if len(revisions) == options.count:
                    break
            revisions.reverse()
        else:
            revisions = git(repo, "rev-list", "--first-parent",
                            f"--max-count={options.count + len(excluded)}", anchor, "--",
                            "skiplang/compiler/src").splitlines()[::-1]
            revisions = [revision for revision in revisions if revision not in excluded]
            revisions = revisions[-options.count:]
        if len(revisions) != options.count:
            parser.error(f"found only {len(revisions)} compiler-source commits")
        state = {
            "anchor": anchor,
            "all_unique_trees": options.all_unique_trees,
            "target_dir": str(target_dir),
            "skc": str(options.skc.resolve()),
            "skargo": str(options.skargo.resolve()),
            "original_head": git(repo, "symbolic-ref", "--quiet", "--short", "HEAD"),
            "revisions": revisions,
            "completed": [],
            "failures": [],
        }
        save(state_path, state)

    environment = os.environ.copy()
    environment["SKC"] = str(options.skc.resolve())
    environment["PATH"] = str(options.skc.resolve().parent) + os.pathsep + environment["PATH"]
    skargo = str(options.skargo.resolve())
    artifacts = [target_dir / "host/dev" / name
                 for name in ("skc", "skfmt", "test", "__merged")]
    smoke_source = work / "smoke.sk"
    smoke_source.write_text("class Smoke {}\n")
    for index in range(len(state["completed"]), len(state["revisions"])):
        revision = state["revisions"][index]
        if git(repo, "status", "--porcelain", "--untracked-files=no",
               "--ignore-submodules=all"):
            raise RuntimeError("checkout has tracked changes; refusing to switch")
        print(f"[{index + 1}/{options.count}] {revision[:10]}", flush=True)
        run(["git", "switch", "--detach", revision], repo,
            stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
        source_tree = git(repo, "rev-parse", f"{revision}:skiplang/compiler/src")
        prefix = f"{index:03d}-{revision[:10]}"
        try:
            seconds = logged([skargo, "build", "--target-dir", str(target_dir)], compiler,
                             environment, logs / f"{prefix}-build.log")
            for artifact in artifacts:
                if not artifact.is_file():
                    raise RuntimeError(f"missing compiled binary: {artifact}")
            artifact_hashes = {artifact.name: digest(artifact)
                               for artifact in artifacts}
            if state["completed"]:
                previous = state["completed"][-1]["binary_sha256"]
                unchanged = [name for name, sha in artifact_hashes.items()
                             if sha == previous[name]]
                if unchanged:
                    raise RuntimeError("outputs did not update: " + ", ".join(unchanged))
            version = run([str(artifacts[0]), "--version"], compiler,
                          capture_output=True, env=environment).stdout.strip()
            if revision[:9] not in version:
                raise RuntimeError(f"compiled version {version!r} does not match {revision[:9]}")
            smoke_seconds = logged([str(artifacts[0]), "--no-std", "--check",
                                    str(smoke_source)], compiler, environment,
                                   logs / f"{prefix}-smoke.log")
            noop_seconds = logged([skargo, "build", "--target-dir", str(target_dir)], compiler,
                                  environment, logs / f"{prefix}-noop.log")
            for artifact in artifacts:
                if digest(artifact) != artifact_hashes[artifact.name]:
                    raise RuntimeError(f"unchanged rebuild changed {artifact}")
        except Exception as error:
            state["failures"].append({"index": index, "revision": revision,
                                      "error": str(error)})
            save(state_path, state)
            raise
        state["completed"].append({
            "index": index, "revision": revision, "source_tree": source_tree,
            "build_seconds": seconds, "noop_seconds": noop_seconds,
            "smoke_seconds": smoke_seconds,
            "binary_sha256": artifact_hashes, "version": version,
        })
        save(state_path, state)
        print(f"  PASS build={seconds}s noop={noop_seconds}s {version}", flush=True)

    run(["git", "switch", state["original_head"]], repo,
        stdout=subprocess.DEVNULL)
    print(f"verified {len(state['completed'])}/{options.count} revisions", flush=True)


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"FAIL: {error}", file=sys.stderr)
        raise SystemExit(1)
