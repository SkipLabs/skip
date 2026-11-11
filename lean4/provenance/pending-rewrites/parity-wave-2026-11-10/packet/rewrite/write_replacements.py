from pathlib import Path
import re
ROOT = Path(__file__).resolve().parent
OUT = ROOT / 'replacements'
OUT.mkdir(exist_ok=True)
NS = {'MB':'Lean_Meta_Basic','E':'Lean_Expr','P':'Init_Prelude','AB':'Lean_Meta_AppBuilder','T':'Lean_Meta_Tactic_Simp_Types','C':'Lean_CoreM','M':'Lean_Message','TR':'Lean_Util_Trace','ST':'Init_System_ST','A':'Init_Data_Array_Basic','U':'Init_Data_UInt_BasicAux'}

def expand(s, prefix):
    s=s.replace('HELP_', 'f_rewriteWave_'+prefix+'_')
    for k,v in NS.items(): s=s.replace('@'+k+'.', 'L4_'+v+'.')
    return s

def helpers(prefix):
    return expand('''// Validate the same constructor projections as the original, including discarded fields.
fun HELP_fields(value: LeanValue, tag: LeanTag.Value, count: Int): Array<LeanValue> {
  if (leanTag(value) != tag) return leanFail("non-exhaustive Lean case");
  for (index in Range(0, count)) { _ = leanField(value, index) };\n  value match {\n  | LeanCtor(_, fields) -> fields\n  | _ -> leanFail("non-exhaustive Lean case")\n  }
}

fun HELP_bool(value: LeanValue): Bool {
  leanTag(value) match {
  | LeanTag.Bool_false -> false
  | LeanTag.Bool_true -> true
  | _ -> leanFail("non-exhaustive Lean case")
  }
}

// Preserve error payload and returned world, rather than converting failure to no-match.
fun HELP_ok(output: LeanValue): Bool {
  leanTag(output) match {
  | LeanTag.EST_Out_ok ->
    _ = leanField(output, 0);
    _ = leanField(output, 1);
    true
  | LeanTag.EST_Out_error ->
    _ = leanField(output, 0);
    _ = leanField(output, 1);
    false
  | _ -> leanFail("non-exhaustive Lean case")
  }
}

''',prefix)

def write(name,prefix,body,extra=''):
    original=(ROOT/'originals'/f'{name}.sk').read_text()
    header=original[:original.index('  // Frame slots:')]
    module=header[:header.index('//')]
    canonical=header[header.index('//'):]
    (OUT/f'{name}.sk').write_text(module+helpers(prefix)+expand(extra,prefix)+canonical+expand(body,prefix)+'\n}\n\nmodule end;\n')

write('f_Simp_simprocArrayCore_spec_0_0d13093a68','simproc','''  post = _post_0_input;
  simprocs = _as_1_input;
  size = _sz_2_input;
  index = _i_3_input;
  accumulator = _b_4_input;
  methods = _y_1_5_input;
  simpContext = _y_2_6_input;
  simpState = _y_3_7_input;
  metaContext = _y_4_8_input;
  metaState = _y_5_9_input;
  coreContext = _y_6_10_input;
  coreState = _y_7_11_input;
  world = _y_8_12_input;
  loop {
    inBounds = @U.f_USize_decLt_ed49caa57a(_runtime, index, size);
    if (!HELP_bool(inBounds)) {
      return LeanCtor(LeanTag.EST_Out_ok, Array[accumulator, world])
    };
    outer = HELP_fields(accumulator, LeanTag.Prod_mk, 2);
    progress = HELP_fields(outer[1], LeanTag.Prod_mk, 2);
    expressionAndProof = HELP_fields(progress[1], LeanTag.Prod_mk, 2);
    proofAndCache = HELP_fields(expressionAndProof[1], LeanTag.Prod_mk, 2);
    changed = progress[0];
    expression = expressionAndProof[0];
    proof = proofAndCache[0];
    cache = proofAndCache[1];
    noStep = LeanCtor(LeanTag.Option_none, Array[]);
    entry = @A.f_Array_uget_c7e0af4dc5(_runtime, LeanErased(), simprocs, index, LeanErased());
    // The phase discriminator is checked before the Simprocs record, as before.
    isPost = HELP_bool(post);
    trees = HELP_fields(entry, LeanTag.Meta_Simp_Simprocs_mk, 4);
    tree = if (isPost) trees[1] else trees[0];
    entryFields = HELP_fields(entry, LeanTag.Meta_Simp_Simprocs_mk, 4);
    outcome = f_Meta_Simp_simprocCore_1e0ec177be(
      _runtime, post, tree, entryFields[3], expression, methods, simpContext, simpState,
      metaContext, metaState, coreContext, coreState, world,
    );
    if (!HELP_ok(outcome)) return outcome;
    step = leanField(outcome, 0);
    !world = leanField(outcome, 1);
    leanTag(step) match {
    | LeanTag.Meta_Simp_Step_done | LeanTag.Meta_Simp_Step_visit ->
      terminalComposition = @T.f_Meta_Simp_mkEqTransOptProofResult_36f2da1295(
        _runtime, proof, cache, leanField(step, 0), metaContext, metaState,
        coreContext, coreState, world,
      );
      if (!HELP_ok(terminalComposition)) return terminalComposition;
      terminal = LeanCtor(leanTag(step), Array[leanField(terminalComposition, 0)]);
      // A terminal result does not replace the accumulated progress fields.
      terminalAccumulator = HELP_accumulator(LeanCtor(LeanTag.Option_some, Array[terminal]), changed, expression, proof, cache);
      return LeanCtor(LeanTag.EST_Out_ok, Array[terminalAccumulator, leanField(terminalComposition, 1)])
    | LeanTag.Meta_Simp_Step_continue ->
      optionalResult = leanField(step, 0);
      leanTag(optionalResult) match {
      | LeanTag.Option_none ->
        !accumulator = HELP_accumulator(noStep, changed, expression, proof, cache)
      | LeanTag.Option_some ->
        continuationFields = HELP_fields(leanField(optionalResult, 0), LeanTag.Meta_Simp_Result_mk, 3);
        continuationComposition = @AB.f_Lean_Meta_mkEqTrans_0b2fd7caf3(
          _runtime, proof, continuationFields[1], metaContext, metaState, coreContext, coreState, world,
        );
        if (!HELP_ok(continuationComposition)) return continuationComposition;
        // Cacheability is a short-circuit conjunction, never an eager read of result[2]'s tag.
        nextCache = if (HELP_bool(cache)) continuationFields[2] else LeanCtor(LeanTag.Bool_false, Array[]);
        !accumulator = HELP_accumulator(noStep, inBounds, continuationFields[0], leanField(continuationComposition, 0), nextCache);
        !world = leanField(continuationComposition, 1)
      | _ -> return leanFail("non-exhaustive Lean case")
      }
    | _ -> return leanFail("non-exhaustive Lean case")
    };
    // Keep USize modulo arithmetic instead of a host signed counter.
    !index = @U.f_USize_add_559d423481(_runtime, index, LeanWord("usize", 1))
  }''','''fun HELP_accumulator(step: LeanValue, changed: LeanValue, expression: LeanValue, proof: LeanValue, cache: LeanValue): LeanValue {
  proofAndCache = LeanCtor(LeanTag.Prod_mk, Array[proof, cache]);
  expressionAndProof = LeanCtor(LeanTag.Prod_mk, Array[expression, proofAndCache]);
  progress = LeanCtor(LeanTag.Prod_mk, Array[changed, expressionAndProof]);
  LeanCtor(LeanTag.Prod_mk, Array[step, progress])
}

''')

