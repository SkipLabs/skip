"""Bounded functional probe; no latency claim and no full store trace retained."""
import hashlib
import json
import os
from pathlib import Path
import re
import sys

root=Path('/tmp/skip-incremental-next')
sys.path.insert(0,'/home/julienv/skip/skiplang/compiler/tools')
from test_class_groups import ClassGroupTests
os.environ['SKC_GROUP_TEST_COMPILER']=str(root/'bin/skc-stable-vtable')
os.environ['SKC_HIERARCHICAL_DISCOVERY']='1'
os.environ['SKC_BATCH_CACHED_SPECIALIZATION']='1'
os.environ['SKC_CHECKPOINT_BACKEND_PHASES']='1'
test=ClassGroupTests(methodName='runTest')
test.setUp()
sources={
    'lambda.sk':'fun closureEdit(): Int { f = () -> 7; f() }\n',
    'other.sk':'class ClosureUnrelated(value: Int)\n'
               'fun closureLater(): Int { closureLater2() }\n'
               'fun closureLater2(): Int { closureLater3() }\n'
               'fun closureLater3(): Int { ClosureUnrelated(7).value }\n',
    'main.sk':'untracked fun main(): void { print_raw((closureEdit() + closureLater()).toString()) }\n',
}
result=dict(host=json.loads((root/'host-stable-vtable/identity.json').read_text()),sources=sources,cases=[])
try:
    changed=dict(sources,**{'lambda.sk':sources['lambda.sk'].replace('-> 7','-> 9')})
    for name,source,expected in [('cold',sources,'14'),('literal',changed,'16'),('restore',sources,'14')]:
        trace=test.compile(source,expected,trace=True,groups_only=True)
        groups=[line for line in trace.splitlines() if line.startswith('CLASS_GROUP:')]
        result['cases'].append(dict(case=name,expected_output=expected,validation='passed',executed_groups=groups))
        print(name,groups,flush=True)
finally:
    test.doCleanups()
(root/'closure-class-locality-probe.json').write_text(json.dumps(result,indent=2)+'\n')
