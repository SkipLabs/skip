"""Differential native checks for indexed runtime-variance candidates."""

import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


@unittest.skipUnless(
    os.environ.get("SKC_VARIANCE_TEST_COMPILER"),
    "Set SKC_VARIANCE_TEST_COMPILER to the candidate wrapper",
)
class VarianceIndexTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(
            prefix="skip-variance-index-"
        )
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.iterations = {}

    def compile(
        self,
        name,
        source,
        expected,
        indexed=True,
        verify=True,
        failure=None,
        partitioned=False,
        trace=False,
    ):
        directory = self.root / name
        directory.mkdir(exist_ok=True)
        iteration = self.iterations.get(name, 0)
        path = directory / "input.sk"
        if not path.exists() or path.read_text() != source:
            path.write_text(source)
            os.utime(path, (946684800 + iteration, 946684800 + iteration))
        command = [
            os.environ["SKC_VARIANCE_TEST_COMPILER"],
            "--compact-specializer",
            "--collection-functions",
            "--collection-emission",
            "-O0",
            "--no-inline",
            "--no-ipa",
            "--export-function-as",
            "main=skip_main",
            str(path),
            "-o",
            str(directory / "program"),
            "--init" if iteration == 0 else "--data",
            str(directory / "data"),
        ]
        if partitioned:
            command.append("--partition-classes")
        if trace:
            command.append("--debug-skstore")
        env = dict(os.environ, SKC_VARIANCE_STATS="1")
        for key in ["SKC_INDEX_VARIANCE", "SKC_VERIFY_VARIANCE_INDEX"]:
            env.pop(key, None)
        if indexed:
            env["SKC_INDEX_VARIANCE"] = "1"
            if verify:
                env["SKC_VERIFY_VARIANCE_INDEX"] = "1"
        if trace:
            env.pop("SKC_PROFILE_DIR", None)
        result = subprocess.run(
            command,
            stdout=subprocess.DEVNULL if trace else subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            env=env,
            timeout=180,
        )
        self.iterations[name] = iteration + 1
        if failure:
            self.assertNotEqual(result.returncode, 0)
            if isinstance(failure, str):
                self.assertIn(failure, result.stderr[-16000:])
        else:
            self.assertEqual(result.returncode, 0, result.stderr[-16000:])
            self.assertEqual(
                subprocess.check_output([directory / "program"], text=True),
                expected,
            )
        return result.stderr

    @staticmethod
    def comparisons(trace, indexed):
        return sum(
            int(count)
            for policy, _, count in re.findall(
                r"^##VARIANCE## (true|false) (\d+) (\d+)$", trace, re.MULTILINE
            )
            if (policy == "true") == indexed
        )

    def test_unrelated_instances_reduce_comparisons_and_retract(self):
        def source(count):
            classes = "".join(f"class IndexArg{i}()\n" for i in range(count))
            calls = "+".join(
                f"IndexBox(IndexArg{i}()).score()" for i in range(count)
            )
            return (
                classes
                + "class IndexBox<+T>(value: T) { fun score(): Int { 1 } }\n"
                "untracked fun main(): void { print_raw(("
                + calls
                + ").toString()) }\n"
            )

        control = self.compile("control", source(48), "48", indexed=False)
        candidate = self.compile("indexed", source(48), "48")
        before = self.comparisons(control, False)
        after = self.comparisons(candidate, True)
        self.assertGreater(before, 0)
        self.assertIn("##VARIANCE## true ", candidate)
        self.assertLess(after * 2, before, (before, after))
        print(
            f"Variance candidate comparisons: control={before}, indexed={after}",
            flush=True,
        )
        # Each candidate round also runs the original scan and compares all
        # completed state and function requests before publication.
        self.assertGreater(self.comparisons(candidate, False), after)
        self.compile("indexed", source(49), "49")
        self.compile("indexed", source(48), "48")
        self.compile("indexed", source(49), "49")

    def test_variance_aliases_and_multiple_inheritance(self):
        source = """
base class IndexBase { fun score(): Int { 7 } }
base class IndexOther { fun extra(): Int { 2 } }
class IndexChild() extends IndexBase, IndexOther
class IndexBox<+T>(value: T) { fun get(): T { this.value } }
class IndexSink<-T>() { fun use(_value: T): Int { 3 } }
class IndexPair<T, +U>(tag: T, value: U) { fun get(): U { this.value } }
untracked fun main(): void {
  b: IndexBox<IndexBase> = IndexBox<IndexChild>(IndexChild());
  sink: IndexSink<IndexChild> = IndexSink<IndexBase>();
  pair: IndexPair<Int, IndexBase> = IndexPair<Int, IndexChild>(1, IndexChild());
  opt: ?IndexBox<IndexBase> = Some(b);
  print_raw((opt.fromSome().get().score()+pair.get().score()+
    sink.use(IndexChild())+IndexChild().extra()).toString())
}
"""
        self.compile("control", source, "19", indexed=False)
        self.compile("indexed", source, "19")
        self.compile("indexed", source.replace("Int { 7 }", "Int { 9 }"), "23")
        self.compile(
            "indexed", source.replace("IndexChild", "IndexReplacement"), "19"
        )
        self.compile("indexed", source, "19")

    def test_recursive_argument_and_nested_variance(self):
        source = """
base class IndexNode<+T> { fun score(): Int { 4 } }
class IndexLeaf(next: ?IndexNode<IndexLeaf> = None()) extends IndexNode<IndexLeaf>
class IndexBox<+T>(value: T) { fun get(): T { this.value } }
untracked fun main(): void {
  leaf = IndexLeaf();
  node: IndexNode<IndexLeaf> = leaf;
  nested: IndexBox<IndexBox<IndexNode<IndexLeaf>>> = IndexBox(IndexBox(leaf));
  print_raw((node.score()+nested.get().get().score()).toString())
}
"""
        self.compile("control", source, "8", indexed=False)
        self.compile("indexed", source, "8")
        self.compile("indexed", source.replace("Int { 4 }", "Int { 6 }"), "12")
        self.compile("indexed", source, "8")

    def test_mutable_readonly_and_frozen_arguments(self):
        source = """
mutable class IndexCell(mutable value: Int) {
  readonly fun read(): Int { this.value }
}
class IndexBox<+T>(value: T) { fun get(): T { this.value } }
untracked fun main(): void {
  cell = mutable IndexCell(7);
  mutableBox = IndexBox<mutable IndexCell>(cell);
  readonlyBox: IndexBox<readonly IndexCell> = mutableBox;
  frozenBox = IndexBox<IndexCell>(IndexCell(11));
  readonlyFrozen: IndexBox<readonly IndexCell> = frozenBox;
  cell.!value = 9;
  print_raw((readonlyBox.get().read()+readonlyFrozen.get().read()).toString())
}
"""
        self.compile("control", source, "20", indexed=False)
        self.compile("indexed", source, "20")
        self.compile(
            "indexed",
            source.replace("cell.!value = 9", "cell.!value = 13"),
            "24",
        )
        self.compile("indexed", source, "20")

    def test_policy_guard_and_failed_update_recovery(self):
        source = 'untracked fun main(): void { print_raw("variance") }\n'
        self.compile("control", source, "variance", indexed=False)
        self.compile(
            "control",
            source,
            None,
            indexed=True,
            failure="Changing SKC_INDEX_VARIANCE requires a fresh --init cache",
        )
        self.compile("control", source, "variance", indexed=False)
        self.compile("indexed", source, "variance")
        self.compile(
            "indexed",
            source + 'fun broken(): Int { "wrong" }\n',
            None,
            failure=True,
        )
        self.compile("indexed", source, "variance")

    def test_unrelated_instance_does_not_replay_later_class_group(self):
        source = """
class IndexLeft()
class IndexRight()
class IndexReplacement()
class IndexBox<+T>(value: T) { fun first(): Int { 7 } }
fun indexLeft(): Int { IndexBox(IndexLeft()).first() }
fun indexRight(): Int { indexRight2() }
fun indexRight2(): Int { indexRight3() }
fun indexRight3(): Int { IndexBox(IndexRight()).first() }
untracked fun main(): void { print_raw((indexLeft()+indexRight()).toString()) }
"""
        changed = source.replace(
            "IndexBox(IndexLeft()).first()",
            "(IndexBox(IndexReplacement()).first()+1)",
        )
        runs = {}
        for indexed, name in [(False, "control"), (True, "indexed")]:
            cold = self.compile(
                name,
                source,
                "14",
                indexed=indexed,
                verify=False,
                partitioned=True,
                trace=True,
            )
            rounds = [
                int(round_)
                for round_, families in re.findall(
                    r"^CLASS_GROUP: (\d+) (.*)$", cold, re.MULTILINE
                )
                if "IndexBox" in families
            ]
            self.assertGreaterEqual(
                len(set(rounds)), 2, "Fixture must use distinct class rounds"
            )
            later = max(rounds)
            update = self.compile(
                name,
                changed,
                "15",
                indexed=indexed,
                verify=False,
                partitioned=True,
                trace=True,
            )
            runs[name] = any(
                int(round_) == later and "IndexBox" in families
                for round_, families in re.findall(
                    r"^CLASS_GROUP: (\d+) (.*)$", update, re.MULTILINE
                )
            )
            self.compile(
                name,
                source,
                "14",
                indexed=indexed,
                verify=False,
                partitioned=True,
            )
        self.assertTrue(
            runs["control"], "Control must reproduce broad family invalidation"
        )
        self.assertFalse(
            runs["indexed"], "Unrelated later group must remain cached"
        )


if __name__ == "__main__":
    unittest.main()
