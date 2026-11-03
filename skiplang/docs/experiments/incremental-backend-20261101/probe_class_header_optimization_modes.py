"""Compare the optimization-mode failure with the frozen preceding compiler."""
import json
import os
from pathlib import Path
import sys
sys.path.insert(0,'/home/julienv/skip/skiplang/compiler/tools')
from test_class_headers import ClassHeadersTests
root=Path('/tmp/skip-incremental-next')
source=('base class HeaderBase { fun value(): Int { 7 } }\n'
        'class HeaderChild(extra: Int = 2) extends HeaderBase\n'
        'fun headerDispatch(x: HeaderBase): Int { x.value() }\n'
        'untracked fun main(): void { print_raw(headerDispatch(HeaderChild()).toString()) }\n')
os.environ.update(TMPDIR=str(root/'tmp'),SKSTORE_COMPACT_READERS='1',SKSTORE_BLOCK_READERS='1',
 SKSTORE_CANONICAL_READ_PATHS='1',SKC_INDEX_VARIANCE='1',SKC_LAMBDA_SOURCE_ANCHORS='1')
results=[]
for host,enabled,mode in [('skc-native-artifacts',False,'transition'),
                         ('skc-class-headers-diag1',False,'transition'),
                         ('skc-class-headers-diag1',True,'cold-o2'),
                         ('skc-class-headers-diag1',False,'cold-o2')]:
 os.environ['SKC_FUNCTION_TEST_COMPILER']=str(root/'bin'/host)
 test=ClassHeadersTests('test_full_class_readers_with_inline_ipa_and_debug')
 row=dict(host=host,headers=enabled,mode=mode)
 try:
  test.setUp()
  if not enabled:os.environ.pop('SKC_COLLECTION_CLASS_HEADERS',None)
  if mode=='transition':
   test.test_full_class_readers_with_inline_ipa_and_debug()
  else:
   test.optimization_flags=['-O2','--inline','--ipa']
   test.compile(source,'7')
   test.compile(source.replace('Int { 7 }','Int { 9 }'),'9')
  row['passed']=True
 except Exception as exc:
  row.update(passed=False,error=str(exc)[-3000:])
 finally:
  test.doCleanups()
 results.append(row)
 print(json.dumps(row),flush=True)
 (root/'class-headers-optimization-mode-controls.json').write_text(json.dumps(results,indent=2)+'\n')
