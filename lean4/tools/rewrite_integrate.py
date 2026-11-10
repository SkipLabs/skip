#!/usr/bin/env python3
"""Integrate one reviewed function rewrite; dry-run unless --apply is supplied.

The task manifest is the frozen input-manifest.json used by rewrite workers.
The replacement must be a function-only file in the same module, including the
canonical function. Its destination must be a new file under sources/Modules.
Canonical signatures must use named parameters and simple named types (optionally
mutable); advanced type syntax is rejected for manual integration.
No formatting, compilation, semantic acceptance, or Lean generation is implied.

Example:
  python3 tools/rewrite_integrate.py --manifest build/task/input-manifest.json \
    --replacement build/task/Reviewed.sk --destination sources/Modules/X/New.sk

All checks precede writes. Apply stages files and rolls back ordinary exceptions;
it is not a crash-atomic transaction across multiple filesystem paths.
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass
import difflib
import hashlib
import json
import os
from pathlib import Path
import re
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
MODULE = re.compile(r"^module (L4_\w+);", re.M)
FUNCTION = re.compile(r"^fun ((?:apply_)?f_\w+)\s*\(", re.M)
REFERENCE = re.compile(r"\b(?:(L4_\w+)\s*\.\s*)?((?:apply_)?f_\w+)\b")


class IntegrationError(ValueError):
    pass


def require(condition: bool, message: str) -> None:
    if not condition:
        raise IntegrationError(message)


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def code_mask(text: str) -> str:
    """Hide comments/literals without changing offsets or line boundaries."""
    result = list(text)
    i = 0
    while i < len(text):
        start = i
        if text.startswith("//", i):
            end = text.find("\n", i)
            i = len(text) if end < 0 else end
        elif text.startswith("/*", i):
            i += 2
            depth = 1
            while i < len(text) and depth:
                if text.startswith("/*", i):
                    depth += 1
                    i += 2
                elif text.startswith("*/", i):
                    depth -= 1
                    i += 2
                else:
                    i += 1
            require(depth == 0, "Unterminated block comment")
        elif text[i] in ('"', "'"):
            quote = text[i]
            i += 1
            while i < len(text) and text[i] != quote:
                i += 2 if text[i] == "\\" else 1
            require(i < len(text), "Unterminated quoted literal")
            i += 1
        else:
            i += 1
            continue
        for pos in range(start, i):
            if text[pos] not in "\r\n":
                result[pos] = " "
    return "".join(result)


@dataclass(frozen=True)
class Function:
    name: str
    start: int
    end: int
    comment_start: int


def parse_functions(text: str, label: str, *, functions_only: bool = False):
    """Read the catalog's top-level layout with balanced, masked body braces."""
    masked = code_mask(text)
    modules = list(MODULE.finditer(masked))
    endings = list(re.finditer(r"^module end;", masked, re.M))
    require(len(modules) == len(endings) == 1, f"Expected one module in {label}")
    opening, closing = modules[0], endings[0]
    require(opening.end() < closing.start(), f"Invalid module boundaries: {label}")
    functions = []
    remainder = list(masked)
    for match in FUNCTION.finditer(masked):
        require(opening.end() <= match.start() < closing.start(),
                f"Function outside module: {label}")
        require(not functions or match.start() >= functions[-1].end,
                f"Nested function declaration is unsupported: {label}")
        brace = masked.find("{", match.end())
        require(brace != -1 and brace < closing.start(), f"Missing function body: {label}")
        depth = 1
        end = brace + 1
        while end < closing.start() and depth:
            depth += (masked[end] == "{") - (masked[end] == "}")
            end += 1
        require(depth == 0, f"Unbalanced function body: {label}")
        comment_start = match.start()
        previous = text.rfind("\n", 0, max(0, match.start() - 1)) + 1
        if re.fullmatch(r'// "[^\r\n]*"\r?\n', text[previous:match.start()]):
            comment_start = previous
        functions.append(Function(match[1], match.start(), end, comment_start))
        remainder[match.start():end] = " " * (end - match.start())
    names = [function.name for function in functions]
    require(len(names) == len(set(names)), f"Duplicate function definition in {label}")
    if functions_only:
        for match in (opening, closing):
            remainder[match.start():match.end()] = " " * (match.end() - match.start())
        require(not "".join(remainder).strip(),
                f"Replacement must contain only module and function declarations: {label}")
    return opening[1], functions


