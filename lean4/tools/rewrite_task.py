#!/usr/bin/env python3
"""Prepare a bounded, hashed Vibe rewrite or probe packet from maintained Skip.

This tool writes a new task directory only. It does not launch Vibe, invoke a
compiler, regenerate code, or alter the maintained implementation.
"""
from __future__ import annotations

import argparse
from collections import defaultdict
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
import re
from typing import Mapping, Sequence

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MAX_BYTES = 128 * 1024
OUTPUT_FILES = ["Replacement.sk", "Probe.sk", "REVIEW.md"]
MODE_OUTPUT_FILES = {
    "rewrite": OUTPUT_FILES,
    "probe": ["Probe.sk", "REVIEW.md"],
}
RESERVED_FILES = frozenset(OUTPUT_FILES + [
    "Original.sk", "Assignment.md", "HelperContracts.md", "HelperBodies.sk",
    "Reference.lean", "ExistingProbe.sk", "task.md", "input-manifest.json", ".vibe",
])
FunctionRecord = tuple[Path, int, int, str, set[str]]
NON_CODE = re.compile(r'"(?:\\.|[^"\\])*"|//[^\n]*|/\*[\s\S]*?\*/')
FUNCTION_NAME = re.compile(r"L4_\w+\.(?:apply_)?f_\w+\Z")


@dataclass(frozen=True)
class Packet:
    files: dict[str, bytes]
    summary: dict


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def signature(body: str) -> str:
    """Keep the original declaration header, including defaults and return type."""
    code = NON_CODE.sub(lambda match: " " * len(match[0]), body)
    declaration = re.search(r"\bfun\s+(?:apply_)?f_\w+\s*\(", code)
    if declaration is None:
        raise ValueError("Cannot find a maintained function declaration")
    parentheses = brackets = 0
    for index in range(declaration.start(), len(code)):
        char = code[index]
        if char == "(":
            parentheses += 1
        elif char == ")":
            parentheses -= 1
        elif char == "[":
            brackets += 1
        elif char == "]":
            brackets -= 1
        elif char == "{" and parentheses == 0 and brackets == 0:
            return body[:index].rstrip()
    raise ValueError("Cannot find the function body after its signature")


def source_name(path: Path, repository: Path) -> str:
    if not path.is_absolute():
        return path.as_posix()
    try:
        return path.relative_to(repository).as_posix()
    except ValueError:
        raise ValueError(f"Catalog source is outside the repository: {path}") from None


def worker_instructions(function: str, inputs: Sequence[str], skill: str, mode: str) -> str:
    module, simple = function.split(".", 1)
    reading = ", ".join(f"`{name}`" for name in inputs)
    outputs = ", ".join(f"`{name}`" for name in MODE_OUTPUT_FILES[mode])
    if mode == "rewrite":
        task_contract = f"""Implement `{function}` with its exact ABI in `module {module};`.
Return actual executable Skip; use readable internal `f_` helpers only when they
form a meaningful boundary. Do not copy the old frame body into Replacement.sk.
Keep direct calls direct and preserve all functions and explicit unsupported errors.
Removing frame arrays is separate from typed representation conversion:
document boxed boundaries honestly.

The coordinator retains the old body as `{simple}_fallback` and redirects its
recursive self-calls to that retained identity. Probe.sk may call both qualified
identities.

REVIEW.md must list the old/new function map, helper argument roles, branch/effect
correspondence, fixture expectations, remaining boundaries and gaps, and checks
actually run."""
    else:
        task_contract = f"""Write test code only for the unchanged current function `{function}`.
Original.sk is the exact current implementation under test. Do not implement,
replace, or edit that function or its helpers. Produce executable tests in Probe.sk
and a coverage report in REVIEW.md; do not produce replacement source.

Call the existing canonical identity. Use a retained oracle only when Assignment.md
explicitly supplies its exact identity; never invent or assume a fallback name.
Independent expected outcomes are essential: matching two implementations can
share the same bug. Assert expected success/error and specific returned facts,
state changes, and preserved state, not only old/current result equality.

REVIEW.md must list the cases and branches exercised, the source of each expected
outcome, helper argument roles, fixture validity, shared-oracle limitations,
unsupported and untested branches, and checks actually run."""
    return f"""# {mode.capitalize()} task

Mode: `{mode}`.

Read {reading}. `Assignment.md` and any role-contract files define this task's
scope and argument roles. Use only files in this task directory. The policy
source is [lean-skip-refactor]({skill}); this link is for the coordinator,
not an instruction to read outside the packet. Relevant constraints follow here.

Write only {outputs} with Vibe's enabled `write_file`/`edit` tools.
Read with `read_file`/`grep`. Do not run shell commands, launch agents, change inputs,
or access production, compiler caches, credentials, or paths outside the task
directory. The coordinator owns integration and checks.

{task_contract}

Use domain names and structured control flow, with light comments only for subtle
invariants. Respect Meta/Core context and state-reference roles, world and error
order, short-circuiting, cache policy, arbitrary-precision Nat and fixed-width
wrapping, equality mode, DAG sharing, and immutable publication/backtracking.
Never invent signatures or success stubs. Do not modify Skip's compiler/runtime
or revive the historical transpiler.

Use real initialized state and valid positive fixtures; assert expected success/error,
returned values/world, and semantic reference state. Identify shared helpers and
unsupported or untested branches. Missing contracts belong in the report as concrete
gaps, not fabricated implementations. Do not claim compilation or execution:
the coordinator runs those.
Report an incomplete handoff explicitly if required behavior remains unresolved.
"""