write('f_Simp_preDefault_lam_0_da18db3c18','decide','''  expression = _y_2_1_input;
  simpContext = _y_4_3_input;
  metaContext = _y_6_5_input;
  metaState = _y_7_6_input;
  coreContext = _y_8_7_input;
  coreState = _y_9_8_input;
  world = _y_10_9_input;
  context = HELP_fields(simpContext, LeanTag.Private_Lean_Meta_Tactic_Simp_Types_0_Lean_Meta_Simp_Context_mk, 13);
  config = HELP_fields(context[0], LeanTag.Meta_Simp_Config_mk, 32);
  decide = config[11];
  if (!HELP_bool(decide)) return HELP_continue(world);
  if (HELP_bool(@E.f_Lean_Expr_hasFVar_ec2474cd19(_runtime, expression))) return HELP_continue(world);
  if (HELP_bool(@E.f_Lean_Expr_hasMVar_6b07f9e1fb(_runtime, expression))) return HELP_continue(world);
  if (HELP_bool(@E.f_Lean_Expr_isTrue_b2452f9f4d(_runtime, expression))) return HELP_continue(world);
  if (HELP_bool(@E.f_Lean_Expr_isFalse_99e8d268a0(_runtime, expression))) return HELP_continue(world);
  decision = @AB.f_Lean_Meta_mkDecide_be78d0b34b(_runtime, expression, metaContext, metaState, coreContext, coreState, world);
  if (!HELP_ok(decision)) return HELP_recover(_runtime, decision);
  decisionExpr = leanField(decision, 0);
  !world = leanField(decision, 1);
  metaConfig = @MB.f_Meta_Context_config_2f4f6fdcbe(_runtime, metaContext);
  configFields = HELP_fields(metaConfig, LeanTag.Meta_Config_mk, 20);
  defaultTransparency = LeanCtor(LeanTag.Meta_TransparencyMode_default, Array[]);
  sameTransparency = L4_Init_MetaTypes.f_Meta_instBEqTransparencyMode_beq_1ac79fc3aa(_runtime, configFields[9], defaultTransparency);
  reductionContext = metaContext;
  if (!HELP_bool(sameTransparency)) {
    contextFields = HELP_fields(metaContext, LeanTag.Meta_Context_mk, 11);
    key = @MB.f_Meta_ConfigWithKey_setTransparency_d2874c92d7(_runtime, defaultTransparency, contextFields[0]);
    !reductionContext = LeanCtor(LeanTag.Meta_Context_mk, Array[key, contextFields[1], contextFields[2], contextFields[3], contextFields[4], contextFields[5], contextFields[6], contextFields[7], contextFields[8], contextFields[9], contextFields[10]])
  };
  reduced = @MB.f_Lean_Meta_whnf_6493600863(_runtime, decisionExpr, reductionContext, metaState, coreContext, coreState, world);
  if (!HELP_ok(reduced)) return HELP_recover(_runtime, reduced);
  normal = leanField(reduced, 0);
  !world = leanField(reduced, 1);
  boolName = LeanText("Bool");
  trueName = @P.f_Lean_Name_mkStr2_ed89eae6ad(_runtime, boolName, LeanText("true"));
  isTrue = @E.f_Lean_Expr_isConstOf_4f5ae73265(_runtime, normal, trueName);
  valueName = trueName;
  propositionText = "True";
  theoremText = "eq_true_of_decide";
  if (!HELP_bool(isTrue)) {
    falseName = @P.f_Lean_Name_mkStr2_ed89eae6ad(_runtime, boolName, LeanText("false"));
    if (!HELP_bool(@E.f_Lean_Expr_isConstOf_4f5ae73265(_runtime, normal, falseName))) return HELP_continue(world);
    !valueName = falseName;
    !propositionText = "False";
    !theoremText = "eq_false_of_decide"
  };
  levels = LeanCtor(LeanTag.List_nil, Array[]);
  boolValue = @E.f_Lean_mkConst_b40a363b86(_runtime, valueName, levels);
  reflexivity = @AB.f_Lean_Meta_mkEqRefl_d0c1358b39(_runtime, boolValue, metaContext, metaState, coreContext, coreState, world);
  if (!HELP_ok(reflexivity)) return HELP_recover(_runtime, reflexivity);
  propositionName = @P.f_Lean_Name_mkStr1_4962bb4b4e(_runtime, LeanText(propositionText));
  proposition = @E.f_Lean_mkConst_b40a363b86(_runtime, propositionName, levels);
  theoremName = @P.f_Lean_Name_mkStr1_4962bb4b4e(_runtime, LeanText(theoremText));
  theorem = @E.f_Lean_mkConst_b40a363b86(_runtime, theoremName, levels);
  instance = @E.f_Lean_Expr_appArg_751e777947(_runtime, decisionExpr);
  arguments = @P.f_Array_mkEmpty_c33c0c30cd(_runtime, LeanErased(), LeanNatLiterals.n3);
  !arguments = @P.f_Array_push_9cb6e9b3cb(_runtime, LeanErased(), arguments, expression);
  !arguments = @P.f_Array_push_9cb6e9b3cb(_runtime, LeanErased(), arguments, instance);
  !arguments = @P.f_Array_push_9cb6e9b3cb(_runtime, LeanErased(), arguments, leanField(reflexivity, 0));
  proof = @E.f_Lean_mkAppN_941bfcfa8e(_runtime, theorem, arguments);
  result = LeanCtor(LeanTag.Meta_Simp_Result_mk, Array[proposition, LeanCtor(LeanTag.Option_some, Array[proof]), decide]);
  LeanCtor(LeanTag.EST_Out_ok, Array[LeanCtor(LeanTag.Meta_Simp_Step_done, Array[result]), leanField(reflexivity, 1)])''','''fun HELP_continue(world: LeanValue): LeanValue {
  LeanCtor(LeanTag.EST_Out_ok, Array[LeanCtor(LeanTag.Meta_Simp_Step_continue, Array[LeanCtor(LeanTag.Option_none, Array[])]), world])
}

fun HELP_recover(runtime: mutable LeanExecution, failure: LeanValue): LeanValue {
  exception = leanField(failure, 0);
  if (HELP_bool(L4_Lean_Exception.f_Lean_Exception_isInterrupt_eb68b9cc5e(runtime, exception))) return failure;
  if (HELP_bool(@C.f_Lean_Exception_isRuntime_7532163bc2(runtime, exception))) return failure;
  // Ordinary elaboration failure is swallowed, retaining its world and reference effects.
  HELP_continue(leanField(failure, 1))
}

''')