def confined(base: Path, relative: str) -> Path:
    require(isinstance(relative, str) and relative, "Expected a nonempty relative path")
    path = Path(relative)
    require(not path.is_absolute() and ".." not in path.parts,
            f"Path must stay within {base}: {relative}")
    result = base / path
    require(result.resolve().is_relative_to(base.resolve()), f"Path escapes {base}: {relative}")
    for parent in (result, *result.parents):
        if parent == base:
            break
        require(not parent.is_symlink(), f"Symlink paths are unsupported: {relative}")
    return result


def check_hash(data: bytes, expected: str, label: str) -> None:
    require(isinstance(expected, str) and re.fullmatch(r"[0-9a-f]{64}", expected) is not None,
            f"Invalid SHA256 for {label}")
    require(digest(data) == expected, f"Hash mismatch: {label}")


def body_for_hash(text: str, function: Function, expected: str, label: str) -> str:
    for start in (function.comment_start, function.start):
        body = text[start:function.end]
        if digest(body.encode()) == expected:
            return body
    raise IntegrationError(f"Original body hash mismatch: {label}")


def retained_body(body: str, module: str, name: str, *, retain_adapter: bool = False) -> str:
    replacements = []
    masked = code_mask(body)
    for match in REFERENCE.finditer(masked):
        if match[1] not in (None, module):
            continue
        if match[1] is None and masked[:match.start()].rstrip().endswith("."):
            continue
        require(retain_adapter or match[2] != "apply_" + name,
                "Recursive closure adapter needs an explicitly reviewed fallback adapter")
        if match[2] == name or (retain_adapter and match[2] == "apply_" + name):
            replacements.append((match.start(2), match.end(2), match[2]))
    for start, end, identity in reversed(replacements):
        body = body[:start] + identity + "_fallback" + body[end:]
    return body


def canonical_abi(text: str, function: Function) -> dict:
    """Compare the supported named-type ABI, without guessing complex syntax."""
    masked = code_mask(text)
    header = masked[function.start:masked.index("{", function.start)].strip()
    signature = re.fullmatch(r"fun \w+\s*\(([^()]*)\)\s*:\s*(.+)", header, re.S)
    require(signature is not None, "Unsupported canonical signature syntax")
    named_type = r"(?:mutable\s+)?[A-Za-z_]\w*(?:\s*\.\s*[A-Za-z_]\w*)*"

    def normalize_type(value: str) -> str:
        value = value.strip()
        require(re.fullmatch(named_type, value) is not None,
                f"Unsupported canonical type syntax: {value}")
        return re.sub(r"\s*\.\s*", ".", " ".join(value.split()))

    parameters = signature[1].strip().removesuffix(",").strip()
    types = []
    for parameter in parameters.split(",") if parameters else []:
        declaration = re.fullmatch(r"\s*[A-Za-z_]\w*\s*:\s*(.+?)\s*", parameter, re.S)
        require(declaration is not None, "Unsupported canonical parameter syntax")
        types.append(normalize_type(declaration[1]))
    return {"parameters": types, "return": normalize_type(signature[2])}


@dataclass
class Plan:
    arguments: tuple
    changes: dict[Path, tuple[bytes | None, bytes]]
    inputs: dict[Path, bytes]
    audit: dict


