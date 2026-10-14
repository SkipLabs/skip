from pathlib import Path
import subprocess,json,os,time
root=Path('/tmp/skip-specializer-parallel')
cmd=json.loads((root/'workers-4-trial-1.json').read_text())['command']
cmd[cmd.index('--init')+1]=str(root/'profile-4.db')
cmd[cmd.index('--output')+1]=str(root/'profile-4.ll')
env=os.environ.copy();env.update(SKIP_CAPACITY='64G',SKARGO_PKG_NAME='skc',SKARGO_PKG_VERSION='0.3.3',GIT_COMMIT_HASH='4f76be39',SKARGO_MANIFEST_DIR=str(root/'workload/skiplang/compiler'))
perf=['perf','record','-e','cpu-clock:u','-F','99','--call-graph','fp','-o',str(root/'profile-4.data'),'--',*cmd]
(root/'profile-4-command.json').write_text(json.dumps(perf,indent=2)+'\n')
with (root/'profile-4.log').open('w') as log:
 rc=subprocess.run(perf,env=env,cwd='/home/julienv/skip/skiplang/compiler',stdout=log,stderr=subprocess.STDOUT).returncode
print('Profile exit:',rc,flush=True)
raise SystemExit(rc)
