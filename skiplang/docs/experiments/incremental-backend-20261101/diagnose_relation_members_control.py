import json
import sys
from pathlib import Path
import unittest
sys.path.insert(0,'/home/julienv/skip/skiplang/compiler/tools')
from test_class_groups import ClassGroupTests
records=[]
original=ClassGroupTests.compile
def observed(self,*args,**kwargs):
    result=original(self,*args,**kwargs)
    groups=[line for line in result.splitlines() if line.startswith(('CLASS_GROUP:', 'CLASS_GROUPS_ACCEPTED:'))]
    if groups: records.append(groups)
    return result
ClassGroupTests.compile=observed
suite=unittest.TestSuite([ClassGroupTests('test_independent_children_of_existing_parent_do_not_join')])
result=unittest.TextTestRunner(verbosity=2).run(suite)
Path('/tmp/skip-incremental-next/relation-members-control-groups.json').write_text(json.dumps(records,indent=2)+'\n')
for group in records:
    for line in group:
        if 'Membership' in line: print(line)
raise SystemExit(not result.wasSuccessful())
