from pathlib import Path
import json,sys,collections,csv
import argparse
parser=argparse.ArgumentParser(description='Validate and export a completed graph census')
parser.add_argument('label')
parser.add_argument('--results',type=Path,required=True)
args=parser.parse_args()
p=args.results.resolve()
label=args.label
types=[];fields=[];dirs=[];rows=[];totals={};cache_totals={};models=[];keys=[]
for line in (p/(label+'.tsv')).read_text().splitlines():
 a=line.split('\t')
 if a[0]=='TYPE':
  types.append(dict(scope=a[1],vtable=a[2],name=a[3],kind=int(a[4]),width=int(a[5]),count=int(a[6]),payload=int(a[7]),bytes=int(a[8]),slots=int(a[9]),refs=int(a[10]),lengths=list(map(int,a[11:]))))
 elif a[0] in ['FIELD','GIRFIELD']:
  fields.append(dict(scope="gir" if a[0]=="GIRFIELD" else "payload",owner=a[1],offset=int(a[2]),kind=int(a[3]),target=a[4],width=int(a[5]),count=int(a[6]),elements=int(a[7]),max=int(a[8]),first_unique=int(a[9]),first_unique_bytes=int(a[10]),first_unique_elements=int(a[11]),lengths=list(map(int,a[12:]))))
 elif a[0]=='MODEL':models.append(dict(name=a[1],references=int(a[2]),distinct_roots=int(a[3]),distinct_nodes=int(a[4]),entries=int(a[5]),node_bytes=int(a[6]),flat_bytes=int(a[7]),lengths=list(map(int,a[8:]))))
 elif a[0]=='KEY_MODEL':keys.append(dict(name=a[1],count=int(a[2]),distinct_values=int(a[3]),bytes=int(a[4]),ideal_wrapper_saving=int(a[5])))
 elif a[0]=='DIR':
  dirs.append(dict(name=a[1],versions=int(a[2]),rows=int(a[3]),row_bytes=int(a[4]),files=int(a[5]),value_lengths=list(map(int,a[6:]))))
 elif a[0]=='ROW':rows.append(dict(dir=a[1],key=a[2],file=a[3],rows=int(a[4]),files=int(a[5])))
 elif a[0]=='CACHE_TOTAL':cache_totals=dict((k,int(v)) for k,v in (x.split('=') for x in a[1:]))
 elif a[0]=='TOTAL':totals=dict((k,int(v)) for k,v in (x.split('=') for x in a[1:]))
assert totals and (p/(label+'.tsv')).read_text().endswith('SHAPE_END\n')
for t in types:
 assert len(t['lengths'])==8
 if t['kind']==1:assert sum(t['lengths'])==t['count']
for f in fields:assert sum(f['lengths'])==f['count']
for m in models:
 assert m['entries']>=m['distinct_nodes'],m
 assert m['distinct_roots']<=m['distinct_nodes'],m
for d in dirs:assert sum(d['value_lengths'])==d['rows']
assert sum(d['rows'] for d in dirs)==sum(d['rows'] for d in rows)
full_types={t['vtable']:t for t in types if t['scope']=='context'}
for t in types:
 if t['scope']!='context':
  assert t['count']<=full_types[t['vtable']]['count'],t
  assert t['bytes']<=full_types[t['vtable']]['bytes'],t
scopes={}
for scope in ['context','payload','gir']:
 ts=[t for t in types if t['scope']==scope]
 scopes[scope]={k:sum(t[k] for t in ts) for k in ['count','payload','bytes','slots','refs']}
 prefix='' if scope=='context' else scope+'_'
 st=cache_totals if scope=='gir' else totals
 scopes[scope]['strings']=st[prefix+'strings'];scopes[scope]['string_bytes']=st[prefix+'string_bytes']
 scopes[scope]['total_bytes']=scopes[scope]['bytes']+scopes[scope]['string_bytes']
 scopes[scope]['total_objects']=scopes[scope]['count']+scopes[scope]['strings']
assert scopes['payload']['total_bytes']+scopes['gir']['total_bytes']-cache_totals['shared_object_bytes']<=scopes['context']['total_bytes']
summary=dict(label=label,scopes=scopes,totals=totals,cache_totals=cache_totals,models=models,key_models=keys,types=types,fields=fields,dirs=dirs,rows=rows)
(p/(label+'-analysis.json')).write_text(json.dumps(summary,indent=2)+'\n')
for kind,rs in [('types',types),('fields',fields),('dirs',dirs),('rows',rows)]:
 if rs:
  with (p/(label+'-'+kind+'.csv')).open('w') as f:
   w=csv.DictWriter(f,fieldnames=rs[0].keys());w.writeheader();w.writerows(rs)
print(json.dumps(scopes,indent=2))
print('Payload types by shallow allocation:')
for t in sorted((t for t in types if t['scope']=='payload'),key=lambda t:t['bytes'],reverse=True)[:25]:print(round(t['bytes']/2**20,2),'MiB',t['count'],t['name'],t['width'])
print('Payload collection fields:')
for f in sorted(fields,key=lambda f:f['first_unique_bytes'],reverse=True)[:30]:print(round(f['first_unique_bytes']/2**20,2),'MiB',f['owner'],f['offset'],f['kind'],f['width'],f['count'],f['lengths'])
print('Specializer directories',len(dirs),'rows',sum(d['rows'] for d in dirs))
