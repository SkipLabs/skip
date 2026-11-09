
@[inline] def modifyCache (f : Cache → Cache) : CoreM Unit :=
  modify fun ⟨env, next, ngen, auxDeclNGen, trace, cache, deps, messages, infoState, snaps⟩ =>
   ⟨env, next, ngen, auxDeclNGen, trace, f cache, deps, messages, infoState, snaps⟩

@[inline] def modifyRecordedDeps (f : RecordedDeps → RecordedDeps) : CoreM Unit :=
  modify fun ⟨env, next, ngen, auxDeclNGen, trace, cache, deps, messages, infoState, snaps⟩ =>
   ⟨env, next, ngen, auxDeclNGen, trace, cache, f deps, messages, infoState, snaps⟩

@[inline] def modifyInstLevelTypeCache (f : InstantiateLevelCache → InstantiateLevelCache) : CoreM Unit :=
  modifyCache fun ⟨c₁, c₂⟩ => ⟨f c₁, c₂⟩

@[inline] def modifyInstLevelValueCache (f : InstantiateLevelCache → InstantiateLevelCache) : CoreM Unit :=
  modifyCache fun ⟨c₁, c₂⟩ => ⟨c₁, f c₂⟩

def instantiateTypeLevelParams (c : ConstantVal) (us : List Level) : CoreM Expr := do
  if let some (us', r) := (← get).cache.instLevelType.find? c.name then
    if us == us' then
      return r
  let r := c.instantiateTypeLevelParams us
  modifyInstLevelTypeCache fun s => s.insert c.name (us, r)
  return r

def instantiateValueLevelParams (c : ConstantInfo) (us : List Level) (allowOpaque := false) : CoreM Expr := do
  if let some (us', r) := (← get).cache.instLevelValue.find? c.name then
    if us == us' then
      return r
  unless c.hasValue (allowOpaque := allowOpaque) do
    throwError "Not a definition or theorem: {.ofConstName c.name}"
  let r := c.instantiateValueLevelParams! us (allowOpaque := allowOpaque)
  modifyInstLevelValueCache fun s => s.insert c.name (us, r)
  return r
