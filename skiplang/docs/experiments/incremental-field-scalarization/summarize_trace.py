from pathlib import Path
import json
root=Path('/tmp/skip-scalarize-experiment');rows=[]
for p in sorted(root.glob('trace-after-*.log')):
 r={'log':p.name,'scalarize_class_rows':0,'merge_class_rows':0,'class_writes':[],'invalidations':[],'reused':0}
 for l in p.open():
  if l.startswith('MAP_ROW: /specializer/latch-classes-merged/ OuterIstToIR.SClassIDKey('):r['scalarize_class_rows']+=1
  if l.startswith('MAP_ROW: /specializer/scalarize-fields/ OuterIstToIR.SClassIDKey('):r['merge_class_rows']+=1
  if l.startswith('WRITTEN:  /specializer/scalarize-fields/OuterIstToIR.SClassIDKey('):r['class_writes'].append(l.strip())
  if l.startswith('DIRTY READER: ') and '=> /specializer/scalarize-fields/ (dependency:' in l:r['invalidations'].append(l.strip())
  if l.startswith('REUSING: /specializer/scalarize-fields'):r['reused']+=1
 rows.append(r)
assert len(rows)==9 and rows[0]['scalarize_class_rows']>1000
assert rows[1]['scalarize_class_rows']==0 and rows[1]['reused']>0
for i in [2,3,4,5,6,7]:
 assert any('ScalarHolder0' in l for l in rows[i]['class_writes']),rows[i]
 assert not any('ScalarHolder1"' in l for l in rows[i]['class_writes']),rows[i]
 assert any('Array<ScalarNested0>' in l for l in rows[i]['invalidations']),rows[i]
 assert any('SClassID("ScalarLeaf0")' in l for l in rows[i]['invalidations']),rows[i]
(root/'trace-summary.json').write_text(json.dumps(rows,indent=2)+'\n')
print('Scalarization dependency/reuse trace assertions passed.')
