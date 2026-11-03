"""Pair the isolated sequential reference with the completed same-host screen."""
import json
from pathlib import Path
root=Path('/tmp/skip-incremental-next');e=Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
identity=json.loads((root/'emission-locality-sequential-matrix-complete.json').read_text())
matched=json.loads((e/'emission-locality-matched-screen.json').read_text())
assert identity['host_identity']==matched['host']
rows={}
for case in ['cold','noop','literal-1','generic-1','history-historical-1','history-baseline-1']:
 d=root/'runs'/('emission-locality-sequential-'+case)
 phases=json.loads((d/'phases.json').read_text());meta=json.loads((d/'replay.json').read_text())
 assert meta['validation']=='passed' and meta['mode']=='sequential' and phases['successful']
 assert not meta['compiler_options']
 assert meta['host_sha256'][str(root/'host-native-artifacts/skc')]==matched['host']['binary_sha256']
 assert meta['profile_linker']==str(root/'bin/ld-lld-profile')
 assert abs(sum(phases['exclusive_seconds'].values())-phases['seconds'])<1e-6
 rows[case]=dict(seconds=phases['seconds'],exclusive_seconds=phases['exclusive_seconds'],
  sampled_peak_summed_rss=phases['sampled_peak_summed_rss'],
  highest_process_maxrss_bytes=phases.get('highest_process_maxrss_bytes'),
  validation=meta['validation'],host_sha256=meta['host_sha256'])
record=dict(comparison=identity['comparison'],host=matched['host'],sequential=rows,
 memory=json.loads((root/'emission-locality-sequential-full-census.json').read_text()))
(e/'sequential-native-matched-reference.json').write_text(json.dumps(record,indent=2)+'\n')
lines=['# Sequential backend reference on the current optimized host','',record['comparison'],'',
 'Clang compilation/driver below is exclusive of nested final linking. The sequential path invokes Clang on monolithic LLVM; the collection path records separate object commands. The independent table retains every compiler phase.','',
 '| Case | Sequential s | Collection control s | Spans s | Four workers s | Combined s | Sequential Clang s | Sequential link s |',
 '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |']
for case,row in rows.items():
 key=case[:-2] if case.endswith('-1') else case
 phase=row['exclusive_seconds'];clang=phase.get('Clang object compilation',0)+phase.get('Clang compilation/driver',0)
 vals=[matched['policies'][policy][key]['median_seconds'] for policy in ['control','spans','parallel','combined']]
 lines.append(f"| {key} | {row['seconds']:.6f} | "+' | '.join(f'{x:.6f}' for x in vals)+f" | {clang:.6f} | {phase.get('Final native linking',0):.6f} |")
lines+=['','## Exclusive sequential phases','','| Phase | '+' | '.join(rows)+' |', '| --- | '+' | '.join('---:' for _ in rows)+' |']
for phase in sorted(set().union(*(row['exclusive_seconds'] for row in rows.values()))):
 lines.append('| '+phase+' | '+' | '.join(f"{row['exclusive_seconds'].get(phase,0):.6f}" for row in rows.values())+' |')
lines.append('| **Total** | '+' | '.join(f"**{row['seconds']:.6f}**" for row in rows.values())+' |')
(e/'sequential-native-matched-reference.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines[:15]))