def prepare_plan(root: Path, manifest_path: Path, replacement_path: Path,
                 destination: str, audit_path: Path | None = None,
                 closure_adapter_sha256: str | None = None) -> Plan:
    root, manifest_path, replacement_path = root.resolve(), manifest_path.resolve(), replacement_path.resolve()
    audit_path = (audit_path or manifest_path.parent / "integration-audit.json").absolute()
    require(audit_path.is_relative_to(root), "Audit must be inside the repository")
    audit_path = confined(root, audit_path.relative_to(root).as_posix())
    require(audit_path.is_relative_to(root / "build"), "Audit must be under build/")
    require(audit_path.parent.is_dir(), "Create the audit parent directory explicitly first")
    inputs = {manifest_path: manifest_path.read_bytes(), replacement_path: replacement_path.read_bytes()}
    manifest = json.loads(inputs[manifest_path])
    qualified = manifest.get("function", "")
    require(isinstance(qualified, str) and re.fullmatch(r"L4_\w+\.f_\w+", qualified) is not None,
            "Manifest function must be one qualified canonical f_ identity")
    module, name = qualified.split(".")
    frozen_inputs = manifest.get("inputs", {})
    require(isinstance(frozen_inputs, dict) and "Original.sk" in frozen_inputs,
            "Manifest must hash its frozen Original.sk input")
    for relative, expected in frozen_inputs.items():
        path = confined(manifest_path.parent, relative)
        data = path.read_bytes()
        check_hash(data, expected, relative)
        inputs[path] = data
    body_hash = manifest.get("body_sha256", "")
    require(isinstance(body_hash, str) and re.fullmatch(r"[0-9a-f]{64}", body_hash) is not None,
            "Manifest requires body_sha256")
    original_text = inputs[manifest_path.parent / "Original.sk"].decode()
    original_module, original_functions = parse_functions(original_text, "Original.sk")
    originals = [f for f in original_functions if f.name == name]
    require(original_module == module and len(originals) == 1, "Frozen canonical identity mismatch")
    frozen_body = body_for_hash(original_text, originals[0], body_hash, "Original.sk")

    source_path = confined(root, manifest.get("source", ""))
    destination_path = confined(root, destination)
    require(source_path.is_relative_to(root / "sources/Modules"), "Source must be under sources/Modules/")
    require(destination_path.is_relative_to(root / "sources/Modules") and destination_path.suffix == ".sk",
            "Destination must be a .sk file under sources/Modules/")
    require(destination_path != source_path and not destination_path.exists(), "Destination already exists")
    require(destination_path.parent.is_dir(), "Create the destination's parent directory explicitly first")
    require(not audit_path.exists(), "Audit path already exists; choose a new --audit path")
    source_bytes = source_path.read_bytes()
    if "source_sha256" in manifest:
        check_hash(source_bytes, manifest["source_sha256"], "source file")
    source = source_bytes.decode()
    source_module, source_functions = parse_functions(source, str(source_path))
    targets = [f for f in source_functions if f.name == name]
    require(source_module == module and len(targets) == 1, "Current canonical identity mismatch")
    original = body_for_hash(source, targets[0], body_hash, str(source_path))
    require(original == frozen_body, "Frozen/current original bodies differ")

    replacement = inputs[replacement_path].decode()
    replacement_module, replacements = parse_functions(replacement, str(replacement_path), functions_only=True)
    require(replacement_module == module, "Replacement module mismatch")
    replacement_names = {f.name for f in replacements}
    require(name in replacement_names, "Replacement is missing the canonical function")
    require(name + "_fallback" not in replacement_names, "Replacement must not define the retained fallback")
    abi = canonical_abi(source, targets[0])
    replacement_target = next(f for f in replacements if f.name == name)
    require(canonical_abi(replacement, replacement_target) == abi,
            "Canonical ABI mismatch: parameter count/order/types or return type changed")
    definitions = {}
    for path in sorted((root / "sources").rglob("*.sk")):
        text = path.read_text()
        if not any(match[1] == module for match in MODULE.finditer(text)):
            continue
        parsed_module, functions = parse_functions(text, str(path))
        if parsed_module != module:
            continue
        for function in functions:
            require(function.name not in definitions, f"Duplicate existing definition: {module}.{function.name}")
            definitions[function.name] = path
    require(definitions.get(name) == source_path, "Canonical definition is not unique at the manifest source")
    require(name + "_fallback" not in definitions, "Retained fallback already exists")
    require(not (replacement_names - {name}) & definitions.keys(), "Replacement helper conflicts with an existing definition")

    adapter_audit = None
    if closure_adapter_sha256 is not None:
        adapter_name = "apply_" + name
        require(definitions.get(adapter_name) == source_path,
                "Reviewed closure adapter must be in the canonical source file")
        require(adapter_name + "_fallback" not in definitions and
                adapter_name + "_fallback" not in replacement_names,
                "Retained closure adapter already exists")
        require(adapter_name not in replacement_names,
                "Replacement must not redefine the existing closure adapter")
        adapter = next(f for f in source_functions if f.name == adapter_name)
        adapter_body = source[adapter.start:adapter.end]
        check_hash(adapter_body.encode(), closure_adapter_sha256, "reviewed closure adapter")
        retained_adapter = retained_body(adapter_body, module, name, retain_adapter=True)
        adapter_audit = {
            "identity": module + "." + adapter_name,
            "original_body": adapter_body,
            "original_sha256": closure_adapter_sha256,
            "retained_body": retained_adapter,
            "retained_sha256": digest(retained_adapter.encode()),
        }

    target = targets[0]
    # Preserve the source outside the exact function span, including its comment.
    before_body = source[target.start:target.end]
    fallback = retained_body(before_body, module, name, retain_adapter=adapter_audit is not None)
    retained = fallback
    if adapter_audit is not None:
        retained += "\n\n" + adapter_audit["retained_body"]
    updated_source = source[:target.start] + retained + source[target.end:]
    build_path = root / "sources/build.txt"
    build_before = build_path.read_bytes()
    build_lines = build_before.decode().splitlines()
    source_relative = source_path.relative_to(root).as_posix()
    destination_relative = destination_path.relative_to(root).as_posix()
    require(build_lines.count(source_relative) == 1, "Source must occur exactly once in sources/build.txt")
    require(destination_relative not in build_lines, "Destination is already listed in sources/build.txt")
    build_after = build_before + (b"" if not build_before or build_before.endswith(b"\n") else b"\n")
    build_after += (destination_relative + "\n").encode()
    symbols_path = root / "provenance/symbols.tsv"
    symbols_before = symbols_path.read_bytes()
    rows = symbols_before.decode().splitlines(keepends=True)
    require(rows and rows[0].rstrip("\r\n") == "skip\tlean\tfile", "Unexpected provenance header")
    found = 0
    for index, row in enumerate(rows[1:], 1):
        parts = row.rstrip("\r\n").split("\t")
        require(len(parts) == 3, f"Malformed provenance row {index + 1}")
        if parts[0] == qualified:
            require(parts[2] == source_relative, "Provenance source mismatch")
            ending = row[len(row.rstrip("\r\n")):]
            rows[index] = "\t".join((parts[0], parts[1], destination_relative)) + ending
            found += 1
    require(found == 1, "Expected exactly one canonical provenance row")
    changes = {
        source_path: (source_bytes, updated_source.encode()),
        destination_path: (None, inputs[replacement_path]),
        build_path: (build_before, build_after),
        symbols_path: (symbols_before, "".join(rows).encode()),
    }
    require(not set(changes) & set(inputs) and audit_path not in changes and audit_path not in inputs,
            "Input/output paths overlap")
    for path in changes:
        confined(root, path.relative_to(root).as_posix())
    audit = {
        "schema_version": 1, "task": manifest.get("task"), "function": qualified,
        "source": source_relative, "destination": destination_relative,
        "manifest_sha256": digest(inputs[manifest_path]),
        "replacement_sha256": digest(inputs[replacement_path]),
        "original_body_sha256": body_hash, "original_body": original,
        "retained_function_body": fallback,
        "retained_function_sha256": digest(fallback.encode()),
        "canonical_abi": abi,
        "abi_check": "Parameter types/order and return type match; argument roles still require semantic review.",
        "shared_helpers": "Direct self references and any explicitly retained closure adapter are redirected; other helpers remain shared.",
        "closure_adapter": adapter_audit,
        "validation": "pending; integration does not imply semantic acceptance",
        "changes": [{"path": p.relative_to(root).as_posix(),
                     "before_sha256": None if old is None else digest(old),
                     "after_sha256": digest(new)} for p, (old, new) in changes.items()],
    }
    changes[audit_path] = (None, (json.dumps(audit, indent=2) + "\n").encode())
    return Plan((root, manifest_path, replacement_path, destination, audit_path,
                 closure_adapter_sha256), changes, inputs, audit)


