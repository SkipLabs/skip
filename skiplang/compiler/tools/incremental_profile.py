#!/usr/bin/env python3
"""Bounded local compiler experiments and subprocess timing (Linux, Python stdlib).

run --root SCRATCH --label NAME -- COMMAND ... monitors a new process group.
wrap --kind KIND --real EXECUTABLE -- ARGS ... records one native/tool span.
The caller sets SKC_PROFILE_DIR to a run-specific directory when using wrappers.
No cleanup is implicit: outputs and the reason for any interruption are retained.
"""

import argparse
from collections import defaultdict
import fcntl
import gzip
import json
import os
from pathlib import Path
import resource
import signal
import subprocess
import sys
import threading
import time

GIB = 1024**3


def write_json(path, value):
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(value, indent=2) + "\n")
    temporary.replace(path)


def open_evidence(path):
    """Read original or losslessly compressed logs after scratch cleanup."""
    path = Path(path)
    if path.exists():
        return path.open(errors="replace")
    return gzip.open(path.with_name(path.name + ".gz"), "rt", errors="replace")


def append_event(directory, value):
    directory.mkdir(parents=True, exist_ok=True)
    with (directory / "processes.jsonl").open("a") as out:
        fcntl.flock(out, fcntl.LOCK_EX)
        out.write(json.dumps(value) + "\n")


def allocated_bytes(root):
    # du counts filesystem blocks and preserves sharing between hardlinks.
    # Temporary directories can disappear while du traverses them. Retry that
    # race, while preserving failures such as permission and I/O errors. A
    # completed total remains usable if only already-removed files were missed.
    for attempt in range(3):
        result = subprocess.run(
            ["du", "-s", "-B1", str(root)],
            text=True,
            capture_output=True,
            env=dict(os.environ, LC_ALL="C"),
        )
        if result.returncode == 0:
            return int(result.stdout.split()[0])
        errors = result.stderr.splitlines()
        vanished = errors and all(
            line.endswith(": No such file or directory") for line in errors
        )
        if not vanished or not Path(root).is_dir():
            result.check_returncode()
        if attempt == 2:
            return int(result.stdout.split()[0])


def group_memory(pgid):
    processes = []
    for entry in Path("/proc").iterdir():
        if not entry.name.isdigit():
            continue
        try:
            if os.getpgid(int(entry.name)) != pgid:
                continue
            fields = {}
            status = (entry / "status").read_text().splitlines()
            if any(
                line.startswith("State:") and line.split()[1] == "Z"
                for line in status
            ):
                continue
            for line in status:
                if line.startswith(("VmRSS:", "VmHWM:")):
                    k, v, _ = line.split()
                    fields[k[:-1]] = int(v) * 1024
            processes.append({"pid": int(entry.name), **fields})
        except (ProcessLookupError, PermissionError, FileNotFoundError):
            pass
    return processes


def stop_group(process):
    try:
        os.killpg(process.pid, signal.SIGTERM)
    except ProcessLookupError:
        return
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        pass
    # The leader can exit before its children. Always terminate remaining group
    # members, rather than leaving an orphaned clang or compiler consuming disk.
    try:
        os.killpg(process.pid, signal.SIGKILL)
    except ProcessLookupError:
        pass
    process.wait()
    deadline = time.monotonic() + 5
    while group_memory(process.pid) and time.monotonic() < deadline:
        time.sleep(0.01)


