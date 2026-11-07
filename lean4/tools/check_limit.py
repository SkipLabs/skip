#!/usr/bin/env python3
"""Independently check exported edit results and summarize Skip benchmark samples.

This is validation tooling, not the elaborator or its cache implementation.
Source the pinned native Lean build's env.sh before running it.
"""
import argparse
import copy
import json
from pathlib import Path
import statistics
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parent.parent
EXPECTED = {
    "initial": (True, True),
    "no-op": (True, False),
    "noise-100": (True, False),
    "limit-4": (True, True),
    "limit-30": (False, True),
    "delete-limit": (False, True),
    "later-limit": (False, False),
    "restore-limit": (True, True),
    "same-limit": (True, False),
    "noise-101": (True, False),
}


def kernel_check(path, accepted):
    result = subprocess.run(
        ["lean", "--run", str(ROOT / "tools/CheckProof.lean"), str(path)],
        cwd=ROOT, capture_output=True, text=True,
    )
    marker = ("Native Lean kernel accepted the Skip-produced proof" if accepted
              else "Native Lean kernel rejected the Skip-produced proof")
    if result.returncode != (0 if accepted else 1) or marker not in result.stdout + result.stderr:
        raise RuntimeError(f"Unexpected kernel result for {path}:\n{result.stdout}{result.stderr}")


def replace_three(node):
    if node == ["nat", "3"]:
        return ["nat", "30"]
    if isinstance(node, list):
        return [replace_three(child) for child in node]
    return node


def distribution(values):
    assert values and all(isinstance(value, int) and value > 0 for value in values)
    ordered = sorted(values)
    return {
        "minNs": ordered[0],
        "medianNs": statistics.median(values),
        "p95Ns": ordered[(len(ordered) * 95 + 99) // 100 - 1],
        "maxNs": ordered[-1],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path, nargs="?", default=ROOT / "build")
    args = parser.parse_args()
    directory = args.directory.resolve()
    edits = json.loads((directory / "limit-edits.json").read_text())
    assert [event["edit"] for event in edits["events"]] == list(EXPECTED)
    for event in edits["events"]:
        label = event["edit"]
        assert (event["accepted"], event["recomputed"]) == EXPECTED[label], event
        if event["accepted"]:
            kernel_check(directory / f"limit-{label}.json", True)
    # Check that the independent validator detects the exact stale-proof bug
    # the relevant-edit test is intended to prevent.
    original = json.loads((directory / "limit-initial.json").read_text())
    stale = copy.deepcopy(original)
    definition = next(value for value in stale["definitions"]
                      if value["name"] == ["str", ["anonymous"], "limit"])
    definition["value"] = replace_three(definition["value"])
    assert stale != original
    with tempfile.TemporaryDirectory(prefix="lean-skip-proof-") as tmp:
        path = Path(tmp) / "stale.json"
        path.write_text(json.dumps(stale))
        kernel_check(path, False)
        # Native source elaboration is used only as an independent failure
        # reference, never as the computation measured or cached by Skip.
        references = [
            ("false", "def limit : Nat := 30\n", "is false"),
            ("missing", "set_option autoImplicit false\n", "Unknown identifier `limit`"),
        ]
        for label, prefix, diagnostic in references:
            source = Path(tmp) / f"{label}.lean"
            source.write_text(prefix + "def noise : Nat := 100\n"
                              "theorem result : limit < 10 := by decide\n")
            result = subprocess.run(["lean", str(source)], cwd=ROOT,
                                    capture_output=True, text=True)
            assert result.returncode == 1 and diagnostic in result.stdout + result.stderr, result
    print("10 edit cases checked; 7 proofs kernel-accepted; stale proof rejected; 2 native failure references matched")

    benchmark_path = directory / "limit-benchmark.json"
    if not benchmark_path.exists():
        print("No warmed benchmark report is available")
        return
    benchmark = json.loads(benchmark_path.read_text())
    assert benchmark["schema"] == 1
    assert [group["edit"] for group in benchmark["groups"]] == ["no-op", "noise", "limit"]
    summaries = []
    for group in benchmark["groups"]:
        count = group["samples"]
        assert count == len(group["incrementalNs"]) == len(group["freshNs"]) == group["freshExecutions"]
        assert group["incrementalExecutions"] == (count if group["edit"] == "limit" else 0)
        assert group["warmup"] >= 10
        incremental = distribution(group["incrementalNs"])
        fresh = distribution(group["freshNs"])
        speedup = fresh["medianNs"] / incremental["medianNs"]
        summaries.append({
            "edit": group["edit"], "samples": count, "warmup": group["warmup"],
            "incremental": incremental, "fresh": fresh, "medianSpeedup": speedup,
            "incrementalExecutions": group["incrementalExecutions"],
            "freshExecutions": group["freshExecutions"],
            "rssBefore": group["rssBefore"], "rssAfter": group["rssAfter"],
        })
        print(f"{group['edit']}: median incremental {incremental['medianNs']/1e6:.4f} ms, "
              f"fresh {fresh['medianNs']/1e6:.4f} ms, ratio {speedup:.1f}x")
    summary = {
        "leanCommit": benchmark["leanCommit"],
        "importLoadNs": edits["importLoadNs"], "coldSetupNs": edits["coldSetupNs"],
        "groups": summaries,
        "baseline": benchmark["baseline"], "included": benchmark["included"],
        "excluded": benchmark["excluded"], "rssNote": benchmark["rssNote"],
        "validation": "10 edit cases; 7 kernel-accepted proofs; stale proof rejected; 2 native failure references matched",
    }
    (directory / "limit-summary.json").write_text(json.dumps(summary, indent=2) + "\n")


if __name__ == "__main__":
    main()
