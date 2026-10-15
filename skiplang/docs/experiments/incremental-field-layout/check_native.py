from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import subprocess,os,json,time
repo=Path('/home/julienv/skip/skiplang/compiler');root=Path('/tmp/skip-layout-experiment/native');root.mkdir(exist_ok=True)
compiler='/tmp/skip-release-sequential-build/host/release/skc';stdlib='/tmp/skip-release-sequential-build/host/release/deps/libstd-d1d97ecd7abc2467.sklib'
fixtures=['Runtime/GenericTuple','Runtime/VectorTupleOrder','Runtime/PatternMatchNestedTuple','Runtime/TupleIterable','Runtime/TryCatchTuplecall','Native/Option1','Native/OptionMeta','Native/GcGenerator','Typechecking/TparamsPatternTuple2','Runtime/FieldInheritance','Runtime/PositionalConstructorMultiDiamond','Runtime/NamedConstructorMultiDiamond','Runtime/MethodDispatchMany']
env=os.environ.copy();env['SKIP_CAPACITY']='64G'
def run(job):
 fixture,mode=job;source=repo/'tests'/(fixture+'.sk');expected=(repo/'tests'/(fixture+'.exp')).read_text();name=fixture.replace('/','_')+'-'+mode;out=root/name;db=root/(name+'.db');db.unlink(missing_ok=True)
 cmd=[compiler,str(source),'-l','std='+stdlib,'-O0','--no-inline','--export-function-as',fixture.replace('/','_')+'.main=skip_main','--output',str(out)]
 cmd+=['--init',str(db)] if mode=='incremental' else ['--release']
 built=subprocess.run(cmd,capture_output=True,text=True,env=env)
 (root/(name+'.log')).write_text(built.stdout+built.stderr)
 assert built.returncode==0,(fixture,mode,built.stderr)
 result=subprocess.run([str(out)],capture_output=True,text=True,env=env)
 assert result.returncode==0,(fixture,mode,result.stderr)
 assert result.stdout==expected,(fixture,mode,result.stdout,expected)
 db.unlink(missing_ok=True)
 return dict(fixture=fixture,mode=mode,exit=0,output_matches=True,command=cmd)
start=time.monotonic()
with ThreadPoolExecutor(max_workers=2) as pool:results=list(pool.map(run,[(f,m) for f in fixtures for m in ['incremental','release']]))
summary=dict(tests=len(results),seconds=time.monotonic()-start,results=results)
(root/'results.json').write_text(json.dumps(summary,indent=2)+'\n');print('Native fixture checks passed:',len(results))
