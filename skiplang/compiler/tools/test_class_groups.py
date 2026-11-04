"""Executable class-group correctness, locality and cache-policy gates."""

import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


@unittest.skipUnless(
    os.environ.get("SKC_GROUP_TEST_COMPILER"),
    "Set SKC_GROUP_TEST_COMPILER to a matching compiler wrapper",
)
class ClassGroupTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(
            prefix="skip-class-groups-"
        )
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.binary = self.root / "program"
        self.iteration = 0

    def compile(self, sources, expected, trace=False, groups_only=False):
        files = []
        for name, text in sources.items():
            path = self.root / name
            if not path.exists() or path.read_text() != text:
                path.write_text(text)
                stamp = 946684800 + self.iteration
                os.utime(path, (stamp, stamp))
            files.append(str(path))
        command = [
            os.environ["SKC_GROUP_TEST_COMPILER"],
            "--partition-classes",
            "--compact-specializer",
            "--collection-functions",
            "--collection-emission",
            "-O0",
            "--no-inline",
            "--no-ipa",
            "--export-function-as",
            "main=skip_main",
            *files,
            "-o",
            str(self.binary),
            "--init" if self.iteration == 0 else "--data",
            str(self.root / "data"),
        ]
        command.extend(getattr(self, "extra_options", ()))
        if trace:
            command.append("--debug-skstore")
        env = dict(os.environ, SKC_SPECIALIZER_ISOLATION_AUDIT="1")
        if groups_only:
            # Cold store traces can expand hundreds of MB of compiler values.
            # Group names are on stderr; discard stdout at the child and keep
            # the profiling wrapper from also recording it. This is a functional
            # test, so the outer resource monitor remains sufficient.
            self.assertTrue(trace)
            env.pop("SKC_PROFILE_DIR", None)
        result = subprocess.run(
            command,
            stdout=subprocess.DEVNULL if groups_only else subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            env=env,
            timeout=180,
        )
        self.assertEqual(result.returncode, 0, result.stderr[-16000:])
        self.assertEqual(
            subprocess.check_output([self.binary], text=True), expected
        )
        self.iteration += 1
        return (result.stdout or "") + result.stderr

    def test_unrelated_class_field_edit_removal_and_restore(self):
        sources = {
            "red.sk": "class GroupRed(value: Int)\n"
            "fun groupRed(): Int { GroupRed(7).value }\n",
            "blue.sk": "class GroupBlue(value: Int)\n"
            "fun groupBlue(): Int { GroupBlue(9).value }\n",
            "main.sk": "untracked fun main(): void { "
            "print_raw((groupRed() + groupBlue()).toString()) }\n",
        }
        self.compile(sources, "16")
        changed = dict(
            sources,
            **{
                "red.sk": "class GroupRed(value: String)\n"
                'fun groupRed(): Int { GroupRed("abc").value.length() }\n'
            }
        )
        trace = self.compile(changed, "12", trace=True)
        executions = [
            line
            for line in trace.splitlines()
            if line.startswith("CLASS_GROUP:")
        ]
        self.assertTrue(
            any("GroupRed" in line for line in executions), executions
        )
        self.assertFalse(
            any("GroupBlue" in line for line in executions), executions
        )
        self.compile(sources, "16")
        self.compile(
            dict(sources, **{"blue.sk": "fun groupBlue(): Int { 4 }\n"}), "11"
        )
        self.compile(sources, "16")

    def test_changed_partition_policy_preserves_existing_cache(self):
        sources = {
            "main.sk": 'untracked fun main(): void { print_raw("groups") }\n'
        }
        self.compile(sources, "groups")
        command = [
            os.environ["SKC_GROUP_TEST_COMPILER"],
            "--compact-specializer",
            "-O0",
            "--no-inline",
            "--no-ipa",
            "--export-function-as",
            "main=skip_main",
            str(self.root / "main.sk"),
            "-o",
            str(self.binary),
            "--data",
            str(self.root / "data"),
        ]
        result = subprocess.run(
            command, capture_output=True, text=True, timeout=30
        )
        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertIn(
            "Changing --partition-classes requires a fresh --init cache",
            result.stderr,
        )
        self.compile(sources, "groups")

    def test_independent_children_of_existing_parent_do_not_join(self):
        # An initial seed constructs the parent before the driver discovers
        # both factory bodies. Each child adds its own subtype edge.
        # A membership check for that edge must not read all of the parent's
        # subtype set for transaction-conflict purposes.
        sources = {
            "parent.sk": "base class MembershipParent { fun score(): Int; }\n"
            "class MembershipSeed() extends MembershipParent { "
            "fun score(): Int { 0 } }\n",
            "left.sk": "class MembershipLeft(value: Int) extends MembershipParent {\n"
            " fun score(): Int { this.value }\n}\n"
            "fun membershipLeft(): MembershipParent { MembershipLeft(7) }\n",
            "right.sk": "class MembershipRight(value: Int) extends MembershipParent {\n"
            " fun score(): Int { this.value }\n}\n"
            "fun membershipRight(): MembershipParent { MembershipRight(9) }\n",
            "main.sk": "fun membershipDrive(_seed: MembershipParent): Int { "
            "membershipLeft().score()+membershipRight().score() }\n"
            "untracked fun main(): void { "
            "print_raw(membershipDrive(MembershipSeed()).toString()) }\n",
        }
        trace = self.compile(sources, "16", trace=True, groups_only=True)
        groups = [
            line
            for line in trace.splitlines()
            if line.startswith("CLASS_GROUP:")
        ]
        self.assertTrue(
            any("MembershipLeft" in line for line in groups), groups
        )
        self.assertTrue(
            any("MembershipRight" in line for line in groups), groups
        )
        rounds = lambda name: {
            int(round_)
            for round_, families in re.findall(
                r"^CLASS_GROUP: (\d+) (.*)$", trace, flags=re.MULTILINE
            )
            if name in families
        }
        self.assertEqual(
            rounds("MembershipLeft"),
            rounds("MembershipRight"),
            "Both children must be constructed in the same round",
        )
        joined = [
            line
            for line in groups
            if "MembershipLeft" in line and "MembershipRight" in line
        ]
        self.assertFalse(joined, joined)
        changed = dict(
            sources,
            **{
                "left.sk": sources["left.sk"].replace(
                    "MembershipLeft(7)", "MembershipLeft(11)"
                )
            }
        )
        self.compile(changed, "20")
        removed = dict(
            sources,
            **{
                "left.sk": "fun membershipLeft(): MembershipParent { MembershipRight(3) }\n"
            }
        )
        self.compile(removed, "12")
        self.compile(sources, "16")

    def test_new_method_on_unrelated_generic_instance_preserves_later_construction(
        self,
    ):
        # The right-hand instance is discovered several rounds after the left.
        # Variance compares it with the earlier instance, but their arguments
        # are unrelated. Adding a called method on the left must not invalidate
        # construction on the right merely through that comparison.
        sources = {
            "types.sk": "class VarianceLeft()\n"
            "class VarianceRight()\n"
            "class VarianceBox<+T>(value: T) {\n"
            " fun first(): Int { 7 }\n"
            " fun second(): Int { 9 }\n}\n",
            "left.sk": "fun varianceLeft(): Int { "
            "VarianceBox(VarianceLeft()).first() }\n",
            "right.sk": "fun varianceRight(): Int { varianceRight2() }\n"
            "fun varianceRight2(): Int { varianceRight3() }\n"
            "fun varianceRight3(): Int { "
            "VarianceBox(VarianceRight()).first() }\n",
            "main.sk": "untracked fun main(): void { "
            "print_raw((varianceLeft() + varianceRight()).toString()) }\n",
        }
        initial = self.compile(sources, "14", trace=True, groups_only=True)
        box_rounds = {
            int(round_)
            for round_, families in re.findall(
                r"^CLASS_GROUP: (\d+) (.*)$", initial, flags=re.MULTILINE
            )
            if "VarianceBox" in families
        }
        self.assertGreaterEqual(
            len(box_rounds),
            2,
            "Fixture must discover the instances in distinct rounds",
        )
        later_round = max(box_rounds)
        changed = dict(
            sources,
            **{"left.sk": sources["left.sk"].replace(".first()", ".second()")}
        )
        trace = self.compile(changed, "16", trace=True)
        # Inspect the dependency causing invalidation, rather than accepting a
        # coincidentally fast result. Actual method propagation must remain
        # tracked for related class instances (covered by the relationship suite).
        offending = [
            line
            for line in trace.splitlines()
            if line.startswith("DIRTY READER: /specializer/class-attempts/")
            and "(dependency: /specializer/" in line
            and 'SClassID("VarianceBox<VarianceLeft>")' in line
        ]
        self.assertEqual(offending, [], "\n".join(offending)[:16000])
        self.assertFalse(
            any(
                int(round_) == later_round and "VarianceBox" in families
                for round_, families in re.findall(
                    r"^CLASS_GROUP: (\d+) (.*)$", trace, flags=re.MULTILINE
                )
            ),
            "The later, unrelated instance was reconstructed",
        )
        self.compile(sources, "14")


if __name__ == "__main__":
    unittest.main()
