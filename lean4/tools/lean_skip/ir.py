#!/usr/bin/env python3
"""Translate the versioned LCNF mono export. No Lean source/C/trace parsing."""
import hashlib
import json
from .names import module_name, function_name, adapter_name


class TranslationError(Exception):
    pass


def records(path):
    with open(path, encoding="utf-8") as stream:
        for number, line in enumerate(stream, 1):
            try:
                yield json.loads(line)
            except ValueError as error:
                raise TranslationError(f"{path}:{number}: invalid export: {error}") from error


def quote(text):
    return json.dumps(text, ensure_ascii=False)


def symbol(key):
    return "f_" + hashlib.sha256(key.encode()).hexdigest()[:24]


def walk(body):
    for ins in body:
        yield ins
        if ins["op"] in ("join", "function"):
            yield from walk(ins["body"])
        elif ins["op"] == "case":
            for alt in ins["alts"]:
                yield from walk(alt["body"])


class Catalog:
    def __init__(self, path):
        self.decls, self.ctors, self.modules = {}, {}, []
        self.header = self.end = None
        self.calls = {}
        self.adapters = set()
        symbols = set()
        module_owners = {}
        skip_names = set()
        for rec in records(path):
            kind = rec["record"]
            if kind == "header":
                if self.header or rec["schema"] != 1 or rec["phase"] != "LCNF.saveMono":
                    raise TranslationError("unsupported or duplicate export header")
                self.header = rec
            elif kind == "decl":
                name = rec["name"]
                if name in self.decls:
                    raise TranslationError(f"duplicate declaration {name}")
                sig = {k: v for k, v in rec.items() if k not in ("body", "params")}
                sig["params"] = rec["params"]
                sig["arity"] = len(rec["params"])
                sig["skipModule"] = module_name(rec["module"])
                sig["skipName"] = function_name(name)
                mod = sig['skipModule']
                if module_owners.setdefault(mod, rec['module']) != rec['module']:
                    raise TranslationError(f'colliding Skip module name: {mod}')
                skip_name = (mod, sig['skipName'])
                if skip_name in skip_names:
                    raise TranslationError(f'colliding Skip function name: {skip_name}')
                skip_names.add(skip_name)
                sig["symbol"] = symbol(name)
                if sig["symbol"] in symbols:
                    raise TranslationError("generated symbol collision")
                symbols.add(sig["symbol"])
                self.decls[name] = sig
                self.calls[name] = {i["value"]["name"] for i in walk(rec.get("body", []))
                                    if i["op"] == "let" and i["value"]["op"] == "constant"}
            elif kind == "ctor":
                if rec["name"] in self.ctors:
                    raise TranslationError("duplicate constructor")
                self.ctors[rec["name"]] = rec
            elif kind == "module":
                self.modules.append(rec)
            elif kind == "end":
                self.end = rec
            else:
                raise TranslationError(f"unknown record {kind}")
        if not self.header or not self.end:
            raise TranslationError("incomplete export (missing header/end)")
        for label, actual in (("decls", len(self.decls)), ("ctors", len(self.ctors)), ("modules", len(self.modules))):
            if self.end[label] != actual:
                raise TranslationError(f"export count mismatch: {label}")
        for ctor in self.ctors:
            if ctor in self.decls and self.decls[ctor]["kind"] != "extern":
                raise TranslationError(f"constructor/non-extern collision: {ctor}")


    def ref(self, name):
        d = self.decls[name]
        return d["skipModule"] + "." + d["skipName"]

    def arity(self, name):
        if name in self.decls:
            return self.decls[name]["arity"]
        if name in self.ctors:
            c = self.ctors[name]
            return c["numParams"] + c["numFields"]
        raise TranslationError(f"unresolved ordinary reference: {name}")

    def adapter(self, name):
        mod = self.decls[name]["skipModule"] if name in self.decls else "L4_Constructors"
        return mod + "." + adapter_name(name)

    def find_adapters(self, path, selected):
        for d in records(path):
            if d["record"] != "decl" or d["name"] not in selected:
                continue
            for i in walk(d.get("body", [])):
                if i["op"] == "let" and i["value"]["op"] == "constant":
                    v = i["value"]
                    if len(v["args"]) < self.arity(v["name"]):
                        self.adapters.add(v["name"])
