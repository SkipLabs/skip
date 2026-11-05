"""Emit tracked Skip functions from validated, erased Lean declarations."""
from collections import Counter
import json

from .ir import TranslationError, quote, walk
from .names import local_name, adapter_name
from .lowering import expression_join

class Emitter:
    def __init__(self, catalog):
        self.catalog = catalog
        self.counts = Counter()
        self.references = set()
        self.pap_count = self.over_count = 0

    def full_call(self, name, args):
        if name in self.catalog.decls:
            sig = self.catalog.decls[name]
            if sig.get("init") is not None or sig.get("builtinInit") is not None:
                return f'leanFail({quote("module initialization required: " + sig["display"])})'
            target = sig["skipName"] if sig["module"] == self.current["module"] else self.catalog.ref(name)
            return f'{target}({", ".join(args)})'
        ctor = self.catalog.ctors[name]
        return f'LeanCtor({quote(name)}, {self.array(args[ctor["numParams"]:])})'

    def constant(self, name, args):
        self.references.add(name)
        self.decl_references.add(name)
        arity = self.catalog.arity(name)
        if len(args) == arity:
            return self.full_call(name, args)
        if len(args) < arity:
            self.pap_count += 1
            self.catalog.adapters.add(name)
            self.adapter_references.add(name)
            return f'LeanClosure({self.catalog.adapter(name)}, {arity}, {self.array(args)})'
        self.over_count += 1
        return f'leanApply({self.full_call(name, args[:arity])}, {self.array(args[arity:])})'

    def adapter(self, name):
        self.current = self.catalog.decls.get(name, {"module": "Constructors"})
        args = [f'_args[{i}]' for i in range(self.catalog.arity(name))]
        return f'fun {adapter_name(name)}(_args: Array<LeanValue>): LeanValue {{ {self.full_call(name, args)} }}\n'

    @staticmethod
    def array(args):
        return "Array[" + ", ".join(args) + "]"

    def emit(self, decl):
        self.current = decl
        self.adapter_references = set()
        self.decl_references = set()
        self.joins = {}
        self.variables = {}
        self.lines = []
        self.indent = 0
        for p in decl["params"]:
            self.addvar(p["id"], p.get("name"))
        if decl["kind"] == "function":
            for ins in walk(decl["body"]):
                op = ins["op"]
                self.counts[op] += 1
                if op == "let":
                    self.addvar(ins["id"], ins.get("name"))
                    self.counts["value:" + ins["value"]["op"]] += 1
                elif op == "join":
                    if ins["id"] in self.joins:
                        raise TranslationError("duplicate join point")
                    self.joins[ins["id"]] = (len(self.joins) + 1, ins)
                    for p in ins["params"]:
                        self.addvar(p["id"], p.get("name"))
                elif op == "case":
                    for alt in ins["alts"]:
                        for p in alt["params"]:
                            self.addvar(p["id"], p.get("name"))
                elif op == "function":
                    raise TranslationError("nested function survived lambda lifting")
        self.structured = expression_join(decl.get("body", []))
        self.frame = bool(self.joins) and self.structured is None
        self.used = set()
        self.uses = Counter()
        self.inlined = {}
        for ins in walk(decl.get('body', [])):
            if 'var' in ins:
                self.used.add(ins['var'])
                self.uses[ins['var']] += 1
            self.used.update(ins.get('args', []))
            self.uses.update(ins.get('args', []))
            if ins['op'] == 'let':
                val = ins['value']
                if 'var' in val:
                    self.used.add(val['var'])
                    self.uses[val['var']] += 1
                self.used.update(val.get('args', []))
                self.uses.update(val.get('args', []))
        self.counts["loopFunctions" if self.frame else "structuredJoinFunctions" if self.structured else "straightFunctions"] += 1
        self.line("// " + quote(decl["display"]))
        params = ", ".join(f'{self.variables[p["id"]]}{"_input" if self.frame else ""}: LeanValue' for p in decl["params"])
        self.line(f'fun {self.catalog.decls[decl["name"]]["skipName"]}({params}): LeanValue {{')
        self.indent += 1
        if decl["kind"] == "extern":
            entries = decl["extern"]
            if any(e["kind"] == "opaque" for e in entries):
                raise TranslationError("opaque imported body cannot be treated as foreign")
            self.line(f'leanPrimitive({quote(decl["display"] + " " + json.dumps(entries, ensure_ascii=False))})')
        else:
            self.validate(decl["body"], {p["id"] for p in decl["params"]}, {})
            if self.frame:
                self.slots = {v: i for i, v in enumerate(v for v in self.variables if v in self.used)}
                self.line('// Frame slots: ' + ', '.join(f'{i}={self.variables[v]}' for v, i in self.slots.items()))
                self.line(f'_frame: mutable Array<LeanValue> = Array::mfill({len(self.slots)}, (LeanErased(): LeanValue));')
                for p in decl['params']:
                    if p['id'] in self.used:
                        self.bind(p['id'], self.variables[p['id']] + '_input')
            if self.frame:
                self.line('pc = 0;')
                self.line('loop {')
                self.indent += 1
                self.line('pc match {')
                self.indent += 1
                self.line('| 0 -> {')
                self.indent += 1
                self.body(decl["body"])
                self.indent -= 1
                self.line('}')
                for pc, join in self.joins.values():
                    self.line(f'| {pc} -> {{')
                    self.indent += 1
                    self.body(join["body"])
                    self.indent -= 1
                    self.line('}')
                self.line('| _ -> { return leanFail("invalid join point") }')
                self.indent -= 1
                self.line('}')
                self.indent -= 1
                self.line('}')
            else:
                self.body(decl["body"])
        self.indent -= 1
        self.line('}')
        return "\n".join(self.lines) + "\n"

    def validate(self, body, scope, joins):
        scope, joins = set(scope), dict(joins)
        def use(var):
            if var is not None and var not in scope:
                raise TranslationError(f"unbound variable {var}")
        terminal = False
        for ins in body:
            if terminal:
                raise TranslationError("instruction after terminator")
            op = ins["op"]
            if op == "let":
                val = ins["value"]
                if "var" in val:
                    use(val["var"])
                for a in val.get("args", []):
                    use(a)
                scope.add(ins["id"])
            elif op == "join":
                joins[ins["id"]] = len(ins["params"])
                self.validate(ins["body"], scope | {p["id"] for p in ins["params"]}, joins)
            elif op == "case":
                use(ins["var"])
                for alt in ins["alts"]:
                    if alt["ctor"] is not None:
                        ctor = self.catalog.ctors.get(alt["ctor"])
                        if ctor is None or ctor["inductive"] != ins["type"]:
                            raise TranslationError("unknown/wrong constructor in case")
                        if len(alt["params"]) != ctor["numFields"]:
                            raise TranslationError("case field arity mismatch")
                    self.validate(alt["body"], scope | {p["id"] for p in alt["params"]}, joins)
                terminal = True
            elif op == "jump":
                if joins.get(ins["id"]) != len(ins["args"]):
                    raise TranslationError("unknown join or jump arity mismatch")
                for a in ins["args"]:
                    use(a)
                terminal = True
            elif op == "return":
                use(ins["var"])
                terminal = True
            elif op == "unreachable":
                terminal = True
            else:
                raise TranslationError(f"unsupported code operation {op}")
        if not terminal:
            raise TranslationError("missing terminator")

    def addvar(self, var, hint=None):
        if var not in self.variables:
            self.variables[var] = local_name(hint, len(self.variables))

    def var(self, var):
        if var is None:
            return 'LeanErased()'
        if self.frame:
            return f'_frame[{self.slots[var]}]'
        return self.inlined.get(var, self.variables[var])

    def bind(self, var, expr):
        self.inlined.pop(var, None)
        name = self.variables[var]
        if self.frame and var not in self.used:
            self.line(f'_ = {expr};')
            return
        self.line(f'_frame.set({self.slots[var]}, {expr});' if self.frame else f'{name}: LeanValue = {expr};')

    def line(self, text):
        self.lines.append("  " * self.indent + text)

    def expr(self, val):
        op = val["op"]
        if op == "erased":
            return "LeanErased()"
        if op == "literal":
            lit = val["literal"]
            if lit["kind"] == "string":
                return f'LeanText({quote(lit["value"])})'
            return f'LeanScalar({quote(lit["kind"])}, {quote(lit["value"])})'
        if op == "project":
            return f'leanField({self.var(val["var"])}, {val["index"]})'
        if op == "constant":
            return self.constant(val["name"], [self.var(a) for a in val["args"]])
        if op == "apply":
            if not val["args"]:
                return self.var(val["var"])
            return f'leanApply({self.var(val["var"])}, {self.array([self.var(a) for a in val["args"]])})'
        raise TranslationError(f"unsupported value operation {op}")

    def body(self, body, join_result=False):
        for position, ins in enumerate(body):
            op = ins["op"]
            if op == "let":
                value = ins['value']
                expression = self.expr(value)
                if (not self.frame and position == len(body) - 2
                        and body[-1]['op'] == 'return' and body[-1]['var'] == ins['id']):
                    # Adjacent let/return: evaluation order is unchanged, even for stubs.
                    self.counts['tailBindingsRemoved'] += 1
                    self.line(expression)
                    return
                total = value['op'] in ('literal', 'erased') or (
                    value['op'] == 'apply' and not value['args']) or (
                    value['op'] == 'constant' and value['name'] not in self.catalog.decls
                    and len(value['args']) == self.catalog.arity(value['name']))
                if not self.frame and total and self.uses[ins['id']] == 1:
                    # Only total representation operations may move past other code.
                    # Keep expressions bounded: large constructor chains stay readable.
                    if len(expression) < 160:
                        self.inlined[ins['id']] = expression
                        self.counts['representationBindingsInlined'] += 1
                        continue
                self.bind(ins["id"], expression)
            elif op == "join":
                if self.structured is ins:
                    self.line('_joined: Array<LeanValue> = {')
                    self.indent += 1
                    self.body(body[position + 1:], join_result=True)
                    self.indent -= 1
                    self.line('};')
                    for i, p in enumerate(ins['params']):
                        self.bind(p['id'], f'_joined[{i}]')
                    self.body(ins['body'])
                    return
            elif op == "return":
                self.line(("return " if self.frame else "") + self.var(ins["var"]))
            elif op == "unreachable":
                self.line(("return " if self.frame else "") + f'leanFail({quote("unreachable: " + self.current["display"])})')
            elif op == "jump":
                pc, join = self.joins[ins["id"]]
                if join_result:
                    self.line(self.array([self.var(a) for a in ins['args']]))
                else:
                    # Snapshot all arguments before any assignment, including cyclic swaps.
                    for i, arg in enumerate(ins['args']):
                        self.line(f'_jump{i} = {self.var(arg)};')
                    for i, p in enumerate(join["params"]):
                        self.bind(p["id"], f'_jump{i}')
                    self.line(f'!pc = {pc};')
                    self.line('void')
            elif op == "case":
                self.line(f'leanTag({self.var(ins["var"])}) match {{')
                self.indent += 1
                default = False
                for alt in ins["alts"]:
                    ctor = alt["ctor"]
                    default |= ctor is None
                    self.line(f'| {"_" if ctor is None else quote(ctor)} -> {{')
                    self.indent += 1
                    for i, p in enumerate(alt["params"]):
                        self.bind(p["id"], f'leanField({self.var(ins["var"])}, {i})')
                    self.body(alt["body"], join_result)
                    self.indent -= 1
                    self.line('}')
                if not default:
                    self.line('| _ -> { ' + ("return " if self.frame else "") + 'leanFail("non-exhaustive Lean case") }')
                self.indent -= 1
                self.line('}')
            else:
                raise TranslationError(f"unsupported code operation {op}")