write('f_Simp_rewrite_rewriteUsingIndex_2de5b683e1','index','''  expression = _e_0_input;
  simp = HELP_fields(_a_6_input, LeanTag.Private_Lean_Meta_Tactic_Simp_Types_0_Lean_Meta_Simp_Context_mk, 13);
  indexConfig = HELP_fields(simp[5], LeanTag.Private_Lean_Meta_Basic_0_Lean_Meta_ConfigWithKey_mk, 2)[0];
  meta = HELP_fields(_a_8_input, LeanTag.Meta_Context_mk, 11);
  configKey = @MB.f_Meta_Config_toKey_993126c67a(_runtime, indexConfig);
  keyedConfig = LeanCtor(LeanTag.Private_Lean_Meta_Basic_0_Lean_Meta_ConfigWithKey_mk, Array[indexConfig, configKey]);
  lookupContext = LeanCtor(LeanTag.Meta_Context_mk, Array[keyedConfig, meta[1], meta[2], meta[3], meta[4], meta[5], meta[6], meta[7], meta[8], meta[9], meta[10]]);
  matches = L4_Lean_Meta_DiscrTree_Main.f_Meta_DiscrTree_getMatchWithExtra_a30031a7bf(
    _runtime, _s_1_input, expression, lookupContext, _a_9_input, _a_10_input, _a_11_input, _a_1_12_input,
  );
  if (!HELP_ok(matches)) return matches;
  candidates = leanField(matches, 0);
  world = leanField(matches, 1);
  count = @P.f_Array_size_3866d4555a(_runtime, LeanErased(), candidates);
  noMatches = @P.f_Nat_decEq_3e841b85bb(_runtime, count, LeanNatLiterals.n0);
  if (!HELP_bool(noMatches)) {
    // Retain the existing priority/tie-order routine and arbitrary-precision Nat fuel.
    sorted = f_rewrite_rewriteUsingIndex_spec_0_42236e3a20(_runtime, candidates, LeanNatLiterals.n0, count);
    selectionOptions = @C.f_Core_instMonadOptionsCoreM_checkedOptions_735ae7dbd5(_runtime, _a_10_input);
    backwardOption = leanReadInitializer(_runtime, "Lean.backward.defeqAttrib.useBackward");
    backward = f_Simp_discharge_spec_3_b456dc217a(_runtime, selectionOptions, backwardOption);
    none = LeanCtor(LeanTag.Option_none, Array[]);
    initial = LeanCtor(LeanTag.Prod_mk, Array[none, LeanCtor(LeanTag.PUnit_unit, Array[])]);
    size = @A.f_Array_usize_3065e2d82a(_runtime, LeanErased(), sorted);
    attempted = f_rewrite_rewriteUsingIndex_spec_3_266ff70323(
      _runtime, expression, _rflOnly_4_input, _erased_2_input, backward,
      sorted, size, LeanWord("usize", 0), initial, _a_5_input, _a_6_input,
      _a_7_input, _a_8_input, _a_9_input, _a_10_input, _a_11_input, world,
    );
    if (!HELP_ok(attempted)) return attempted;
    pair = HELP_fields(leanField(attempted, 0), LeanTag.Prod_mk, 2);
    leanTag(pair[0]) match {
    | LeanTag.Option_none -> return LeanCtor(LeanTag.EST_Out_ok, Array[none, leanField(attempted, 1)])
    | LeanTag.Option_some -> return LeanCtor(LeanTag.EST_Out_ok, Array[leanField(pair[0], 0), leanField(attempted, 1)])
    | _ -> return leanFail("non-exhaustive Lean case")
    }
  };
  // Empty lookup still performs the original trace-option checks and message effects.
  core = HELP_fields(_a_10_input, LeanTag.Core_Context_mk, 8);
  cold = HELP_fields(core[0], LeanTag.Core_Context_Cold_mk, 12);
  options = HELP_fields(cold[2], LeanTag.Private_Lean_Data_Options_0_Lean_Options_mk, 2);
  if (HELP_bool(options[1])) {
    traceClass = @P.f_Lean_Name_mkStr4_cfa3e36682(_runtime, LeanText("Debug"), LeanText("Meta"), LeanText("Tactic"), LeanText("simp"));
    tracePrefix = @P.f_Lean_Name_mkStr1_4962bb4b4e(_runtime, LeanText("trace"));
    optionName = @P.f_Lean_Name_append_54ec01d162(_runtime, tracePrefix, traceClass);
    enabled = @TR.f_Lean_checkTraceOption_go_8ac1958e84(_runtime, cold[11], cold[2], optionName);
    if (HELP_bool(enabled)) {
      start = @M.f_Lean_stringToMessageData_1e55fa4f40(_runtime, LeanText("no theorems found for "));
      phase = @M.f_Lean_stringToMessageData_1e55fa4f40(_runtime, _tag_3_input);
      message = LeanCtor(LeanTag.MessageData_compose, Array[start, phase]);
      suffix = @M.f_Lean_stringToMessageData_1e55fa4f40(_runtime, LeanText("-rewriting "));
      !message = LeanCtor(LeanTag.MessageData_compose, Array[message, suffix]);
      renderedExpr = @M.f_Lean_MessageData_ofExpr_19c924d486(_runtime, expression);
      !message = LeanCtor(LeanTag.MessageData_compose, Array[message, renderedExpr]);
      traced = f_synthesizeArgs_synthesizeInstance_spec_0_62b88d54be(_runtime, traceClass, message, _a_8_input, _a_9_input, _a_10_input, _a_11_input, world);
      if (!HELP_ok(traced)) return traced;
      !world = leanField(traced, 1)
    }
  };
  LeanCtor(LeanTag.EST_Out_ok, Array[LeanCtor(LeanTag.Option_none, Array[]), world])''')