def build_packet(
    functions: Mapping[str, FunctionRecord],
    *,
    function: str,
    task: str,
    assignment: str,
    mode: str = "rewrite",
    repository: Path = ROOT,
    reference: str | None = None,
    reference_origin: str | None = None,
    probe: str | None = None,
    role_contracts: Sequence[str] = (),
    support_files: Sequence[tuple[str, bytes]] = (),
    helper_bodies: Sequence[str] = (),
    max_bytes: int = DEFAULT_MAX_BYTES,
) -> Packet:
    """Build an in-memory packet; callers can supply a tiny catalog for tests."""
    if mode not in MODE_OUTPUT_FILES:
        raise ValueError("Packet mode must be 'rewrite' or 'probe'")
    if not FUNCTION_NAME.fullmatch(function):
        raise ValueError("--function must be a qualified L4 module function identity")
    if function not in functions:
        raise ValueError(f"Function is not in the maintained build: {function}")
    if not assignment.strip():
        raise ValueError("The assignment must not be empty")
    if max_bytes <= 0:
        raise ValueError("The packet byte limit must be positive")

    path, _, _, body, references = functions[function]
    module = function.split(".", 1)[0]
    source = source_name(path, repository)
    selected_bodies = set(helper_bodies)
    if function in selected_bodies:
        raise ValueError("The target body is already supplied in Original.sk")
    missing = selected_bodies - functions.keys()
    if missing:
        raise ValueError("Unknown selected helper bodies: " + ", ".join(sorted(missing)))

    direct_dependencies = references - {function}
    contract_names = direct_dependencies | selected_bodies
    for helper in selected_bodies:
        contract_names |= functions[helper][4]
    contract_names.discard(function)
    missing = contract_names - functions.keys()
    if missing:
        raise ValueError("Missing helper contracts: " + ", ".join(sorted(missing)))

    contracts = []
    for helper in sorted(contract_names):
        helper_path, _, _, helper_body, _ = functions[helper]
        contracts.append(
            f"## {helper}\n\nSource: `{source_name(helper_path, repository)}`\n\n"
            f"```skip\n{signature(helper_body)}\n```\n"
        )
    files: dict[str, bytes] = {}

    def add(name: str, content: str) -> None:
        files[name] = content.encode("utf-8")

    add("Original.sk", f"module {module};\n\n{body}\n\nmodule end;\n")
    add("Assignment.md", assignment)
    add("HelperContracts.md", "# Existing helper signatures\n\n"
        "Signatures describe existing interfaces, not replacement stubs. Argument\n"
        "roles are supplied in Assignment.md or the owner's role-contract notes.\n\n"
        + ("\n".join(contracts) if contracts else "No maintained helper dependencies.\n"))
    if selected_bodies:
        by_module: dict[str, list[str]] = defaultdict(list)
        for helper in sorted(selected_bodies):
            by_module[helper.split(".", 1)[0]].append(functions[helper][3])
        add("HelperBodies.sk", "\n".join(
            f"module {name};\n\n" + "\n\n".join(bodies) + "\n\nmodule end;\n"
            for name, bodies in sorted(by_module.items())
        ))
    if reference is not None:
        add("Reference.lean", reference)
    if probe is not None:
        add("ExistingProbe.sk", probe)
    for index, contract in enumerate(role_contracts, start=1):
        add(f"RoleContract-{index}.md", contract)
    for name, content in support_files:
        if not name or Path(name).name != name or name in {".", ".."}:
            raise ValueError(f"Support files require a plain basename: {name}")
        if name in RESERVED_FILES or re.fullmatch(r"RoleContract-\d+\.md", name):
            raise ValueError(f"Reserved support-file basename: {name}")
        if name in files:
            raise ValueError(f"Duplicate support-file basename: {name}")
        files[name] = content
    reading = list(files)
    skill = (repository / "skills/lean-skip-refactor/SKILL.md").as_posix()
    add("task.md", worker_instructions(function, reading, skill, mode))
    add(".vibe/config.toml", "enable_subagents = false\napi_retry_max_elapsed_time = 0.0\n")
    manifest = {
        "task": task,
        "mode": mode,
        "function": function,
        "source": source,
        "body_sha256": sha256(body.encode("utf-8")),
        "inputs": {name: sha256(data) for name, data in sorted(files.items())},
        "output_files": MODE_OUTPUT_FILES[mode],
        "helper_bodies": sorted(selected_bodies),
        "support_files": [name for name, _ in support_files],
        "direct_dependencies": sorted(direct_dependencies),
    }
    if reference_origin is not None:
        manifest["reference_origin"] = reference_origin
    add("input-manifest.json", json.dumps(manifest, indent=2) + "\n")
    total_bytes = sum(len(data) for data in files.values())
    if total_bytes > max_bytes:
        raise ValueError(
            f"Packet is {total_bytes:,} bytes, exceeding the {max_bytes:,}-byte limit. "
            "Select a smaller reference excerpt, fewer helper bodies, or a narrower "
            "task; use --max-bytes only for a deliberate larger packet."
        )
    summary = {
        "task": task,
        "mode": mode,
        "function": function,
        "source": source,
        "bytes": total_bytes,
        "approx_tokens": (total_bytes + 3) // 4,
        "token_estimate": "UTF-8 bytes / 4; not a tokenizer measurement",
        "dependency_count": len(direct_dependencies),
        "helper_signature_count": len(contract_names),
        "helper_body_count": len(selected_bodies),
        "files": {name: len(data) for name, data in sorted(files.items())},
    }
    return Packet(files, summary)


