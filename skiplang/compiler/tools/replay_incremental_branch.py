#!/usr/bin/env python3
"""Replay a real compiler source revision in the private, frozen fixture.

The historical branch changes compiler sources only. Runtime packages, driver,
host and output flags remain fixed. Git checkout happens before the timed build;
the build must still refresh its revision-dependent build script and artifacts.
The original checkout and fixture metadata are restored, even on build failure.
Pass the normal replay options after -- (including --root/--target/--mode).
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile


def git(repository, *arguments, env=None, input=None):
    return (
        subprocess.check_output(
            ["git", *arguments], cwd=repository, env=env, input=input
        )
        .decode()
        .strip()
    )


def source_blob(repository, revision, name):
    """Read a regular source file, distinguishing a missing path from empty bytes."""
    entries = subprocess.check_output(
        ["git", "ls-tree", "-z", revision, "--", name], cwd=repository
    ).split(b"\0")
    entries = [entry for entry in entries if entry]
    if not entries:
        return None
    assert len(entries) == 1
    header, actual = entries[0].split(b"\t", 1)
    mode, kind, object_id = header.decode().split()
    assert (
        actual.decode() == name
        and kind == "blob"
        and mode in ("100644", "100755")
    )
    contents = subprocess.check_output(
        ["git", "cat-file", "blob", object_id], cwd=repository
    )
    return mode, contents


def select_source_hashes(metadata, branches, selected):
    for name, identities in branches["changed_files"].items():
        value = identities[selected + "_sha256"]
        if value is None:
            metadata["source_sha256"].pop(name, None)
        else:
            metadata["source_sha256"][name] = value


def prepare(fixture, repository, historical, metadata):
    historical = git(repository, "rev-parse", historical)
    # Retain old one-revision manifests, but give each new revision its own
    # record so a predefined corpus can share the same initialized cache.
    manifest = fixture / "branch-fixture.json"
    if (
        not manifest.exists()
        or json.loads(manifest.read_text())["historical_source_revision"]
        != historical
    ):
        manifest = fixture / ("branch-fixture-" + historical[:12] + ".json")
    if manifest.exists():
        existing = json.loads(manifest.read_text())
        assert existing["historical_source_revision"] == historical
        assert (
            existing["baseline_fixture_revision"]
            == metadata["fixture_revision"]
        )
        return existing
    baseline = metadata["fixture_revision"]
    changed = git(
        repository,
        "diff",
        "--no-renames",
        "--name-only",
        metadata["source_revision"],
        historical,
        "--",
        "skiplang/compiler/src",
    ).splitlines()
    assert changed, "Select a revision with compiler source changes"
    files = {}
    with tempfile.TemporaryDirectory(
        prefix="branch-index-", dir=fixture.parent
    ) as tmp:
        env = dict(
            os.environ,
            GIT_INDEX_FILE=str(Path(tmp) / "index"),
            GIT_AUTHOR_NAME="Compiler benchmark",
            GIT_AUTHOR_EMAIL="compiler-benchmark@example.invalid",
            GIT_COMMITTER_NAME="Compiler benchmark",
            GIT_COMMITTER_EMAIL="compiler-benchmark@example.invalid",
            GIT_AUTHOR_DATE="2000-01-01T00:00:00+0000",
            GIT_COMMITTER_DATE="2000-01-01T00:00:00+0000",
        )
        git(fixture, "read-tree", baseline, env=env)
        for name in changed:
            assert Path(name).is_relative_to("skiplang/compiler/src")
            original = source_blob(fixture, baseline, name)
            replacement = source_blob(repository, historical, name)
            if replacement is None:
                git(
                    fixture,
                    "update-index",
                    "--force-remove",
                    "--",
                    name,
                    env=env,
                )
            else:
                mode, contents = replacement
                blob = git(
                    fixture, "hash-object", "-w", "--stdin", input=contents
                )
                git(
                    fixture,
                    "update-index",
                    "--add",
                    "--cacheinfo",
                    mode,
                    blob,
                    name,
                    env=env,
                )
            files[name] = {
                "baseline_sha256": (
                    hashlib.sha256(original[1]).hexdigest()
                    if original
                    else None
                ),
                "historical_sha256": (
                    hashlib.sha256(replacement[1]).hexdigest()
                    if replacement
                    else None
                ),
                "baseline_mode": original[0] if original else None,
                "historical_mode": replacement[0] if replacement else None,
            }
        tree = git(fixture, "write-tree", env=env)
        revision = git(
            fixture,
            "commit-tree",
            tree,
            "-p",
            baseline,
            env=env,
            input=("Compiler source replay at " + historical + "\n").encode(),
        )
        git(
            fixture,
            "update-ref",
            "refs/heads/benchmark-historical-" + historical[:12],
            revision,
        )
    record = {
        "baseline_fixture_revision": baseline,
        "historical_fixture_revision": revision,
        "baseline_source_revision": metadata["source_revision"],
        "historical_source_revision": historical,
        "changed_files": files,
        "scope": "compiler sources; fixed runtime, compiler host and driver",
    }
    manifest.write_text(json.dumps(record, indent=2) + "\n")
    return record


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fixture", type=Path, required=True)
    parser.add_argument("--repository", type=Path, required=True)
    parser.add_argument("--historical-revision", default="b88181999^")
    parser.add_argument(
        "--branch", choices=["historical", "baseline"], required=True
    )
    parser.add_argument("--label", required=True)
    parser.add_argument("replay_options", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    if Path(args.label).name != args.label or args.label in (".", ".."):
        parser.error("The label must be one directory name")
    fixture = args.fixture.resolve()
    options = args.replay_options
    if options[:1] == ["--"]:
        options = options[1:]
    assert "--root" in options and "--target" in options and "--mode" in options
    assert not any(
        option.split("=")[0] in ("--fixture", "--case", "--label")
        for option in options
    )
    assert not git(
        fixture, "diff", "--name-only", "HEAD"
    ), "Fixture has tracked edits"
    metadata_path = fixture / "fixture.json"
    original_metadata = metadata_path.read_bytes()
    metadata = json.loads(original_metadata)
    original_revision = git(fixture, "rev-parse", "HEAD")
    original_ref = subprocess.run(
        ["git", "symbolic-ref", "-q", "--short", "HEAD"],
        cwd=fixture,
        text=True,
        capture_output=True,
    ).stdout.strip()
    assert original_revision == metadata["fixture_revision"]
    branches = prepare(
        fixture, args.repository.resolve(), args.historical_revision, metadata
    )
    selected = branches[args.branch + "_fixture_revision"]
    root_index = options.index("--root") + 1
    evidence = Path(options[root_index]).resolve() / "runs" / args.label
    branch_record = dict(
        branches, selected_branch=args.branch, selected_revision=selected
    )
    try:
        git(fixture, "checkout", "--quiet", "--detach", selected)
        metadata["fixture_revision"] = selected
        select_source_hashes(metadata, branches, args.branch)
        metadata_path.write_text(json.dumps(metadata, indent=2) + "\n")
        return subprocess.call(
            [
                sys.executable,
                str(Path(__file__).with_name("replay_incremental_fixture.py")),
                "--fixture",
                str(fixture),
                "--case",
                "baseline",
                "--label",
                args.label,
                *options,
            ]
        )
    finally:
        git(fixture, "checkout", "--quiet", original_ref or original_revision)
        metadata_path.write_bytes(original_metadata)
        if evidence.exists():
            (evidence / "branch.json").write_text(
                json.dumps(branch_record, indent=2) + "\n"
            )


if __name__ == "__main__":
    raise SystemExit(main())
