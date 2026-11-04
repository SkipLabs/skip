"""Executable graph equivalence checks using SKC_COLLECTION_TEST_COMPILER.

The supplied compiler wrapper must provide its matching sysroot. Run under the
bounded experiment harness with TMPDIR inside the monitored scratch directory.
"""

import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


@unittest.skipUnless(
    os.environ.get("SKC_COLLECTION_TEST_COMPILER"),
    "Set SKC_COLLECTION_TEST_COMPILER to a compiler wrapper",
)
class CollectionGraphTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(
            prefix="skip-collection-graph-"
        )
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.source = self.root / "input.sk"
        self.program = self.root / "program"
        self.iteration = 0

    def compile(self, source, expected, extra=()):
        self.source.write_text(source)
        timestamp = 946684800 + self.iteration
        os.utime(self.source, (timestamp, timestamp))
        command = [
            os.environ["SKC_COLLECTION_TEST_COMPILER"],
            "--collection-emission",
            "-O0",
            "--no-inline",
            "--no-ipa",
            "--export-function-as",
            "main=skip_main",
            str(self.source),
            "-o",
            str(self.program),
            "--data" if self.iteration else "--init",
            str(self.root / "data"),
            *extra,
        ]
        result = subprocess.run(command, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            subprocess.check_output([self.program], text=True), expected
        )
        self.iteration += 1
        manifest = (
            Path(str(self.program) + ".llvm/outputs").read_text().splitlines()
        )
        return "\n".join(
            Path(p).read_text() for p in manifest if p.endswith(".ll")
        )

    @staticmethod
    def definitions(llvm):
        return re.findall(
            r"^define\b[^\n]*?@([^\s(]+)\(", llvm, flags=re.MULTILINE
        )

    def test_recursive_sharing_split_merge_and_removal(self):
        # Keep recursion out of tail position: tail-call elimination turns a
        # self call into a loop, making it structurally different from A -> B.
        left = "fun recurA(n: Int): Int { if (n == 0) 13 else recurA(n - 1) + 1 }\n"
        right = "fun recurB(n: Int): Int { if (n == 0) 13 else recurB(n - 1) + 1 }\n"
        main = "untracked fun main(): void { print_raw((recurA(2) + recurB(3)).toString()) }\n"
        for source, expected, definitions in [
            (left + right + main, "31", 1),
            (left + right.replace("13", "17") + main, "35", 2),
            (left + right + main, "31", 1),
            (
                left + right.replace("else recurB", "else recurA") + main,
                "31",
                1,
            ),
            (left + main.replace("recurB(3)", "recurA(3)"), "31", 1),
            (left + right + main, "31", 1),
        ]:
            llvm = self.compile(source, expected)
            names = [
                n
                for n in self.definitions(llvm)
                if "recurA" in n or "recurB" in n
            ]
            self.assertEqual(
                len(names), definitions, f"Update {self.iteration}: {names}"
            )

    def test_symbol_collision_reserves_existing_suffix(self):
        source = (
            "fun collisionOne(): Int { 1 }\n"
            "fun collisionTwo(): Int { 2 }\n"
            "fun collisionThree(): Int { 3 }\n"
            "untracked fun main(): void { print_raw((collisionOne() + "
            "collisionTwo() + collisionThree()).toString()) }\n"
        )
        llvm = self.compile(
            source,
            "6",
            extra=[
                "--export-function-as",
                "collisionOne=probe+name",
                "--export-function-as",
                "collisionTwo=probe?name",
                "--export-function-as",
                "collisionThree=probe_name.1",
            ],
        )
        names = self.definitions(llvm)
        self.assertEqual(
            len(names), len(set(names)), "Duplicate native definitions"
        )
        self.assertTrue(
            {"probe_name", "probe_name.1", "probe_name.2"} <= set(names), names
        )

    def test_native_aliases_survive_edit_and_retraction(self):
        declarations = (
            '@cpp_extern("SKIP_print_raw")\n'
            "untracked native fun printOne(String): void;\n"
            '@cpp_extern("SKIP_print_raw")\n'
            "untracked native fun printTwo(String): void;\n"
        )
        main = 'untracked fun main(): void { printOne("a"); printTwo("b") }\n'
        self.compile(declarations + main, "ab")
        self.compile(declarations + main.replace('"b"', '"B"'), "aB")
        self.compile(
            declarations + main.replace('printTwo("b")', 'printOne("b")'), "ab"
        )
        self.compile(declarations + main, "ab")

    def test_stable_function_symbols_preserve_vtables_and_allow_policy_changes(
        self,
    ):
        source = (
            "base class StableBase { overridable fun value(): Int { 0 } }\n"
            "class StableLeft() extends StableBase { fun value(): Int { 7 } }\n"
            "class StableRight() extends StableBase { fun value(): Int { 7 } }\n"
            "untracked fun main(): void {\n"
            " values: Array<StableBase> = Array[StableLeft(), StableRight()];\n"
            " print_raw((values[0].value() + values[1].value()).toString())\n}\n"
        )
        flags = ["--stable-function-symbols"]

        def vtable_files():
            paths = (
                Path(str(self.program) + ".llvm/outputs")
                .read_text()
                .splitlines()
            )
            result = {}
            for name in paths:
                if not name.endswith(".ll"):
                    continue
                path = Path(name)
                definitions = [
                    line
                    for line in path.read_text().splitlines()
                    if line.startswith("@")
                    and "allVTables" in line
                    and "=" in line
                    and "external" not in line
                ]
                if definitions:
                    result[name] = (
                        path.stat().st_mtime_ns,
                        path.with_suffix(".o").stat().st_mtime_ns,
                    )
            self.assertTrue(result, "Missing vtable definition module")
            return result

        llvm = self.compile(source, "14", extra=flags)
        names = [
            n for n in self.definitions(llvm) if "Stable" in n and "value" in n
        ]
        self.assertTrue(any("StableLeft" in n for n in names), names)
        self.assertTrue(any("StableRight" in n for n in names), names)
        before = vtable_files()
        changed = source.replace(
            "StableLeft() extends StableBase { fun value(): Int { 7 }",
            "StableLeft() extends StableBase { fun value(): Int { 9 }",
        )
        self.compile(changed, "16", extra=flags)
        self.assertEqual(
            vtable_files(), before, "Method body edit rebuilt the vtable"
        )
        self.compile(source, "14", extra=flags)
        self.assertEqual(vtable_files(), before)
        # The policy is tracked input, so changing it requires neither a fresh
        # cache nor reuse of symbols selected under the previous policy.
        self.compile(source, "14")
        self.compile(changed, "16", extra=flags)

    def test_split_support_preserves_vtable_object_when_initializer_changes(
        self,
    ):
        source = (
            "base class SplitBase { overridable fun value(): Int { 0 } }\n"
            "class SplitValue() extends SplitBase { fun value(): Int { 7 } }\n"
            'const splitText: String = "before";\n'
            "untracked fun main(): void {\n"
            " value: SplitBase = SplitValue();\n"
            " print_raw(splitText + value.value().toString())\n}\n"
        )
        flags = ["--stable-function-symbols", "--split-support-module"]

        def vtable_stamp():
            directory = Path(str(self.program) + ".llvm")
            path = directory / "m3_0.ll"
            text = path.read_text()
            self.assertIn("@.allVTables =", text)
            self.assertIn(" = hidden alias i8, getelementptr", text)
            # Runtime bodies have exactly one owner, the support module.
            self.assertNotIn("define hidden void @SKIP_initializeSkip(", text)
            return (
                text,
                path.stat().st_mtime_ns,
                path.with_suffix(".o").stat().st_mtime_ns,
            )

        self.compile(source, "before7", extra=flags)
        before = vtable_stamp()
        support = Path(str(self.program) + ".llvm/m2_0.ll")
        initial_support = support.read_text()
        changed = source.replace(
            "splitText + value.value()",
            "splitText + splitExtra + value.value()",
        )
        changed += 'const splitExtra: String = "after";\n'
        self.compile(changed, "beforeafter7", extra=flags)
        self.assertNotEqual(
            support.read_text(),
            initial_support,
            "Fixture did not change initialization data",
        )
        self.assertEqual(vtable_stamp(), before)
        self.compile(source, "before7", extra=flags)
        self.assertEqual(vtable_stamp(), before)
        # Toggle the tracked grouping policy in an existing cache. Old objects
        # must leave the link manifest, including the separated vtable module.
        self.compile(source, "before7", extra=["--stable-function-symbols"])
        outputs = Path(str(self.program) + ".llvm/outputs").read_text()
        self.assertNotIn("m3_0.", outputs)
        self.compile(changed, "beforeafter7", extra=flags)
        vtable_stamp()

    def test_balanced_modules_localize_body_edits_and_track_policy(self):
        declarations = "".join(
            f"fun bucketProbe{i}(): Int {{ {i} }}\n" for i in range(80)
        )
        main = (
            "untracked fun main(): void { print_raw(("
            + " + ".join(f"bucketProbe{i}()" for i in range(80))
            + ").toString()) }\n"
        )
        source = declarations + main
        common = ["--collection-functions", "--stable-function-symbols"]
        balanced = [*common, "--balanced-function-modules"]

        def stamps():
            paths = (
                Path(str(self.program) + ".llvm/outputs")
                .read_text()
                .splitlines()
            )
            return {
                Path(p).name: (
                    Path(p).stat().st_mtime_ns,
                    Path(p).with_suffix(".o").stat().st_mtime_ns,
                )
                for p in paths
                if Path(p).name.startswith("m0_") and p.endswith(".ll")
            }

        self.compile(source, "3160", extra=common)
        legacy = stamps()
        self.compile(source, "3160", extra=balanced)
        before = stamps()
        self.assertGreater(len(before), len(legacy))
        changed = source.replace(
            "bucketProbe37(): Int { 37 }", "bucketProbe37(): Int { 38 }"
        )
        self.compile(changed, "3161", extra=balanced)
        after = stamps()
        self.assertEqual(before.keys(), after.keys())
        self.assertEqual(
            sum(before[key] != after[key] for key in before),
            1,
            "A body edit rebuilt an unrelated function module",
        )
        self.compile(source, "3160", extra=balanced)
        # Switching back must remove extra buckets from the link manifest.
        self.compile(source, "3160", extra=common)
        self.assertEqual(stamps().keys(), legacy.keys())
        self.compile(changed, "3161", extra=balanced)

    def test_body_attributes_do_not_rebuild_support_declarations(self):
        source = (
            'base class DeclarationBase { overridable fun value(): String { "base" } }\n'
            "class DeclarationValue(text: String) extends DeclarationBase {\n"
            " fun value(): String { this.text }\n}\n"
            "class DeclarationOther() extends DeclarationBase {\n"
            ' fun value(): String { "other" }\n}\n'
            "untracked fun main(): void {\n"
            ' values: Array<DeclarationBase> = Array[DeclarationValue("before"), DeclarationOther()];\n'
            ' print_raw("result:" + values[0].value() + values[1].value())\n}\n'
        )
        changed = source.replace(
            "fun value(): String { this.text }",
            'fun value(): String { "after:" + this.text }',
        )
        common = ["--collection-functions", "--stable-function-symbols"]
        stable = [*common, "--stable-function-declarations"]

        def support():
            path = Path(str(self.program) + ".llvm/m2_0.ll")
            text = path.read_text()
            self.assertIn(
                "declare external ptr @sk.DeclarationValue__value", text
            )
            import hashlib

            return (
                hashlib.sha256(text.encode()).hexdigest(),
                path.stat().st_mtime_ns,
                path.with_suffix(".o").stat().st_mtime_ns,
            )

        llvm = self.compile(source, "result:beforeother", extra=stable)
        definition = next(
            line
            for line in llvm.splitlines()
            if line.startswith("define ") and "DeclarationValue__value" in line
        )
        self.assertIn(
            " nounwind", definition, "Definition lost its useful attributes"
        )
        before = support()
        self.compile(changed, "result:after:beforeother", extra=stable)
        self.assertEqual(
            support(), before, "Body attributes rewrote the support module"
        )
        self.compile(source, "result:beforeother", extra=stable)
        self.assertEqual(support(), before)
        # Changing this policy is tracked and remains valid in an existing cache.
        self.compile(source, "result:beforeother", extra=common)
        ordinary = support()
        self.assertNotEqual(ordinary[0], before[0])
        self.compile(changed, "result:after:beforeother", extra=common)
        self.assertNotEqual(
            support()[0],
            ordinary[0],
            "Control did not exercise declaration churn",
        )
        self.compile(source, "result:beforeother", extra=stable)

    def test_stable_declarations_preserve_return_and_exception_changes(self):
        source = (
            "class DeclarationException() extends Exception\n"
            "fun declarationResult(): Int { throw DeclarationException() }\n"
            "untracked fun main(): void {\n"
            " result = try { declarationResult() } catch { | _ -> -1 };\n"
            " print_raw(result.toString())\n}\n"
        )
        changed = source.replace("throw DeclarationException()", "7")
        flags = [
            "--collection-functions",
            "--stable-function-symbols",
            "--stable-function-declarations",
            "--balanced-function-modules",
        ]
        for text, expected in [(source, "-1"), (changed, "7"), (source, "-1")]:
            llvm = self.compile(text, expected, extra=flags)
            declarations = [
                line
                for line in llvm.splitlines()
                if line.startswith("declare external ")
                and "declarationResult" in line
            ]
            self.assertTrue(declarations)
            for line in declarations:
                self.assertNotIn(" noreturn", line)
                self.assertNotIn(" nounwind", line)

    def test_stable_declarations_omit_local_parameter_names(self):
        source = (
            "fun declarationParameter(before: Bool, value: Int): Int {\n"
            " if (before) value + 2 else value\n}\n"
            "untracked fun main(): void { print_raw(declarationParameter(true, 7).toString()) }\n"
        )
        renamed = source.replace("before", "after_")
        common = [
            "--collection-functions",
            "--stable-function-symbols",
            "--balanced-function-modules",
        ]
        stable = [*common, "--stable-function-declarations"]

        def declarations(llvm):
            rows = [
                line
                for line in llvm.splitlines()
                if line.startswith("declare external ")
                and "declarationParameter" in line
            ]
            self.assertTrue(
                rows, "Fixture must import the function from another module"
            )
            return sorted(set(rows))

        initial = self.compile(source, "9", extra=stable)
        expected = declarations(initial)
        self.assertTrue(all("%" not in row for row in expected), expected)
        self.assertTrue(all("i1 zeroext" in row for row in expected), expected)
        changed = self.compile(renamed, "9", extra=stable)
        self.assertEqual(declarations(changed), expected)
        self.assertRegex(
            changed, r"define [^\n]*declarationParameter[^\n]*%after_"
        )
        self.assertEqual(
            declarations(self.compile(source, "9", extra=stable)), expected
        )
        # Verify that the control actually exposes declaration-name churn and
        # that changing the policy remains valid on an initialized cache.
        ordinary = declarations(self.compile(source, "9", extra=common))
        other = declarations(self.compile(renamed, "9", extra=common))
        self.assertNotEqual(ordinary, other)
        self.assertEqual(
            declarations(self.compile(source, "9", extra=stable)), expected
        )


if __name__ == "__main__":
    unittest.main()
