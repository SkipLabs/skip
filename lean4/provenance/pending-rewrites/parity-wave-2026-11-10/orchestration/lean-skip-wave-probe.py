# Compile a private lane overlay without changing maintained production files.
from pathlib import Path
import hashlib,json,sys
ROOT=Path('/home/julienv/skip/lean4')
sys.path.insert(0,str(ROOT/'tools'))
import probe
from select_sources import catalog,NON_CODE,REFERENCE
from rewrite_integrate import parse_functions,retained_body,canonical_abi
lane=sys.argv.pop(1)
packet=ROOT/'build/parity-wave'/lane
functions,files=catalog()
manifest=json.loads((packet/'manifest.json').read_text())
added={};seen=set()
for f in manifest['targets']:
 module,name=f['name'].split('.')
 original=functions[f['name']]
 assert hashlib.sha256(original[3].encode()).hexdigest()==f['body_sha256'],f['name']
 source=original[0].read_text();_,oldfns=parse_functions(source,str(original[0]));oldfn=next(x for x in oldfns if x.name==name)
 oldbody=source[oldfn.start:oldfn.end]
 fallback=retained_body(oldbody,module,name)
 def register(identity,body,path,start=0):
  assert identity not in added,identity
  refs={(m[1] or module)+'.'+m[2] for m in REFERENCE.finditer(NON_CODE.sub('',body))}
  added[identity]=(path,start,start+len(body),body,refs)
 register(f['name']+'_fallback',fallback,original[0])
 replacement=packet/'replacements'/(name+'.sk');text=replacement.read_text()
 newmodule,newfns=parse_functions(text,str(replacement),functions_only=True);assert newmodule==module
 newfn=next(x for x in newfns if x.name==name)
 assert canonical_abi(source,oldfn)==canonical_abi(text,newfn)
 for fn in newfns:
  identity=module+'.'+fn.name
  assert identity==f['name'] or identity not in functions,identity
  register(identity,text[fn.start:fn.end],replacement,fn.start)
 functions.pop(f['name'])
functions.update(added)
probe.catalog=lambda:(functions,files)
probe.main()
