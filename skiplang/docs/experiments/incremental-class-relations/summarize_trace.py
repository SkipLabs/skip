from pathlib import Path
import json
root=Path('/tmp/skip-latch-experiment')
rows=[]
for p in sorted(root.glob('trace-after-*.log')):
 r={'log':p.name,'bytes':p.stat().st_size,'merge_class_rows':0,'latched_class_writes':[],'relation_invalidations':[],'reused':0}
 for line in p.open():
  if line.startswith('MAP_ROW: /specializer/latch-classes/ OuterIstToIR.SClassIDKey('):r['merge_class_rows']+=1
  if line.startswith('WRITTEN:  /specializer/latch-classes/OuterIstToIR.SClassIDKey('):r['latched_class_writes'].append(line.strip())
  if line.startswith('DIRTY READER: ') and '=> /specializer/latch-classes/ (dependency:' in line:r['relation_invalidations'].append(line.strip())
  if line.startswith('REUSING: /specializer/latch-classes'):r['reused']+=1
 rows.append(r)
assert rows[0]['merge_class_rows']>1000
assert rows[1]['reused']>0 and not rows[1]['latched_class_writes']
for i in [3,4]:
 assert any('SubtypesKey(SClassID("LatchBase0"))' in l for l in rows[i]['relation_invalidations'])
 assert not any('LatchBase1"' in l for l in rows[i]['latched_class_writes'])
(root/'trace-summary.json').write_text(json.dumps(rows,indent=2)+'\n')
print('Trace assertions passed, including subtype invalidation on addition and removal.')