def write_packet(packet: Packet, directory: Path) -> None:
    """Create exclusively: even an empty existing directory must not be reused."""
    for name in packet.files:
        relative = Path(name)
        if relative.is_absolute() or ".." in relative.parts:
            raise ValueError(f"Packet path escapes its task directory: {name}")
    directory.parent.mkdir(parents=True, exist_ok=True)
    directory.mkdir(exist_ok=False)
    for name, data in packet.files.items():
        destination = directory / name
        destination.parent.mkdir(parents=True, exist_ok=True)
        with destination.open("xb") as output:
            output.write(data)


def load_current_catalog() -> Mapping[str, FunctionRecord]:
    from select_sources import catalog

    functions, _ = catalog()
    selected = set((ROOT / "sources/build.txt").read_text().splitlines())
    return {
        name: record for name, record in functions.items()
        if record[0].relative_to(ROOT).as_posix() in selected
    }


def read_text(path: Path) -> str:
    return path.read_bytes().decode("utf-8")


def reference_excerpt(path: Path, lines: str | None) -> tuple[str, str]:
    content = read_text(path)
    if lines is None:
        return content, str(path.resolve())
    match = re.fullmatch(r"([1-9]\d*):([1-9]\d*)", lines)
    if match is None:
        raise ValueError("--reference-lines must be START:END, inclusive and 1-based")
    start, end = map(int, match.groups())
    source_lines = content.splitlines(keepends=True)
    if start > end or end > len(source_lines):
        raise ValueError("Reference line range is outside the supplied file")
    return "".join(source_lines[start - 1:end]), f"{path.resolve()}:{start}:{end}"


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--function", required=True)
    parser.add_argument("--mode", choices=tuple(MODE_OUTPUT_FILES), default="rewrite")
    parser.add_argument("--task-dir", type=Path, required=True)
    parser.add_argument("--assignment-file", type=Path, required=True)
    parser.add_argument("--reference-file", type=Path)
    parser.add_argument("--reference-lines", help="Inclusive START:END excerpt")
    parser.add_argument("--probe", type=Path, help="Existing working Skip fixture")
    parser.add_argument("--role-contract-file", type=Path, action="append", default=[])
    parser.add_argument("--support-file", type=Path, action="append", default=[],
                        help="Read-only supplementary input; preserve its basename (repeatable)")
    parser.add_argument("--helper-body", action="append", default=[], metavar="FUNCTION",
                        help="Explicit helper body to include; repeat as needed")
    parser.add_argument("--max-bytes", type=int, default=DEFAULT_MAX_BYTES)
    args = parser.parse_args(argv)
    try:
        directory = args.task_dir.absolute()
        if directory.exists() or directory.is_symlink():
            raise ValueError(f"Refusing to overwrite an existing task: {directory}")
        resolved = directory.resolve()
        if resolved.is_relative_to(ROOT) and not resolved.is_relative_to(ROOT / "build"):
            raise ValueError("Task directories inside the repository must be under build/")
        if args.reference_lines and args.reference_file is None:
            raise ValueError("--reference-lines requires --reference-file")
        if args.max_bytes <= 0:
            raise ValueError("The packet byte limit must be positive")
        assignment = read_text(args.assignment_file)
        probe = read_text(args.probe) if args.probe else None
        role_contracts = [read_text(path) for path in args.role_contract_file]
        support_files = [(path.name, path.read_bytes()) for path in args.support_file]
        reference = reference_origin = None
        if args.reference_file is not None:
            reference, reference_origin = reference_excerpt(args.reference_file, args.reference_lines)
        packet = build_packet(
            load_current_catalog(), function=args.function, task=directory.name,
            assignment=assignment, mode=args.mode, reference=reference,
            reference_origin=reference_origin,
            probe=probe, role_contracts=role_contracts,
            support_files=support_files,
            helper_bodies=args.helper_body, max_bytes=args.max_bytes,
        )
        write_packet(packet, directory)
    except (OSError, ValueError) as error:
        parser.error(str(error))
    print(json.dumps({"directory": str(directory), **packet.summary}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