write('f_Simp_tryTheoremCore_go_eda42a565c','theorem','''  lhs = _lhs_0_input;
  arguments = _xs_1_input;
  binderInfos = _bis_2_input;
  value = _val_3_input;
  type = _type_4_input;
  theorem = _thm_5_input;
  expression = _e_6_input;
  methods = _a_7_input;
  simpContext = _a_8_input;
  simpState = _a_9_input;
  metaContext = _a_10_input;
  metaState = _a_11_input;
  coreContext = _a_12_input;
  coreState = _a_13_input;
  world = _a_1_14_input;
  // The initial trace class is constructed even when hasTrace is false.
  core = HELP_fields(coreContext, LeanTag.Core_Context_mk, 8);
  cold = HELP_fields(core[0], LeanTag.Core_Context_Cold_mk, 12);
  _validatedTraceOptions = HELP_fields(cold[2], LeanTag.Private_Lean_Data_Options_0_Lean_Options_mk, 2);
  debugClass = @P.f_Lean_Name_mkStr4_cfa3e36682(_runtime, LeanText("Debug"), LeanText("Meta"), LeanText("Tactic"), LeanText("simp"));
  initialTrace = HELP_trace(_runtime, "trying", debugClass, theorem, expression, lhs, type, expression, metaContext, metaState, coreContext, coreState, world);
  if (!HELP_ok(initialTrace)) return initialTrace;
  !world = leanField(initialTrace, 1);
  simp = HELP_fields(simpContext, LeanTag.Private_Lean_Meta_Tactic_Simp_Types_0_Lean_Meta_Simp_Context_mk, 13);
  unificationConfig = HELP_fields(simp[4], LeanTag.Private_Lean_Meta_Basic_0_Lean_Meta_ConfigWithKey_mk, 2)[0];
  meta = HELP_fields(metaContext, LeanTag.Meta_Context_mk, 11);
  configKey = @MB.f_Meta_Config_toKey_993126c67a(_runtime, unificationConfig);
  keyedConfig = LeanCtor(LeanTag.Private_Lean_Meta_Basic_0_Lean_Meta_ConfigWithKey_mk, Array[unificationConfig, configKey]);
  unificationContext = LeanCtor(LeanTag.Meta_Context_mk, Array[keyedConfig, meta[1], meta[2], meta[3], meta[4], meta[5], meta[6], meta[7], meta[8], meta[9], meta[10]]);
  unified = @MB.f_Lean_Meta_isExprDefEq_fd77ff0762(_runtime, lhs, expression, unificationContext, metaState, coreContext, coreState, world);
  if (!HELP_ok(unified)) return unified;
  !world = leanField(unified, 1);
  if (!HELP_bool(leanField(unified, 0))) {
    // A metavariable lhs suppresses only the unification-failure trace.
    if (!HELP_bool(@E.f_Lean_Expr_isMVar_9292d40ab6(_runtime, lhs))) {
      unifyTrace = HELP_trace(_runtime, "unify", debugClass, theorem, expression, lhs, type, expression, metaContext, metaState, coreContext, coreState, world);
      if (!HELP_ok(unifyTrace)) return unifyTrace;
      !world = leanField(unifyTrace, 1)
    };
    return HELP_none(world)
  };
  theoremFields = HELP_fields(theorem, LeanTag.Meta_SimpTheorem_mk, 9);
  permutation = theoremFields[5];
  origin = theoremFields[6];
  cacheable = LeanCtor(LeanTag.Bool_true, Array[]);
  // Synthesis includes discharge and instance synthesis; it must not be replaced by a shape test.
  synthesized = f_Meta_Simp_synthesizeArgs_90b51d5f19(_runtime, origin, binderInfos, arguments, methods, simpContext, simpState, metaContext, metaState, coreContext, coreState, world);
  if (!HELP_ok(synthesized)) return synthesized;
  !world = leanField(synthesized, 1);
  if (!HELP_bool(leanField(synthesized, 0))) return HELP_none(world);
  implicitPolicy = HELP_infallible(f_Meta_Simp_useImplicitDefEqProof_d14778fc57(_runtime, theorem, simpContext, coreContext, world));
  !world = implicitPolicy[1];
  proof = LeanCtor(LeanTag.Option_none, Array[]);
  if (!HELP_bool(implicitPolicy[0])) {
    applied = @E.f_Lean_mkAppN_941bfcfa8e(_runtime, value, arguments);
    instantiated = HELP_infallible(f_Simp_synthesizeArgs_spec_0_3671ba3076(_runtime, applied, metaState, world));
    !world = instantiated[1];
    hasAssignable = L4_Lean_Meta_HasAssignableMVar.f_Lean_Meta_hasAssignableMVar_ec9fff8315(_runtime, instantiated[0], metaContext, metaState, coreContext, coreState, world);
    if (!HELP_ok(hasAssignable)) return hasAssignable;
    !world = leanField(hasAssignable, 1);
    if (HELP_bool(leanField(hasAssignable, 0))) {
      unassignedTrace = HELP_trace(_runtime, "unassigned", debugClass, theorem, expression, lhs, type, expression, metaContext, metaState, coreContext, coreState, world);
      if (!HELP_ok(unassignedTrace)) return unassignedTrace;
      return HELP_none(leanField(unassignedTrace, 1))
    };
    !proof = LeanCtor(LeanTag.Option_some, Array[instantiated[0]])
  };
  instantiatedType = HELP_infallible(f_Simp_synthesizeArgs_spec_0_3671ba3076(_runtime, type, metaState, world));
  rhs = @E.f_Lean_Expr_appArg_751e777947(_runtime, instantiatedType[0]);
  instantiatedExpr = HELP_infallible(f_Simp_synthesizeArgs_spec_0_3671ba3076(_runtime, expression, metaState, instantiatedType[1]));
  !world = instantiatedExpr[1];
  same = @E.f_Lean_Expr_eqv_4957d9ddda(_runtime, instantiatedExpr[0], rhs);
  if (HELP_bool(same)) {
    unchangedTrace = HELP_trace(_runtime, "unchanged", debugClass, theorem, expression, lhs, type, rhs, metaContext, metaState, coreContext, coreState, world);
    if (!HELP_ok(unchangedTrace)) return unchangedTrace;
    return HELP_none(leanField(unchangedTrace, 1))
  };
  if (HELP_bool(permutation)) {
    order = L4_Lean_Meta_ACLt.f_Lean_Meta_acLt_abc2aa8553(_runtime, rhs, expression, LeanCtor(LeanTag.Meta_ACLt_ReduceMode_reduceSimpleOnly, Array[]), metaContext, metaState, coreContext, coreState, world);
    if (!HELP_ok(order)) return order;
    !world = leanField(order, 1);
    if (!HELP_bool(leanField(order, 0))) {
      permutationTrace = HELP_trace(_runtime, "permutation", debugClass, theorem, expression, lhs, type, rhs, metaContext, metaState, coreContext, coreState, world);
      if (!HELP_ok(permutationTrace)) return permutationTrace;
      return HELP_none(leanField(permutationTrace, 1))
    }
  };
  rewriteTrace = HELP_trace(_runtime, "rewrite", debugClass, theorem, expression, lhs, type, rhs, metaContext, metaState, coreContext, coreState, world);
  if (!HELP_ok(rewriteTrace)) return rewriteTrace;
  !world = leanField(rewriteTrace, 1);
  if (HELP_bool(L4_Lean_Meta_BinderNameHint.f_Lean_Expr_hasBinderNameHint_986b3d1a1e(_runtime, type))) {
    resolved = L4_Lean_Meta_BinderNameHint.f_Lean_Expr_resolveBinderNameHint_1afc5dc5e3(_runtime, rhs, coreContext, coreState, world);
    if (!HELP_ok(resolved)) return resolved;
    !rhs = leanField(resolved, 0);
    !world = leanField(resolved, 1)
  };
  recorded = @T.f_Meta_Simp_recordSimpTheorem_aa5c92accb(_runtime, origin, simpState, coreContext, coreState, world);
  if (!HELP_ok(recorded)) return recorded;
  result = LeanCtor(LeanTag.Meta_Simp_Result_mk, Array[rhs, proof, cacheable]);
  LeanCtor(LeanTag.EST_Out_ok, Array[LeanCtor(LeanTag.Option_some, Array[result]), leanField(recorded, 1)])''',r'''fun HELP_none(world: LeanValue): LeanValue {
  LeanCtor(LeanTag.EST_Out_ok, Array[LeanCtor(LeanTag.Option_none, Array[]), world])
}

fun HELP_infallible(output: LeanValue): Array<LeanValue> {
  if (!HELP_ok(output)) return leanFail("unreachable: _private.Lean.Meta.Tactic.Simp.Rewrite.0.Lean.Meta.Simp.tryTheoremCore.go");
  Array[leanField(output, 0), leanField(output, 1)]
}

fun HELP_text(runtime: mutable LeanExecution, text: String): LeanValue {
  @M.f_Lean_stringToMessageData_1e55fa4f40(runtime, LeanText(text))
}

fun HELP_compose(left: LeanValue, right: LeanValue): LeanValue {
  LeanCtor(LeanTag.MessageData_compose, Array[left, right])
}

// Each call corresponds to one old trace branch. MessageData remains left-associated;
// theorem rendering is deferred until both the global and named trace gates pass.
fun HELP_trace(
  runtime: mutable LeanExecution, reason: String, debugClass: LeanValue,
  theorem: LeanValue, expression: LeanValue, lhs: LeanValue, type: LeanValue,
  rhs: LeanValue, metaContext: LeanValue, metaState: LeanValue,
  coreContext: LeanValue, coreState: LeanValue, world: LeanValue,
): LeanValue {
  core = HELP_fields(coreContext, LeanTag.Core_Context_mk, 8);
  cold = HELP_fields(core[0], LeanTag.Core_Context_Cold_mk, 12);
  options = HELP_fields(cold[2], LeanTag.Private_Lean_Data_Options_0_Lean_Options_mk, 2);
  if (!HELP_bool(options[1])) return LeanCtor(LeanTag.EST_Out_ok, Array[LeanCtor(LeanTag.PUnit_unit, Array[]), world]);
  traceClass = debugClass;
  if (reason != "trying" && reason != "unchanged") {
    suffix = if (reason == "unify") "unify" else "rewrite";
    !traceClass = @P.f_Lean_Name_mkStr4_cfa3e36682(runtime, LeanText("Meta"), LeanText("Tactic"), LeanText("simp"), LeanText(suffix))
  };
  tracePrefix = @P.f_Lean_Name_mkStr1_4962bb4b4e(runtime, LeanText("trace"));
  optionName = @P.f_Lean_Name_append_54ec01d162(runtime, tracePrefix, traceClass);
  enabled = @TR.f_Lean_checkTraceOption_go_8ac1958e84(runtime, cold[11], cold[2], optionName);
  if (!HELP_bool(enabled)) return LeanCtor(LeanTag.EST_Out_ok, Array[LeanCtor(LeanTag.PUnit_unit, Array[]), world]);
  rendered = HELP_infallible(f_tryTheoremCore_go_spec_0_1ba57450a8(runtime, theorem, world));
  message = rendered[0];
  reason match {
  | "trying" ->
    tryingPrefix = HELP_text(runtime, "trying ");
    !message = HELP_compose(tryingPrefix, message);
    !message = HELP_compose(message, HELP_text(runtime, " to rewrite"));
    !message = HELP_compose(message, @M.f_Lean_indentExpr_f484b447e1(runtime, expression))
  | "unify" ->
    !message = HELP_compose(message, HELP_text(runtime, ", failed to unify"));
    !message = HELP_compose(message, @M.f_Lean_indentExpr_f484b447e1(runtime, lhs));
    !message = HELP_compose(message, HELP_text(runtime, "\nwith"));
    !message = HELP_compose(message, @M.f_Lean_indentExpr_f484b447e1(runtime, expression))
  | "unassigned" ->
    !message = HELP_compose(message, HELP_text(runtime, ", has unassigned metavariables after unification"))
  | "unchanged" ->
    unchangedPrefix = HELP_text(runtime, "Not applying ");
    !message = HELP_compose(unchangedPrefix, message);
    !message = HELP_compose(message, HELP_text(runtime, " with type"));
    !message = HELP_compose(message, @M.f_Lean_indentExpr_f484b447e1(runtime, type));
    !message = HELP_compose(message, HELP_text(runtime, "\nto"));
    !message = HELP_compose(message, @M.f_Lean_indentExpr_f484b447e1(runtime, expression));
    !message = HELP_compose(message, HELP_text(runtime, "\nas the result is structurally equal to the original expression"))
  | "permutation" ->
    !message = HELP_compose(message, HELP_text(runtime, ", perm rejected "));
    !message = HELP_compose(message, @M.f_Lean_MessageData_ofExpr_19c924d486(runtime, expression));
    !message = HELP_compose(message, HELP_text(runtime, " ==> "));
    !message = HELP_compose(message, @M.f_Lean_MessageData_ofExpr_19c924d486(runtime, rhs))
  | "rewrite" ->
    !message = HELP_compose(message, HELP_text(runtime, ":"));
    !message = HELP_compose(message, @M.f_Lean_indentExpr_f484b447e1(runtime, expression));
    !message = HELP_compose(message, HELP_text(runtime, "\n==>"));
    !message = HELP_compose(message, @M.f_Lean_indentExpr_f484b447e1(runtime, rhs))
  | _ -> return leanFail("unknown rewrite-wave trace reason")
  };
  f_synthesizeArgs_synthesizeInstance_spec_0_62b88d54be(runtime, traceClass, message, metaContext, metaState, coreContext, coreState, rendered[1])
}

''')

