import os,subprocess
from pathlib import Path
r=Path('/tmp/skip-incremental-next');d=r/'lambda-anchor-index-probe';s=r/'host-support-compact-readers'
command=[str(r/'bin/skc-groups'),'-L',str(s),'-l','std='+str(s/'libstd.sklib'),'-l','skc='+str(r/'host-closure-anchors-diag1/libskc.sklib'),str(d/'probe.sk'),'--release','-O0','--export-function-as','anchorDiagnostic=skip_main','-o',str(d/'probe')]
subprocess.run(command,env=dict(os.environ,TMPDIR=str(r/'tmp')),check=True)
result=subprocess.run([str(d/'probe')],env=dict(os.environ,SKC_LAMBDA_SOURCE_ANCHORS='1'),capture_output=True,text=True,check=True)
assert len(result.stdout)<65536
(d/'result.txt').write_text(result.stdout)
print(result.stdout)