def monitored_run(args):
    root = args.root.resolve()
    root.mkdir(parents=True, exist_ok=True)
    out = root / "runs" / args.label
    out.mkdir(parents=True, exist_ok=False)
    env = dict(os.environ, SKC_PROFILE_DIR=str(out))
    before = allocated_bytes(root)
    available = os.statvfs(root).f_bavail * os.statvfs(root).f_frsize
    if available < args.reserve_gib * GIB or before >= args.disk_gib * GIB:
        raise RuntimeError("Insufficient disk headroom before experiment")
    start = time.monotonic_ns()
    metadata = {
        "command": args.command,
        "cwd": os.getcwd(),
        "start_ns": start,
        "limits": {
            "disk_gib": args.disk_gib,
            "reserve_gib": args.reserve_gib,
            "rss_gib": args.rss_gib,
            "timeout_s": args.timeout,
        },
        "allocated_before": before,
    }
    write_json(out / "run.json", metadata)
    reason = None
    peak = 0
    highwater = {}
    next_disk = 0
    next_status = 0
    with (out / "command.log").open("w") as log, (out / "resources.jsonl").open(
        "w"
    ) as samples:
        process = subprocess.Popen(
            args.command,
            env=env,
            stdout=log,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
        metadata["process_group"] = process.pid
        finished = threading.Event()
        completed = {}

        def wait_for_command():
            completed["returncode"] = process.wait()
            completed["end_ns"] = time.monotonic_ns()
            finished.set()

        waiter = threading.Thread(target=wait_for_command, daemon=True)
        waiter.start()
        try:
            while not finished.is_set():
                now = time.monotonic()
                children = group_memory(process.pid)
                rss = sum(p.get("VmRSS", 0) for p in children)
                peak = max(peak, rss)
                for p in children:
                    highwater[str(p["pid"])] = max(
                        highwater.get(str(p["pid"]), 0), p.get("VmHWM", 0)
                    )
                sample = {
                    "ns": time.monotonic_ns(),
                    "summed_rss": rss,
                    "processes": children,
                }
                if now >= next_disk:
                    size = allocated_bytes(root)
                    fs = os.statvfs(root)
                    free = fs.f_bavail * fs.f_frsize
                    sample.update(allocated=size, available=free)
                    next_disk = now + 10
                    if size > args.disk_gib * GIB:
                        reason = "scratch disk limit"
                    if free < args.reserve_gib * GIB:
                        reason = "filesystem reserve"
                if rss > args.rss_gib * GIB:
                    reason = "summed RSS limit"
                elapsed = (time.monotonic_ns() - start) / 1e9
                if elapsed > args.timeout:
                    reason = "time limit"
                samples.write(json.dumps(sample) + "\n")
                samples.flush()
                if now >= next_status:
                    print(
                        f"{args.label}: {elapsed:.0f}s; RAM {rss/GIB:.2f} GiB; "
                        f"scratch {size/GIB:.2f} GiB; free {free/GIB:.1f} GiB",
                        flush=True,
                    )
                    next_status = now + 30
                if reason:
                    stop_group(process)
                    break
                finished.wait(1)
        except BaseException as error:
            reason = f"monitor error: {type(error).__name__}: {error}"
            stop_group(process)
            raise
        finally:
            waiter.join(timeout=10)
            # A test runner can catch its own subprocess timeout, kill only a
            # wrapper, and exit while the compiler child is still running.
            # Completion must close the entire experiment, including that case.
            if group_memory(process.pid):
                if reason is None:
                    reason = "descendants remained after command exit"
                stop_group(process)
            try:
                after = allocated_bytes(root)
            except Exception as error:
                after = None
                reason = (
                    reason
                    or f"final disk scan error: {type(error).__name__}: {error}"
                )
            metadata.update(
                end_ns=completed.get("end_ns", time.monotonic_ns()),
                returncode=completed.get("returncode", process.poll()),
                interrupted=reason,
                sampled_peak_summed_rss=peak,
                sampled_process_highwater=highwater,
                allocated_after=after,
            )
            metadata["seconds"] = (metadata["end_ns"] - start) / 1e9
            write_json(out / "run.json", metadata)
    summary = {
        k: v for k, v in metadata.items() if k != "sampled_process_highwater"
    }
    summary["sampled_process_count"] = len(highwater)
    summary["report_path"] = str(out / "run.json")
    print(json.dumps(summary), flush=True)
    return 124 if reason else process.returncode


def wrapped_run(args):
    directory = Path(os.environ["SKC_PROFILE_DIR"])
    directory.mkdir(parents=True, exist_ok=True)
    kind = args.kind
    if kind == "clang":
        kind = (
            "clang_version"
            if "--version" in args.command
            else (
                "clang_compile"
                if "-c" in args.command
                else (
                    "clang_compile_link"
                    if any(
                        Path(a).suffix
                        in (
                            ".ll",
                            ".bc",
                            ".c",
                            ".cc",
                            ".cpp",
                            ".cxx",
                            ".s",
                            ".S",
                        )
                        for a in args.command
                    )
                    else "native_link"
                )
            )
        )
    command = [args.real, *args.command]
    # Optional wrapper around the verified original linker. This separates a
    # monolithic clang compile+link command without changing its compilation
    # flags or silently substituting a different linker implementation.
    linker = os.environ.get("SKC_PROFILE_LINKER")
    if linker and kind in ("native_link", "clang_compile_link"):
        if any(a.startswith(("-fuse-ld", "--ld-path")) for a in args.command):
            raise ValueError(
                "Explicit linker selection conflicts with profiling wrapper"
            )
        command.insert(1, "--ld-path=" + linker)
    stderr = directory / f"{kind}-{os.getpid()}.stderr"
    start = time.monotonic_ns()
    with stderr.open("wb") as stream:
        process = subprocess.Popen(command, stderr=stream)
        status = process.wait()
    end = time.monotonic_ns()
    usage = resource.getrusage(resource.RUSAGE_CHILDREN)
    append_event(
        directory,
        {
            "kind": kind,
            "wrapper_pid": os.getpid(),
            "pid": process.pid,
            "parent_pid": os.getppid(),
            "command": command,
            "cwd": os.getcwd(),
            "start_ns": start,
            "end_ns": end,
            "seconds": (end - start) / 1e9,
            "returncode": status,
            "user_s": usage.ru_utime,
            "system_s": usage.ru_stime,
            "maxrss_bytes": usage.ru_maxrss * 1024,
            "stderr": str(stderr),
        },
    )
    # Stream back without loading a verbose compiler log into memory. Stdout is
    # inherited unchanged, including Skargo's machine-readable link plan.
    with stderr.open("rb") as stream:
        while data := stream.read(65536):
            sys.stderr.buffer.write(data)
    return status if status >= 0 else 128 - status


def span_category(kind, name):
    if kind == "store":
        return {
            "sync": "Shared synchronization/collection",
            "lazy_retention": "Lazy collection retention",
        }.get(name, "Unattributed compiler/store work")
    if kind == "phase":
        return {
            "frontend/read_files": "Input loading",
            "frontend/config_and_archives": "Configuration/archive loading",
            "outer/makeOuter": "Outer IR",
            "specialization/classes": "Class specialization",
            "specialization/class_conflicts": "Class partition conflict analysis",
            "specialization/functions": "Function specialization",
            "specialization/sequential": "Sequential specialization",
            "specialization/round": "Specialization state forwarding/round work",
            "specialization/checkpoint": "Specialization state checkpoints",
            "specialization/latch": "Class relations",
            "specialization/scalarize": "Class scalarization",
            "specialization/layout": "Class field layout",
            "function-ir/class-publication": "IR shared publication",
            "function-ir/planning": "Function IR planning/identities",
            "function-ir/identities": "Function IR planning/identities",
            "function-ir/generic": "Generic function IR",
            "function-ir/instantiate": "Function IR generation",
            "native/compile": "Optimization/constants",
            "native/lower_functions": "Native lowering",
            "native/write_asm_files": "LLVM file rendering",
            "native/write_sklib": "Archive packaging",
            "native/layout_vtables": "Vtable layout",
            "native/create_asm_graph": "LLVM graph/symbols",
            "native/merge_asm_graph": "LLVM graph/symbols",
            "native/create_asm_symbols": "LLVM graph/symbols",
        }.get(name, "Phase: " + name)
    root = name.strip("/").split("/")[0]
    if name.startswith(("/llvm-emit/artifacts/", "/llvm-emit/build-plan/")):
        return "Artifact materialization"
    if root == "specializer":
        if name.startswith("/specializer/ir-"):
            return "IR assembly"
        # Construction has its own nested phase span. The lazy collection's
        # update arrow only drains invalidations. Reducers coordinate either
        # function or class work, including conflict validation and publication.
        # Keep their exclusive work visible instead of calling it class passes.
        if name.startswith("/specializer/class-attempts/"):
            return "Class attempt cache maintenance"
        if name.startswith("/specializer/class-requests/"):
            return "Class request routing"
        if name.startswith("/specializer/reduced1/"):
            return "Discovery coordination/publication"
        if name.startswith(
            (
                "/specializer/checkpoint/",
                "/specializer/ranges/",
                "/specializer/discovery-complete/",
            )
        ):
            return "Specialization state checkpoints"
        if "latch-classes" in name:
            return "Class relations"
        if "scalarize-fields" in name:
            return "Class scalarization"
        if any(
            p in name
            for p in ["layout-fields", "layout-shapes", "layout-groups"]
        ):
            return "Class field layout"
        if "function-ir-plan" in name or "function-identit" in name:
            return "Function IR planning/identities"
        if "generic-function-ir" in name:
            return "Generic function IR"
        if "function-ir-shared" in name:
            return "IR shared publication"
        if "function-ir" in name:
            return "Function IR generation"
        return "Specialization discovery bookkeeping"
    if name.startswith(("/optimizer/const-", "/optimizer/lower-const/")):
        return "Constant lowering"
    groups = {
        "Parsing": ["astandaccessedenvvarscache", "astcache"],
        "Source positions": ["sourcepositions", "sourcepositionanchors"],
        "Naming/expansion": [
            "modulemap1",
            "modulemap2",
            "modulemap3",
            "modulecache1",
            "modulecache",
            "modulemembers",
            "defmap1",
            "defmap",
            "childcache",
            "checkcycle",
            "namingclasses",
            "namingconsttypes",
            "namingfuns",
            "namingfunsbyannotation",
            "funsdefsproj",
            "constsdefsproj",
            "namingclassmembers",
            "namingclasstypes",
            "namingcopydownpolicy",
        ],
        "Inheritance": ["inheritclasses"],
        "Type checking": ["typing"],
        "Outer IR": ["outerdefs", "outerdeclarations", "lowerdefs"],
        "IR assembly": ["backendphase2"],
        "Optimization/constants": ["optimizer", "backendoptimize"],
        "Reachability/escape": ["reachability", "backendreachable"],
        "Native lowering": ["native-lower", "backendlower"],
        "LLVM graph/symbols": ["llvm-graph", "backendgraph"],
        "LLVM emission": ["llvm-emit"],
        "Artifact materialization": ["backendemit"],
        "Backend preparation": [
            "backendphase1",
            "backendsink",
            "specialization-config",
        ],
        "Input loading": ["filecache", "packageenvaccess"],
    }
    for category, names in groups.items():
        if root in names:
            return category
    return "Other directory: " + root


def clang_object_intervals(commands, *, allow_parallel=False):
    """Return active elapsed intervals and separate work/concurrency counters.

    This permits overlap only between Clang object commands. The caller must
    combine the returned intervals with the other compiler/process spans and
    retain the ordinary nesting/reconciliation checks for that complete set.
    Adjacent intervals stay separate: they can belong to different serial
    compiler phases. A union interval is elapsed occupancy, not CPU time.
    """
    intervals = []
    boundaries = defaultdict(int)
    summed_ns = 0
    for start, end in commands:
        if end < start:
            raise ValueError("Negative Clang command duration")
        summed_ns += end - start
        if end > start:
            intervals.append((start, end))
            boundaries[start] += 1
            boundaries[end] -= 1
    active = peak = 0
    for _, change in sorted(boundaries.items()):
        active += change
        peak = max(peak, active)
    if peak > 1 and not allow_parallel:
        raise ValueError(
            "Parallel Clang objects require explicit elapsed-union accounting"
        )
    union = []
    for start, end in sorted(intervals):
        if union and start < union[-1][1]:
            union[-1] = (union[-1][0], max(union[-1][1], end))
        else:
            union.append((start, end))
    return union, {
        "invocations": len(commands),
        "summed_ns": summed_ns,
        "active_elapsed_ns": sum(end - start for start, end in union),
        "maximum_concurrency": peak,
    }


def exclusive_totals(spans):
    """Exclusive elapsed accounting for serial nested spans; reject crossing spans.

    Only explicitly approved Clang object intervals may be unioned before this
    function. All remaining spans must nest; arbitrary overlap is still an error.
    """
    totals = defaultdict(int)
    counts = defaultdict(int)
    stack = []
    for start, end, category in sorted(spans, key=lambda s: (s[0], -s[1])):
        if end < start:
            raise ValueError("Negative span duration")
        while stack and start >= stack[-1][1]:
            stack.pop()
        if stack:
            if end > stack[-1][1]:
                raise ValueError(
                    "Crossing/parallel spans cannot use serial accounting"
                )
            totals[stack[-1][2]] -= end - start
        totals[category] += end - start
        counts[category] += 1
        stack.append((start, end, category))
    return dict(totals), dict(counts)


def report_run(args):
    directory = args.directory.resolve()
    run = json.loads((directory / "run.json").read_text())
    # A killed wrapper may never publish its completion event. Its compiler
    # time cannot then be distinguished from driver time; do not mislabel it.
    outside = (
        "Unattributed interrupted work"
        if run.get("interrupted")
        else "Build driver/outside compiler"
    )
    spans = [(run["start_ns"], run["end_ns"], outside)]
    raw_spans = list(spans)
    events = directory / "processes.jsonl"
    processes = []
    if events.exists() or events.with_name(events.name + ".gz").exists():
        with open_evidence(events) as stream:
            processes = [json.loads(line) for line in stream]
    labels = {
        "skc": "Compiler startup/unscoped",
        "clang_compile": "Clang object compilation",
        "clang_compile_link": "Clang compilation/driver",
        "linker": "Final native linking",
        "native_link": "Clang link driver",
        "clang_version": "Clang version probes",
        "archive": "Archive tools",
    }
    sharing = []
    rows = []
    audits = []
    isolation = []
    class_attempts = []
    class_groups = []
    class_seeds = []
    class_policies = []
    variance = []
    clang_commands = []
    for p in processes:
        if p["kind"] == "clang_compile":
            clang_commands.append((p["start_ns"], p["end_ns"]))
        else:
            spans.append(
                (p["start_ns"], p["end_ns"], labels.get(p["kind"], p["kind"]))
            )
            raw_spans.append(spans[-1])
        if p["kind"] == "skc":
            sequential = (
                "--no-incremental-backend" in p["command"]
                or "--release" in p["command"]
                or not any(
                    a == flag or a.startswith(flag + "=")
                    for a in p["command"]
                    for flag in ["--init", "--data"]
                )
            )
            separate_discovery_span = False
            with open_evidence(p["stderr"]) as stream:
                for line in stream:
                    if line.startswith("##CLASS_GROUP_POLICY## "):
                        _, streaming, hints = line.split()
                        if streaming not in ("0", "1") or hints not in (
                            "0",
                            "1",
                        ):
                            raise ValueError(
                                "Invalid class-group policy record"
                            )
                        class_policies.append(
                            dict(
                                pid=p["pid"],
                                streaming=streaming == "1",
                                hints=hints == "1",
                            )
                        )
                    if line.startswith("##CLASS_GROUP_SEED## "):
                        _, round_, families, groups, prior = line.split()
                        if prior not in ("true", "false"):
                            raise ValueError("Invalid class-group seed record")
                        class_seeds.append(
                            dict(
                                pid=p["pid"],
                                round=int(round_),
                                requested_families=int(families),
                                initial_groups=int(groups),
                                had_prior_hint=prior == "true",
                            )
                        )
                    if line.startswith("##VARIANCE## "):
                        _, indexed, calls, comparisons = line.split()
                        if indexed not in ("true", "false"):
                            raise ValueError("Invalid variance policy counter")
                        variance.append(
                            dict(
                                pid=p["pid"],
                                indexed=indexed == "true",
                                calls=int(calls),
                                comparisons=int(comparisons),
                            )
                        )
                    if line.startswith("##CLASS_GROUP_ATTEMPT## "):
                        fields = [
                            "round",
                            "families",
                            "constructed",
                            "reads",
                            "writes",
                        ]
                        values = list(map(int, line.split()[1:]))
                        if len(values) != len(fields):
                            raise ValueError(
                                "Invalid class-group attempt record"
                            )
                        class_attempts.append(
                            dict(pid=p["pid"], **dict(zip(fields, values)))
                        )
                    if line.startswith("##CLASS_GROUPS## "):
                        fields = [
                            "round",
                            "initial_groups",
                            "accepted_groups",
                            "passes",
                        ]
                        values = list(map(int, line.split()[1:]))
                        if len(values) != len(fields):
                            raise ValueError(
                                "Invalid class-group validation record"
                            )
                        class_groups.append(
                            dict(pid=p["pid"], **dict(zip(fields, values)))
                        )
                    if line.startswith("##CLASS_ISOLATION## "):
                        names = [
                            "round",
                            "requests",
                            "initial_groups",
                            "accepted_groups",
                            "largest_families",
                            "passes",
                            "attempts",
                            "constructed",
                            "redundant_contributions",
                        ]
                        values = list(map(int, line.split()[1:]))
                        if len(values) not in (len(names) - 1, len(names)):
                            raise ValueError("Invalid class isolation record")
                        isolation.append(
                            dict(pid=p["pid"], **dict(zip(names, values)))
                        )
                    if line.startswith("##CLASS_AUDIT## "):
                        names = [
                            "round",
                            "requests",
                            "families",
                            "components",
                            "largest_families",
                            "largest_requests",
                            "created",
                            "keys",
                            "reads",
                            "writes",
                            "absent",
                            "partial",
                            "cross_partial",
                            "conflict_keys",
                        ]
                        values = list(map(int, line.split()[1:]))
                        if len(values) != len(names):
                            raise ValueError("Invalid class audit record")
                        audits.append(
                            dict(pid=p["pid"], **dict(zip(names, values)))
                        )
                    if line.startswith("##ROWS## "):
                        _, tick, checkpoint, owner, keys = line.split()
                        rows.append(
                            {
                                "pid": p["pid"],
                                "tick": int(tick),
                                "checkpoint": checkpoint,
                                "owner": owner,
                                "keys": int(keys),
                            }
                        )
                    if line.startswith("##SHARE## "):
                        _, members, groups, comparisons, duration = line.split()
                        sharing.append(
                            {
                                "members": int(members),
                                "groups": int(groups),
                                "comparisons": int(comparisons),
                                "ns": int(duration),
                            }
                        )
                    if line.startswith("##SPAN## "):
                        _, start, end, kind, name = line.split(maxsplit=4)
                        start, end = int(start), int(end)
                        if not p["start_ns"] <= start <= end <= p["end_ns"]:
                            raise ValueError(
                                "Compiler spans and process clocks do not agree"
                            )
                        name = name.strip()
                        separate_discovery_span |= (
                            name == "specialization/sequential"
                        )
                        category = span_category(kind, name)
                        if (
                            category == "IR assembly"
                            and sequential
                            and not separate_discovery_span
                        ):
                            category = "Sequential specialization/IR assembly"
                        spans.append((start, end, category))
                        raw_spans.append((start, end, kind + " " + name))
    clang_union, clang_work = clang_object_intervals(
        clang_commands, allow_parallel=getattr(args, "parallel_clang", False)
    )
    clang_spans = [
        (start, end, labels["clang_compile"]) for start, end in clang_union
    ]
    spans.extend(clang_spans)
    raw_spans.extend(clang_spans)
    totals, counts = exclusive_totals(spans)
    assert sum(totals.values()) == run["end_ns"] - run["start_ns"]
    raw_totals, raw_counts = exclusive_totals(raw_spans)
    assert sum(raw_totals.values()) == run["end_ns"] - run["start_ns"]
    write_json(
        directory / "raw-phases.json",
        {
            key: {"seconds": value / 1e9, "visits": raw_counts[key]}
            for key, value in sorted(
                raw_totals.items(), key=lambda row: -row[1]
            )
        },
    )
    result = {
        "seconds": run["seconds"],
        "successful": run["returncode"] == 0 and not run["interrupted"],
        "exclusive_seconds": {k: v / 1e9 for k, v in sorted(totals.items())},
        "span_counts": counts,
        "process_count": len(processes),
        "sampled_peak_summed_rss": run["sampled_peak_summed_rss"],
        "allocated_after": run["allocated_after"],
        "clang_object_work": {
            "invocations": clang_work["invocations"],
            "summed_seconds": clang_work["summed_ns"] / 1e9,
            "active_elapsed_seconds": clang_work["active_elapsed_ns"] / 1e9,
            "maximum_concurrency": clang_work["maximum_concurrency"],
            "parallel_accounting": getattr(args, "parallel_clang", False),
            "scope": "Active elapsed interval union, not CPU time or a proven critical path. "
            "Clang span_counts counts active intervals; invocations counts commands.",
        },
    }
    # One-second tree sampling can miss an entire short compiler invocation.
    # Linux wait4 supplies a process/descendant high-water mark even in that
    # case. Keep the two measurements separate: high-water marks cannot be
    # summed to reconstruct concurrent process-tree residency.
    highwater_by_kind = {}
    for process in processes:
        if process.get("maxrss_bytes") is not None:
            kind = process["kind"]
            highwater_by_kind[kind] = max(
                highwater_by_kind.get(kind, 0), process["maxrss_bytes"]
            )
    if highwater_by_kind:
        result["wait4_maxrss_bytes_by_kind"] = highwater_by_kind
        result["highest_process_maxrss_bytes"] = max(highwater_by_kind.values())
        result["wait4_maxrss_scope"] = (
            "Linux process/descendant high-water marks; not simultaneous summed RSS. "
            "A compiler invocation can include its native compiler descendants."
        )
    if sharing:
        result["sharing_groups"] = {
            "callbacks": len(sharing),
            "candidate_definitions": sum(s["members"] for s in sharing),
            "largest_group": max(s["members"] for s in sharing),
            "exact_comparisons": sum(s["comparisons"] for s in sharing),
            "slowest_callback_s": max(s["ns"] for s in sharing) / 1e9,
            "callback_total_s": sum(s["ns"] for s in sharing) / 1e9,
        }
    if class_attempts or class_groups or class_seeds or class_policies:
        write_json(
            directory / "class-group-work.json",
            {
                "attempts": class_attempts,
                "validation_rounds": class_groups,
                "seeded_rounds": class_seeds,
                "policies": class_policies,
            },
        )
        result["class_group_work"] = {
            "executed_attempts": len(class_attempts),
            "constructed_classes": sum(
                row["constructed"] for row in class_attempts
            ),
            "largest_attempt_families": max(
                (row["families"] for row in class_attempts), default=0
            ),
            "largest_attempt_reads": max(
                (row["reads"] for row in class_attempts), default=0
            ),
            "validation_rounds": len(class_groups),
            "seeded_rounds_with_prior_hint": sum(
                row["had_prior_hint"] for row in class_seeds
            ),
            "maximum_validation_passes": max(
                (row["passes"] for row in class_groups), default=0
            ),
        }
    persistent = []
    outputs = [
        (p["pid"], Path(p["stdout"])) for p in processes if p.get("stdout")
    ]
    if not outputs:
        outputs = [(None, directory / "command.log")]
    for pid, path in outputs:
        with open_evidence(path) as stream:
            for line in stream:
                if line.startswith("##PERSISTENT## "):
                    _, tick, checkpoint, size = line.split()
                    persistent.append(
                        {
                            "pid": pid,
                            "tick": int(tick),
                            "checkpoint": checkpoint,
                            "live_bytes": int(size),
                        }
                    )
    if persistent:
        result["persistent_checkpoints"] = persistent
    if rows:
        # Key counts describe ownership shape; they are not byte attribution.
        # Values/rows may be shared between directories and producers.
        write_json(directory / "row-owners.json", rows)
        result["completed_key_counts"] = [
            r for r in rows if r["checkpoint"] == "complete"
        ]
    if audits:
        result["class_work_audits"] = audits
    if isolation:
        result["class_isolation_attempts"] = isolation
    if variance:
        write_json(directory / "variance-work.json", variance)
        result["variance_work"] = {}
        for indexed, policy in [(False, "full_scan"), (True, "indexed")]:
            records = [
                record for record in variance if record["indexed"] == indexed
            ]
            if records:
                result["variance_work"][policy] = dict(
                    callbacks=len(records),
                    scans=sum(r["calls"] for r in records),
                    instance_comparisons=sum(r["comparisons"] for r in records),
                    largest_callback_comparisons=max(
                        r["comparisons"] for r in records
                    ),
                )
    write_json(directory / "phases.json", result)
    # Keep the complete diagnostics in the artifact, not thousands of repeated
    # directory/checkpoint records in the caller's terminal transcript.
    display = {
        key: value
        for key, value in result.items()
        if key
        not in (
            "persistent_checkpoints",
            "completed_key_counts",
            "class_work_audits",
            "class_isolation_attempts",
        )
    }
    display["diagnostics"] = {
        key: len(result[key])
        for key in (
            "persistent_checkpoints",
            "completed_key_counts",
            "class_work_audits",
            "class_isolation_attempts",
        )
        if key in result
    }
    display["report_path"] = str(directory / "phases.json")
    print(json.dumps(display, indent=2))
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="mode", required=True)
    run = sub.add_parser("run")
    run.add_argument("--root", type=Path, required=True)
    run.add_argument("--label", required=True)
    run.add_argument("--disk-gib", type=float, default=100)
    run.add_argument("--reserve-gib", type=float, default=64)
    run.add_argument("--rss-gib", type=float, default=48)
    run.add_argument("--timeout", type=float, default=7200)
    run.add_argument("command", nargs=argparse.REMAINDER)
    wrap = sub.add_parser("wrap")
    wrap.add_argument("--kind", required=True)
    wrap.add_argument("--real", required=True)
    wrap.add_argument("command", nargs=argparse.REMAINDER)
    report = sub.add_parser("report")
    report.add_argument("directory", type=Path)
    report.add_argument(
        "--parallel-clang",
        action="store_true",
        help="Union overlapping Clang object commands; retain all other nesting checks",
    )
    args = parser.parse_args()
    if args.mode == "report":
        return report_run(args)
    if args.command and args.command[0] == "--":
        args.command.pop(0)
    if not args.command and args.mode == "run":
        parser.error("A command is required")
    if args.mode == "run" and (
        Path(args.label).name != args.label or args.label in (".", "..")
    ):
        parser.error("label must be one directory name")
    return monitored_run(args) if args.mode == "run" else wrapped_run(args)


if __name__ == "__main__":
    sys.exit(main())
