#!/usr/bin/env python3
"""Replay predefined real branches serially under one fixed compiler policy.

Pass ordinary fixture replay options after --, including root, target, mode,
host, driver and observation flags. Each build validates its produced compiler.
The fixture is restored after every branch; the initialized cache survives for
the next transition. Export evidence and retire that cache after final census.
"""

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--fixture", type=Path, required=True)
    parser.add_argument("--repository", type=Path, required=True)
    parser.add_argument("--label", required=True)
    parser.add_argument("--rounds", type=int, default=2)
    parser.add_argument("replay_options", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    if Path(args.label).name != args.label or args.label in (".", ".."):
        parser.error("Label must be one directory name")
    if not 1 <= args.rounds <= 50:
        parser.error("Use between one and fifty finite rounds")
    options = (
        args.replay_options[1:]
        if args.replay_options[:1] == ["--"]
        else args.replay_options
    )
    for name in [
        "--root",
        "--target",
        "--mode",
        "--host-wrapper",
        "--host-binary",
        "--skargo",
    ]:
        assert name in options, name
    assert not any(
        option.split("=")[0]
        in (
            "--fixture",
            "--case",
            "--label",
            "--validate-only",
            "--validated-reference",
        )
        for option in options
    )
    root = Path(options[options.index("--root") + 1]).resolve()
    target = Path(options[options.index("--target") + 1]).resolve()
    assert target.is_relative_to(root) and not target.exists(), target
    raw = args.corpus.read_bytes()
    corpus = json.loads(raw)
    metadata = json.loads((args.fixture / "fixture.json").read_text())
    assert (
        corpus["version"] == 1
        and corpus["baseline_source"] == metadata["source_revision"]
    )
    entries = corpus["entries"]
    assert entries and len({entry["label"] for entry in entries}) == len(
        entries
    )
    for entry in entries:
        assert Path(entry["label"]).name == entry["label"] and entry[
            "label"
        ] not in (".", "..")
    record_path = root / (args.label + "-corpus.json")
    assert not record_path.exists(), record_path
    record = dict(
        corpus_sha256=hashlib.sha256(raw).hexdigest(),
        corpus=corpus,
        rounds=args.rounds,
        replay_options=options,
        completed=False,
        builds=[],
    )
    references = {}
    tool = Path(__file__).parent

    def run(suffix, branch=None, entry=None):
        label = args.label + "-" + suffix
        identity = (
            entry["revision"]
            if branch == "historical"
            else corpus["baseline_source"]
        )
        reference = (
            ["--validated-reference", str(root / "runs" / references[identity])]
            if identity in references
            else []
        )
        if branch is None:
            command = [
                sys.executable,
                str(tool / "replay_incremental_fixture.py"),
                "--fixture",
                str(args.fixture),
                "--case",
                "baseline",
                "--label",
                label,
                *options,
                *reference,
            ]
        else:
            command = [
                sys.executable,
                str(tool / "replay_incremental_branch.py"),
                "--fixture",
                str(args.fixture),
                "--repository",
                str(args.repository),
                "--historical-revision",
                entry["revision"],
                "--branch",
                branch,
                "--label",
                label,
                "--",
                *options,
                *reference,
            ]
        subprocess.run(command, check=True)
        directory = root / "runs" / label
        replay = json.loads((directory / "replay.json").read_text())
        phases = json.loads((directory / "phases.json").read_text())
        assert replay["validation"] == "passed" and phases["successful"]
        assert (
            abs(sum(phases["exclusive_seconds"].values()) - phases["seconds"])
            < 1e-6
        )
        record["builds"].append(
            dict(
                label=label,
                source_revision=identity,
                seconds=phases["seconds"],
                validation="passed",
            )
        )
        references[identity] = label
        record_path.write_text(json.dumps(record, indent=2) + "\n")

    record_path.write_text(json.dumps(record, indent=2) + "\n")
    run("cold")
    run("noop")
    for cycle in range(1, args.rounds + 1):
        for entry in entries:
            for branch in ["historical", "baseline"]:
                run(f"round-{cycle}-{entry['label']}-{branch}", branch, entry)
    record["completed"] = True
    record_path.write_text(json.dumps(record, indent=2) + "\n")
    print(
        f"Validated {len(record['builds'])} builds; cache retained for census: {target}"
    )


if __name__ == "__main__":
    main()
