from pathlib import Path
import subprocess,os,json
root=Path('/tmp/skip-parsing')
cmd=json.loads((root/'workers-0-trial-1.json').read_text())['command']
env=os.environ.copy();env.update(SKIP_CAPACITY='64G',SKARGO_PKG_NAME='skc',SKARGO_PKG_VERSION='0.3.3',GIT_COMMIT_HASH='4f76be39',SKARGO_MANIFEST_DIR='/tmp/skip-specializer-parallel/workload/skiplang/compiler',DEBUGINFOD_URLS='')
run=['perf','record','-e','cpu-clock:u','-F','199','--call-graph','dwarf,16384','-o',str(root/'frontend.data'),'--',*cmd]
(root/'frontend-profile-command.json').write_text(json.dumps(run,indent=2)+'\n')
with (root/'frontend-profile.log').open('w') as log:
 p=subprocess.run(run,env=env,cwd='/home/julienv/skip/skiplang/compiler',stdout=log,stderr=subprocess.STDOUT)
raise SystemExit(p.returncode)