write('f_rewrite_rewriteUsingIndex_spec_3_266ff70323','candidates','''  expression = _e_0_input;
  rflOnly = _rflOnly_1_input;
  erased = _erased_2_input;
  backward = _x_1_3_input;
  candidates = _as_4_input;
  size = _sz_5_input;
  index = _i_6_input;
  accumulator = _b_7_input;
  methods = _y_2_8_input;
  simpContext = _y_3_9_input;
  simpState = _y_4_10_input;
  metaContext = _y_5_11_input;
  metaState = _y_6_12_input;
  coreContext = _y_7_13_input;
  coreState = _y_8_14_input;
  world = _y_9_15_input;
  loop {
    inBounds = @U.f_USize_decLt_ed49caa57a(_runtime, index, size);
    if (!HELP_bool(inBounds)) return LeanCtor(LeanTag.EST_Out_ok, Array[accumulator, world]);
    entry = @A.f_Array_uget_c7e0af4dc5(_runtime, LeanErased(), candidates, index, LeanErased());
    candidate = HELP_fields(entry, LeanTag.Prod_mk, 2);
    theorem = candidate[0];
    extraArguments = candidate[1];
    none = LeanCtor(LeanTag.Option_none, Array[]);
    unit = LeanCtor(LeanTag.PUnit_unit, Array[]);
    emptyAccumulator = LeanCtor(LeanTag.Prod_mk, Array[none, unit]);
    checked = @C.f_Lean_Core_checkSystem_ccc29ea7a7(_runtime, LeanText("simp"), coreContext, coreState, world);
    if (!HELP_ok(checked)) return checked;
    !world = leanField(checked, 1);
    isErased = f_Simp_rewrite_inErasedSet_6828aed7bc(_runtime, erased, theorem);
    eligible = false;
    if (!HELP_bool(isErased)) {
      if (!HELP_bool(rflOnly)) {
        !eligible = true
      } else {
        fields = HELP_fields(theorem, LeanTag.Meta_SimpTheorem_mk, 9);
        if (HELP_bool(fields[7])) {
          !eligible = true
        } else {
          // backwardRfl is not inspected when useBackward is false.
          rejection = isErased;
          if (HELP_bool(backward)) {
            if (HELP_bool(fields[8])) { !eligible = true }
            else { !rejection = fields[8] }
          };
          if (!eligible) {
            diagnosed = HELP_checkRejectedRfl(_runtime, fields[2], rejection, methods, simpContext, simpState, metaContext, metaState, coreContext, coreState, world);
            if (!HELP_ok(diagnosed)) return diagnosed;
            !world = leanField(diagnosed, 1)
          }
        }
      }
    };
    if (eligible) {
      // Keep the depth/rollback wrapper, not just tryTheoremCore.go.
      attempted = f_Meta_Simp_tryTheoremWithExtraArgs_be8330f005(_runtime, expression, theorem, extraArguments, methods, simpContext, simpState, metaContext, metaState, coreContext, coreState, world);
      if (!HELP_ok(attempted)) return attempted;
      optionalResult = leanField(attempted, 0);
      !world = leanField(attempted, 1);
      // The original intentionally treats any non-some tag as a failed attempt.
      leanTag(optionalResult) match {
      | LeanTag.Option_some ->
        result = leanField(optionalResult, 0);
        traced = HELP_traceSuccess(_runtime, expression, theorem, rflOnly, result, metaContext, metaState, coreContext, coreState, world);
        if (!HELP_ok(traced)) return traced;
        found = LeanCtor(LeanTag.Option_some, Array[optionalResult]);
        returned = LeanCtor(LeanTag.Prod_mk, Array[found, unit]);
        return LeanCtor(LeanTag.EST_Out_ok, Array[returned, leanField(traced, 1)])
      | _ -> void
      }
    };
    !accumulator = emptyAccumulator;
    !index = @U.f_USize_add_559d423481(_runtime, index, LeanWord("usize", 1))
  }''','''fun HELP_unit(world: LeanValue): LeanValue {
  LeanCtor(LeanTag.EST_Out_ok, Array[LeanCtor(LeanTag.PUnit_unit, Array[]), world])
}

fun HELP_text(runtime: mutable LeanExecution, text: String): LeanValue {
  @M.f_Lean_stringToMessageData_1e55fa4f40(runtime, LeanText(text))
}

fun HELP_compose(left: LeanValue, right: LeanValue): LeanValue {
  LeanCtor(LeanTag.MessageData_compose, Array[left, right])
}

fun HELP_enabled(runtime: mutable LeanExecution, traceClass: LeanValue, options: LeanValue, inherited: LeanValue): Bool {
  prefix = @P.f_Lean_Name_mkStr1_4962bb4b4e(runtime, LeanText("trace"));
  optionName = @P.f_Lean_Name_append_54ec01d162(runtime, prefix, traceClass);
  HELP_bool(@TR.f_Lean_checkTraceOption_go_8ac1958e84(runtime, inherited, options, optionName))
}

fun HELP_traceSuccess(
  runtime: mutable LeanExecution, expression: LeanValue, theorem: LeanValue,
  rflOnly: LeanValue, result: LeanValue,
  metaContext: LeanValue, metaState: LeanValue, coreContext: LeanValue,
  coreState: LeanValue, world: LeanValue,
): LeanValue {
  core = HELP_fields(coreContext, LeanTag.Core_Context_mk, 8);
  cold = HELP_fields(core[0], LeanTag.Core_Context_Cold_mk, 12);
  options = HELP_fields(cold[2], LeanTag.Private_Lean_Data_Options_0_Lean_Options_mk, 2);
  if (HELP_bool(options[1])) {
    debugTraceClass = @P.f_Lean_Name_mkStr4_cfa3e36682(runtime, LeanText("Debug"), LeanText("Meta"), LeanText("Tactic"), LeanText("simp"));
    if (HELP_enabled(runtime, debugTraceClass, cold[2], cold[11])) {
      resultFields = HELP_fields(result, LeanTag.Meta_Simp_Result_mk, 3);
      debugMessage = HELP_text(runtime, "rewrite result ");
      !debugMessage = HELP_compose(debugMessage, @M.f_Lean_MessageData_ofExpr_19c924d486(runtime, expression));
      !debugMessage = HELP_compose(debugMessage, HELP_text(runtime, " => "));
      !debugMessage = HELP_compose(debugMessage, @M.f_Lean_MessageData_ofExpr_19c924d486(runtime, resultFields[0]));
      traced = f_synthesizeArgs_synthesizeInstance_spec_0_62b88d54be(runtime, debugTraceClass, debugMessage, metaContext, metaState, coreContext, coreState, world);
      if (!HELP_ok(traced)) return traced;
      !world = leanField(traced, 1)
    }
  };
  if (!HELP_bool(rflOnly)) return HELP_unit(world);
  theoremFields = HELP_fields(theorem, LeanTag.Meta_SimpTheorem_mk, 9);
  if (HELP_bool(theoremFields[7])) return HELP_unit(world);
  if (!HELP_bool(theoremFields[8])) return HELP_unit(world);
  // The backward-defeq trace is gated independently, after the debug-result trace.
  backwardCore = HELP_fields(coreContext, LeanTag.Core_Context_mk, 8);
  backwardCold = HELP_fields(backwardCore[0], LeanTag.Core_Context_Cold_mk, 12);
  backwardOptions = HELP_fields(backwardCold[2], LeanTag.Private_Lean_Data_Options_0_Lean_Options_mk, 2);
  if (!HELP_bool(backwardOptions[1])) return HELP_unit(world);
  backwardTraceClass = @P.f_Lean_Name_mkStr4_cfa3e36682(runtime, LeanText("Meta"), LeanText("Tactic"), LeanText("simp"), LeanText("backwardDefEq"));
  if (!HELP_enabled(runtime, backwardTraceClass, backwardCold[2], backwardCold[11])) return HELP_unit(world);
  origin = f_Simp_discharge_spec_1_731cb7245e(runtime, theoremFields[6], world);
  if (!HELP_ok(origin)) return origin;
  backwardMessage = HELP_text(runtime, "used `[backward_defeq]` theorem ");
  !backwardMessage = HELP_compose(backwardMessage, leanField(origin, 0));
  !backwardMessage = HELP_compose(backwardMessage, HELP_text(runtime, " to rewrite"));
  !backwardMessage = HELP_compose(backwardMessage, @M.f_Lean_indentExpr_f484b447e1(runtime, expression));
  f_synthesizeArgs_synthesizeInstance_spec_0_62b88d54be(runtime, backwardTraceClass, backwardMessage, metaContext, metaState, coreContext, coreState, leanField(origin, 1))
}

// Debug-only validation of a theorem rejected by the rfl eligibility gate.
// Diagnostics changes intentionally invalidate the core cache, exactly as before.
fun HELP_checkRejectedRfl(
  runtime: mutable LeanExecution, proof: LeanValue, rejected: LeanValue,
  methods: LeanValue, simpContext: LeanValue, simpState: LeanValue,
  metaContext: LeanValue, metaState: LeanValue, coreContext: LeanValue,
  coreState: LeanValue, world: LeanValue,
): LeanValue {
  checkedOptions = @C.f_Core_instMonadOptionsCoreM_checkedOptions_735ae7dbd5(runtime, coreContext);
  checkOption = leanReadInitializer(runtime, "Lean.Meta.debug.tactic.simp.checkDefEqAttr");
  check = f_Simp_discharge_spec_3_b456dc217a(runtime, checkedOptions, checkOption);
  if (!HELP_bool(check)) return HELP_unit(world);
  backwardOption = leanReadInitializer(runtime, "Lean.Meta.backward.dsimp.useDefEqAttr");
  useDefEq = f_Simp_discharge_spec_3_b456dc217a(runtime, checkedOptions, backwardOption);
  if (!HELP_bool(useDefEq)) return HELP_unit(world);
  core = HELP_fields(coreContext, LeanTag.Core_Context_mk, 8);
  cold = HELP_fields(core[0], LeanTag.Core_Context_Cold_mk, 12);
  options = if (HELP_bool(core[7])) {
    @C.f_Core_instMonadWithOptionsCoreM_reportViolation_9ed8088e54(runtime, cold[2])
  } else {
    f_rewrite_rewriteUsingIndex_spec_2_9139d84220(runtime, cold[2], backwardOption, rejected)
  };
  flags = @C.f_Lean_OptionFlags_ofOptions_967f79be9b(runtime, options);
  gotState = @ST.f_Prim_Ref_get_ab668afddb(runtime, LeanErased(), LeanErased(), coreState, world);
  stateAndWorld = HELP_fields(gotState, LeanTag.ST_Out_mk, 2);
  state = HELP_fields(stateAndWorld[0], LeanTag.Core_State_mk, 10);
  diagnostics = L4_Lean_Environment.f_Lean_Kernel_isDiagnosticsEnabled_10ba9363d2(runtime, state[0]);
  diagnosticBits = L4_Init_Data_UInt_Basic.f_UInt16_land_01cb154555(runtime, flags, LeanWord("uint16", 512));
  noDiagnostics = @P.f_UInt16_decEq_ea67bbfbf0(runtime, diagnosticBits, LeanWord("uint16", 0));
  desired = if (HELP_bool(noDiagnostics)) rejected else useDefEq;
  desiredBool = HELP_bool(desired);
  currentBool = HELP_bool(diagnostics);
  !world = stateAndWorld[1];
  if (desiredBool != currentBool) {
    taken = @ST.f_Prim_Ref_take_7505bf778c(runtime, LeanErased(), LeanErased(), coreState, world);
    takenFields = HELP_fields(taken, LeanTag.ST_Out_mk, 2);
    old = HELP_fields(takenFields[0], LeanTag.Core_State_mk, 10);
    environment = L4_Lean_Environment.f_Lean_Kernel_enableDiag_e3bba134be(runtime, old[0], desired);
    entries = L4_Lean_Data_PersistentHashMap.f_Lean_PersistentHashMap_mkEmptyEntriesArray_f2d99b9b8c(runtime, LeanErased());
    node = LeanCtor(LeanTag.PersistentHashMap_Node_entries, Array[entries]);
    cache = LeanCtor(LeanTag.Core_Cache_mk, Array[node, node]);
    updated = LeanCtor(LeanTag.Core_State_mk, Array[environment, old[1], old[2], old[3], old[4], cache, old[6], old[7], old[8], old[9]]);
    put = @ST.f_Prim_Ref_put_334aaf25b1(runtime, LeanErased(), LeanErased(), coreState, updated, takenFields[1]);
    putFields = HELP_fields(put, LeanTag.ST_Out_mk, 2);
    !world = putFields[1]
  };
  // Rebuild local Core context with the new options, flags and maxRecDepth.
  localCore = HELP_fields(coreContext, LeanTag.Core_Context_mk, 8);
  localCold = HELP_fields(localCore[0], LeanTag.Core_Context_Cold_mk, 12);
  maxDepthOption = leanReadInitializer(runtime, "Lean.maxRecDepth");
  maxDepth = f_discharge_spec_4_spec_7_a8c33d81c1(runtime, options, maxDepthOption);
  newCold = LeanCtor(LeanTag.Core_Context_Cold_mk, Array[localCold[0], localCold[1], options, maxDepth, localCold[4], localCold[5], localCold[6], localCold[7], localCold[8], localCold[9], localCold[10], localCold[11]]);
  newCore = LeanCtor(LeanTag.Core_Context_mk, Array[newCold, localCore[1], localCore[2], flags, LeanErased(), localCore[5], localCore[6], localCore[7]]);
  isRfl = L4_Lean_Meta_Tactic_Simp_SimpTheorems.f_Lean_Meta_isRflProof_3dd1ef279b(runtime, proof, metaContext, metaState, newCore, coreState, world);
  if (!HELP_ok(isRfl)) return isRfl;
  !world = leanField(isRfl, 1);
  if (!HELP_bool(leanField(isRfl, 0))) return HELP_unit(world);
  message = HELP_text(runtime, "theorem ");
  !message = HELP_compose(message, @M.f_Lean_MessageData_ofExpr_19c924d486(runtime, proof));
  !message = HELP_compose(message, HELP_text(runtime, " is no longer rfl"));
  f_rewrite_rewriteUsingIndex_spec_1_a1a3bc080b(runtime, message, methods, simpContext, simpState, metaContext, metaState, coreContext, coreState, world)
}

''')
