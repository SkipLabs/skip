from pathlib import Path
import json
root=Path('/tmp/skip-layout-experiment');rows=[]
for p in sorted(root.glob('trace-after-*.log')):
 r={'log':p.name,'group_rows':0,'class_writes':[],'group_invalidations':[],'group_membership_writes':[],'reused':0}
 for l in p.open():
  if l.startswith('MAP_ROW: /specializer/layout-groups/ '):r['group_rows']+=1
  if l.startswith('WRITTEN:  /specializer/layout-fields/OuterIstToIR.SClassIDKey('):r['class_writes'].append(l.strip())
  if l.startswith('WRITTEN:  /specializer/layout-groups/'):r['group_membership_writes'].append(l.strip())
  if l.startswith('DIRTY READER: /specializer/layout-groups/') and '=> /specializer/layout-fields/ (dependency:' in l:r['group_invalidations'].append(l.strip())
  if l.startswith('REUSING: /specializer/layout-'):r['reused']+=1
 rows.append(r)
assert len(rows)==10 and rows[0]['group_rows']>1000
assert rows[1]['group_rows']==0 and not rows[1]['class_writes'] and not rows[1]['group_invalidations']
for i in [4,5]:
 assert any('LayoutA0' in l for l in rows[i]['group_membership_writes'])
 assert any('LayoutB0' in l for l in rows[i]['group_membership_writes'])
 assert any('SClassID("LayoutB0")' in l for l in rows[i]['class_writes'])
 assert not any('SClassID("LayoutB1")' in l for l in rows[i]['class_writes'])
for i in [7,8]:assert any('SClassID("LayoutZero")' in l for l in rows[i]['group_invalidations'])
assert any('SClassID("LayoutCpp")' in l for l in rows[6]['group_invalidations'])
(root/'trace-summary.json').write_text(json.dumps(rows,indent=2)+'\n')
print('Layout group reuse, merge/split and empty-group dependencies passed.')