def apply_plan(plan: Plan) -> None:
    fresh = prepare_plan(*plan.arguments)
    require(fresh.changes == plan.changes and fresh.inputs == plan.inputs,
            "Inputs changed after preflight; rerun the dry-run")
    staged = {}
    written = []
    try:
        for path, (old, new) in plan.changes.items():
            require(path.parent.is_dir(), f"Missing output parent: {path.parent}")
            with tempfile.NamedTemporaryFile(dir=path.parent, prefix=".rewrite-", delete=False) as file:
                staged[path] = Path(file.name)
                file.write(new)
                file.flush()
                os.fsync(file.fileno())
            os.chmod(staged[path], (path.stat().st_mode & 0o777) if old is not None else 0o644)
        for path, temporary in staged.items():
            old, _ = plan.changes[path]
            require((path.read_bytes() if path.exists() else None) == old,
                    f"Output changed after preflight: {path}")
        for path, temporary in staged.items():
            os.replace(temporary, path)
            written.append(path)
    except BaseException:
        for path in reversed(written):
            old, new = plan.changes[path]
            # Never overwrite a concurrent external edit while rolling back.
            if path.read_bytes() != new:
                raise IntegrationError(f"Rollback stopped: concurrent edit to {path}")
            if old is None:
                path.unlink()
            else:
                with tempfile.NamedTemporaryFile(dir=path.parent, prefix=".rewrite-", delete=False) as file:
                    rollback = Path(file.name)
                    file.write(old)
                os.chmod(rollback, path.stat().st_mode & 0o777)
                os.replace(rollback, path)
        raise
    finally:
        for temporary in staged.values():
            temporary.unlink(missing_ok=True)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--replacement", type=Path, required=True)
    parser.add_argument("--destination", required=True, help="New repository-relative source path")
    parser.add_argument("--audit", type=Path)
    parser.add_argument("--closure-adapter-sha256",
                        help="SHA256 of an independently reviewed apply_ adapter declaration/body to retain")
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()
    try:
        plan = prepare_plan(args.root, args.manifest, args.replacement, args.destination,
                            args.audit, args.closure_adapter_sha256)
        print("APPLY" if args.apply else "DRY RUN (no files written)")
        print(f"Original body SHA256: {plan.audit['original_body_sha256']}")
        print("Canonical ABI matched; argument roles and semantics still require review.")
        for path, (old, new) in plan.changes.items():
            relative = path.relative_to(args.root.resolve()).as_posix()
            print(f"{relative}: {digest(old) if old is not None else '(new)'} -> {digest(new)}")
            if path == plan.arguments[4]:
                print("  Audit records original/fallback bodies, ABI and file hashes; validation pending.")
                continue
            print("".join(difflib.unified_diff(
                [] if old is None else old.decode().splitlines(keepends=True),
                new.decode().splitlines(keepends=True), fromfile=relative, tofile=relative)), end="")
        if args.apply:
            apply_plan(plan)
            print("Integrated. Formatting, type-checking and semantic validation remain pending.")
        return 0
    except (IntegrationError, OSError, UnicodeError, json.JSONDecodeError) as error:
        print(f"Integration refused: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
