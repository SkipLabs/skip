private def mkMetaConfig (c : Config) : MetaM ConfigWithKey := do
  let curr ← Meta.getConfig
  return { curr with
    beta         := c.beta
    iota         := c.iota
    zeta         := c.zeta
    zetaHave     := c.zetaHave
    zetaUnused   := c.zetaUnused
    zetaDelta    := c.zetaDelta
    etaStruct    := c.etaStruct
    proj         := if c.proj then .yesWithDelta else .no
    transparency := .reducible
  : Meta.Config }.toConfigWithKey
