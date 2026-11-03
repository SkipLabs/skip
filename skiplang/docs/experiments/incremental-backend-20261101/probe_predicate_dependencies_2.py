"""Diagnostic control: does a layout change re-optimize a plain identity?"""
import json,os,sys,unittest,re
from pathlib import Path
sys.path.insert(0,'/home/julienv/skip/skiplang/compiler/tools')
import test_function_collections as functions

class Probe(functions.FunctionCollectionsTests):
    def test_class_metadata_read(self):
        assert os.environ.get('SKC_FUNCTION_TEST_COMPILER')
        self.extra_flags=['--collection-classes']
        source=('class PredicateBox(value: Int)\n'
                'fun predicateIdentity(x: PredicateBox): PredicateBox { x }\n'
                'untracked fun main(): void {\n'
                ' x = predicateIdentity(PredicateBox(7));\n'
                ' print_raw(x.value.toString())\n}\n')
        self.compile(source,'7')
        changed=source.replace('value: Int)', 'value: Int, extra: Int = 3)')
        trace=self.compile(changed,'7',trace=True)
        callbacks=[line for line in trace.splitlines() if line.startswith(('OPTIMIZE_FUNCTION:','NATIVE_LOWER:','LLVM_FUNCTION:')) and 'predicateIdentity' in line]
        record={'compiler':os.environ['SKC_FUNCTION_TEST_COMPILER'],'callbacks':callbacks,'optimized':any(line.startswith('OPTIMIZE_FUNCTION:') for line in callbacks),'expected_output':'7'}
        lines = trace.splitlines()
        contexts = []
        keys = set()
        for i, line in enumerate(lines):
            if line.startswith('OPTIMIZE_FUNCTION:') and 'predicateIdentity' in line:
                contexts.extend(lines[max(0,i-4):i+5])
                for following in lines[i+1:i+4]:
                    if following.startswith('WRITTEN:'):
                        keys.update(re.findall(r'SFunctionID\(\d+\)', following))
                        break
                for preceding in reversed(lines[:i]):
                    if preceding.startswith('MAP_ROW:'):
                        keys.add(preceding.split(' ', 2)[-1])
                        break
        dependencies = [line for line in lines if line.startswith(('DIRTY READER:', 'WRITTEN:'))
                        and any(key in line for key in keys)]
        record.update(context=contexts[:40], keys=sorted(keys), dependencies=dependencies[:100])
        Path('/tmp/skip-incremental-next/class-predicate-dependency-probe-2.json').write_text(json.dumps(record,indent=2)+'\n')
        print(json.dumps(record),flush=True)
        if os.environ.get('PREDICATE_PROBE_EXPECT')=='recompute':self.assertTrue(record['optimized'],record)
        if os.environ.get('PREDICATE_PROBE_EXPECT')=='reuse':self.assertFalse(record['optimized'],record)
        self.compile(source,'7')

if __name__=='__main__':unittest.main(defaultTest='Probe.test_class_metadata_read')
