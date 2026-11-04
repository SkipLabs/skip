#!/usr/bin/env python3
"""Bounded, byte-exact LLVM diagnostics, never used for artifact cache decisions."""

import difflib
import hashlib
import json
from pathlib import Path
import re
import shutil

SYMBOL = re.compile(rb'@("(?:[^"\\]|\\.)*"|[-a-zA-Z$._0-9]+)\(')
LIMIT = 512 * 1024**2
DBG_INSTRUCTION = re.compile(rb", !dbg ![0-9]+(?=(?:, !|\r?$))", re.MULTILINE)
DBG_HEADER = re.compile(rb" !dbg ![0-9]+(?= \{\r?$)", re.MULTILINE)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def without_dbg_attachments(header, body):
    """Diagnostic text classification only; source-location changes still matter."""
    return DBG_HEADER.sub(b"", header) + DBG_INSTRUCTION.sub(b"", body)


def compile_directories(processes, target, require_inputs=True):
    target = Path(target).resolve()
    result = set()
    for line in Path(processes).read_text().splitlines():
        row = json.loads(line)
        if row.get("kind") != "clang_compile":
            continue
        for argument in row["command"]:
            path = Path(argument)
            if path.suffix != ".ll":
                continue
            if not path.is_absolute():
                path = Path(row["cwd"]) / path
            path = path.resolve()
            assert path.is_relative_to(target), path
            result.add(path.parent.relative_to(target))
    assert result or not require_inputs, "No LLVM object compilation recorded"
    return sorted(result)


def snapshot(target, directories, destination):
    """Copy only LLVM files, with explicit bounds and no hard links."""
    target, destination = Path(target).resolve(), Path(destination)
    assert not destination.exists()
    assert shutil.disk_usage(destination.parent).free >= 64 * 1024**3
    files = sorted({p for d in directories for p in (target / d).glob("*.ll")})
    assert files
    size = sum(p.stat().st_size for p in files)
    assert size <= LIMIT, (size, LIMIT)
    manifest = {}
    destination.mkdir()
    for source in files:
        assert not source.is_symlink() and source.resolve().is_relative_to(
            target
        )
        relative = source.relative_to(target)
        output = destination / relative
        output.parent.mkdir(parents=True, exist_ok=True)
        contents = source.read_bytes()
        output.write_bytes(contents)
        manifest[str(relative)] = dict(
            bytes=len(contents), sha256=sha(contents)
        )
    assert sum(row["bytes"] for row in manifest.values()) <= LIMIT
    return dict(files=manifest, bytes=size)


def definitions(data):
    """Read the compiler's one-line LLVM definition headers and closing braces."""
    result, outside, current = {}, [], None
    for line in data.splitlines(keepends=True):
        if current is None:
            if line.startswith(b"define "):
                match = SYMBOL.search(line)
                assert match is not None and line.rstrip().endswith(b"{"), line[
                    :200
                ]
                name = match[1].decode("utf-8")
                assert name not in result, name
                current = [name, line, []]
            else:
                outside.append(line)
        elif line.strip() == b"}":
            name, header, body = current
            result[name] = (header, b"".join(body) + line)
            current = None
        else:
            current[2].append(line)
    assert current is None, "Unterminated LLVM definition"
    return result, b"".join(outside)


def bounded_diff(a, b):
    """Avoid quadratic diff work on huge support modules or generated functions."""
    left, right = a.decode("utf-8").splitlines(), b.decode("utf-8").splitlines()
    common = 0
    while common < min(len(left), len(right)) and left[common] == right[common]:
        common += 1
    start = max(0, common - 2)
    lines = []
    for line in difflib.unified_diff(
        left[start : start + 120], right[start : start + 120], n=2
    ):
        lines.append(line[:500])
        if len(lines) == 60:
            break
    return dict(
        start_line=start + 1,
        diff=lines,
        limit="A 120-line window at the first difference; first 60 diff lines, "
        "at most 500 characters each. Counts and hashes remain exact.",
    )


def compare(before, after, example_limit=12):
    before, after = Path(before), Path(after)
    left = {str(p.relative_to(before)): p for p in before.rglob("*.ll")}
    right = {str(p.relative_to(after)): p for p in after.rglob("*.ll")}
    assert sum(p.stat().st_size for p in left.values()) <= LIMIT
    assert sum(p.stat().st_size for p in right.values()) <= LIMIT
    modules, examples, outside_examples = [], [], []
    debug_text_only = 0
    totals = dict(
        modules_unchanged=0,
        modules_changed=0,
        modules_added=0,
        modules_removed=0,
        functions_unchanged=0,
        function_bodies_changed=0,
        function_headers_only_changed=0,
        functions_added=0,
        functions_removed=0,
        outside_functions_changed=0,
    )
    for name in sorted(left.keys() | right.keys()):
        a = left[name].read_bytes() if name in left else b""
        b = right[name].read_bytes() if name in right else b""
        fa, oa = definitions(a)
        fb, ob = definitions(b)
        state = (
            "added"
            if name not in left
            else (
                "removed"
                if name not in right
                else "unchanged" if a == b else "changed"
            )
        )
        totals["modules_" + state] += 1
        counts = dict(
            functions_unchanged=0,
            function_bodies_changed=0,
            function_headers_only_changed=0,
            functions_added=len(fb.keys() - fa.keys()),
            functions_removed=len(fa.keys() - fb.keys()),
            outside_functions_changed=int(oa != ob),
        )
        if oa != ob and len(outside_examples) < 4:
            outside_examples.append(dict(module=name, **bounded_diff(oa, ob)))
        for symbol in sorted(fa.keys() & fb.keys()):
            ha, ba = fa[symbol]
            hb, bb = fb[symbol]
            kind = (
                "function_bodies_changed"
                if ba != bb
                else (
                    "function_headers_only_changed"
                    if ha != hb
                    else "functions_unchanged"
                )
            )
            counts[kind] += 1
            same_without_dbg = (
                kind != "functions_unchanged"
                and without_dbg_attachments(ha, ba)
                == without_dbg_attachments(hb, bb)
            )
            debug_text_only += int(same_without_dbg)
            if kind != "functions_unchanged" and len(examples) < example_limit:
                examples.append(
                    dict(
                        module=name,
                        symbol=symbol,
                        kind=kind,
                        equal_without_dbg_attachments=same_without_dbg,
                        **bounded_diff(ha + ba, hb + bb)
                    )
                )
        for key, value in counts.items():
            totals[key] += value
        modules.append(
            dict(
                module=name,
                state=state,
                before_bytes=len(a),
                after_bytes=len(b),
                before_sha256=sha(a),
                after_sha256=sha(b),
                **counts
            )
        )
    return dict(
        totals=totals,
        modules=modules,
        examples=examples,
        outside_examples=outside_examples,
        diagnostic_counts=dict(
            changed_functions_equal_without_dbg_attachments=debug_text_only
        ),
        diagnostic_limit="Equality after omitting !dbg attachments does not establish semantic "
        "equality: source locations may have changed. Never used for cache decisions.",
        semantics="Byte-exact comparison. Function identities are scoped to their module; "
        "moves appear as additions/removals. Comments, attributes, debug IDs and "
        "numeric SSA names are retained. No normalization or cache reuse occurs.",
    )
