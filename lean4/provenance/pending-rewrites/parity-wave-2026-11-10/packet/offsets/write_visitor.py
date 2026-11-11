"""Emit repetitive direct dispatch arms, not translated frames. Lane-local authoring utility."""
from pathlib import Path
root = Path(__file__).parent
header = (root/'originals/f_Meta_evalNat_visit_be1fb46d98.sk').read_text().split('  // Frame slots:')[0]
body = '''  metaContext = _a_1_input;
  metaState = _a_2_input;
  coreContext = _a_3_input;
  coreState = _a_4_input;
  instantiated = L4_Lean_Meta_Basic.f_Lean_Meta_instantiateMVarsIfMVarApp_05888c8640(
    _runtime, _e_0_input, metaState, _a_1_5_input,
  );
  if (!f_offsets_wave_isOk(instantiated)) return instantiated;
  world = leanField(instantiated, 1);
  expression = L4_Lean_Expr.f_Lean_Expr_cleanupAnnotations_72ebbfac43(
    _runtime, leanField(instantiated, 0),
  );
  // Do not restart evalNat on the instantiated expression. A literal here is none.
  if (!f_offsets_wave_isApp(_runtime, expression)) return f_offsets_wave_none(world);
  lastArgument = f_offsets_wave_visitArgument(expression);
  unaryHead = L4_Lean_Expr.f_Lean_Expr_appFnCleanup_f18bdcb337(_runtime, expression);
  if (f_offsets_wave_isConst(_runtime, unaryHead, "Nat", "succ")) {
    argumentResult = f_Lean_Meta_evalNat_6bfbb6a56e(
      _runtime, lastArgument, metaContext, metaState, coreContext, coreState, world,
    );
    if (!f_offsets_wave_isOk(argumentResult)) return argumentResult;
    argument = leanField(argumentResult, 0);
    if (!f_offsets_wave_hasValue(argument)) return argumentResult;
    successor = L4_Init_Prelude.f_Nat_add_86990f4822(
      _runtime, leanField(argument, 0), LeanNatLiterals.n1,
    );
    return f_offsets_wave_some(successor, leanField(argumentResult, 1))
  };

  if (!f_offsets_wave_isApp(_runtime, unaryHead)) return f_offsets_wave_none(world);
  leftOperand = f_offsets_wave_visitArgument(unaryHead);
  binaryHead = L4_Lean_Expr.f_Lean_Expr_appFnCleanup_f18bdcb337(_runtime, unaryHead);
  // Keep the original recognition order and peel only as far as needed.
'''
for operation in ['pow','mod','div','mul','sub','add']:
    body += f'''  if (f_offsets_wave_isConst(_runtime, binaryHead, "Nat", "{operation}")) {{
    return f_offsets_wave_evalBinary(
      _runtime, "{operation}", leftOperand, lastArgument,
      metaContext, metaState, coreContext, coreState, world,
    )
  }};
'''
body += '''
  if (!f_offsets_wave_isApp(_runtime, binaryHead)) return f_offsets_wave_none(world);
  ternaryHead = L4_Lean_Expr.f_Lean_Expr_appFnCleanup_f18bdcb337(_runtime, binaryHead);
  if (f_offsets_wave_isConst(_runtime, ternaryHead, "OfNat", "ofNat")) {
    instanceResult = L4_Lean_Meta_NatInstTesters.f_Meta_Structural_isInstOfNatNat_23d9437374(
      _runtime, lastArgument, metaState, world,
    );
    if (!f_offsets_wave_isOk(instanceResult)) return instanceResult;
    instanceWorld = leanField(instanceResult, 1);
    if (!f_offsets_wave_bool(leanField(instanceResult, 0))) {
      return f_offsets_wave_none(instanceWorld)
    };
    return f_Lean_Meta_evalNat_6bfbb6a56e(
      _runtime, leftOperand, metaContext, metaState, coreContext, coreState, instanceWorld,
    )
  };

  if (!f_offsets_wave_isApp(_runtime, ternaryHead)) return f_offsets_wave_none(world);
  instance = f_offsets_wave_visitArgument(binaryHead);
  homogeneousHead = L4_Lean_Expr.f_Lean_Expr_appFnCleanup_f18bdcb337(_runtime, ternaryHead);
'''
testers = {
'NatPow':'f_Meta_Structural_isInstNatPowNat_6cb013eaab',
'Pow':'f_Meta_Structural_isInstPowNat_7302fa0c56',
'Add':'f_Meta_Structural_isInstAddNat_8f83ce9384',
'Sub':'f_Meta_Structural_isInstSubNat_59407da28f',
'Mul':'f_Meta_Structural_isInstMulNat_9498d8de1c',
'Div':'f_Meta_Structural_isInstDivNat_13404ec095',
'Mod':'f_Meta_Structural_isInstModNat_1387614c56',
'HAdd':'f_Meta_Structural_isInstHAddNat_3409f9d906',
'HSub':'f_Meta_Structural_isInstHSubNat_646385a358',
'HMul':'f_Meta_Structural_isInstHMulNat_8f53efbd83',
'HDiv':'f_Meta_Structural_isInstHDivNat_99d54e0952',
'HMod':'f_Meta_Structural_isInstHModNat_13aff9b6f4',
'HPow':'f_Meta_Structural_isInstHPowNat_3d98525e0d',
}
def dispatch(head, namespace, member, operation):
    return f'''  if (f_offsets_wave_isConst(_runtime, {head}, "{namespace}", "{member}")) {{
    instanceResult = L4_Lean_Meta_NatInstTesters.{testers[namespace]}(
      _runtime, instance, metaState, world,
    );
    return f_offsets_wave_guardedBinary(
      _runtime, instanceResult, "{operation}", leftOperand, lastArgument,
      metaContext, metaState, coreContext, coreState,
    )
  }};
'''
for namespace, member in [('NatPow','pow'),('Mod','mod'),('Div','div'),('Mul','mul'),('Sub','sub'),('Add','add')]:
    body += dispatch('homogeneousHead', namespace, member, member)
body += '''
  if (!f_offsets_wave_isApp(_runtime, homogeneousHead)) return f_offsets_wave_none(world);
  powerHead = L4_Lean_Expr.f_Lean_Expr_appFnCleanup_f18bdcb337(_runtime, homogeneousHead);
'''
body += dispatch('powerHead','Pow','pow','pow')
body += '''
  if (!f_offsets_wave_isApp(_runtime, powerHead)) return f_offsets_wave_none(world);
  heterogeneousHead = L4_Lean_Expr.f_Lean_Expr_appFnCleanup_f18bdcb337(_runtime, powerHead);
'''
for namespace, member, operation in [('HPow','hPow','pow'),('HMod','hMod','mod'),('HDiv','hDiv','div'),('HMul','hMul','mul'),('HSub','hSub','sub'),('HAdd','hAdd','add')]:
    body += dispatch('heterogeneousHead', namespace, member, operation)
body += '''  f_offsets_wave_none(world)
}

fun f_offsets_wave_visitArgument(expression: LeanValue): LeanValue {
  leanTag(expression) match {
  | LeanTag.Expr_app__impl -> leanField(expression, 2)
  | _ -> leanFail("unreachable: _private.Lean.Meta.Offset.0.Lean.Meta.evalNat.visit")
  }
}

// A false instance test must stop before either operand is visited.
fun f_offsets_wave_guardedBinary(
  runtime: mutable LeanExecution,
  instanceResult: LeanValue,
  operation: String,
  left: LeanValue,
  right: LeanValue,
  metaContext: LeanValue,
  metaState: LeanValue,
  coreContext: LeanValue,
  coreState: LeanValue,
): LeanValue {
  if (!f_offsets_wave_isOk(instanceResult)) return instanceResult;
  world = leanField(instanceResult, 1);
  if (!f_offsets_wave_bool(leanField(instanceResult, 0))) {
    return f_offsets_wave_none(world)
  };
  f_offsets_wave_evalBinary(
    runtime, operation, left, right, metaContext, metaState, coreContext, coreState, world,
  )
}

// Nat operations remain arbitrary precision. Never infer a result from one operand.
fun f_offsets_wave_evalBinary(
  runtime: mutable LeanExecution,
  operation: String,
  left: LeanValue,
  right: LeanValue,
  metaContext: LeanValue,
  metaState: LeanValue,
  coreContext: LeanValue,
  coreState: LeanValue,
  world: LeanValue,
): LeanValue {
  if (operation == "pow") {
    // This existing helper evaluates/checks the exponent BEFORE evaluating the base,
    // including the original safe-exponent warning, errors, and option failure.
    return f_Meta_evalNat_evalPow_eeb69d1902(
      runtime, left, right, metaContext, metaState, coreContext, coreState, world,
    )
  };
  leftResult = f_Lean_Meta_evalNat_6bfbb6a56e(
    runtime, left, metaContext, metaState, coreContext, coreState, world,
  );
  if (!f_offsets_wave_isOk(leftResult)) return leftResult;
  leftOption = leanField(leftResult, 0);
  if (!f_offsets_wave_hasValue(leftOption)) return leftResult;
  rightResult = f_Lean_Meta_evalNat_6bfbb6a56e(
    runtime, right, metaContext, metaState, coreContext, coreState, leanField(leftResult, 1),
  );
  if (!f_offsets_wave_isOk(rightResult)) return rightResult;
  rightOption = leanField(rightResult, 0);
  if (!f_offsets_wave_hasValue(rightOption)) return rightResult;
  leftValue = leanField(leftOption, 0);
  rightValue = leanField(rightOption, 0);
  value = operation match {
'''
for operation, suffix in [('add','86990f4822'),('sub','8647441ee5'),('mul','8d6effc865'),('div','d9df18e4c4'),('mod','0b9c5755ae')]:
    body += f'  | "{operation}" -> L4_Init_Prelude.f_Nat_{operation}_{suffix}(runtime, leftValue, rightValue)\n'
body += '''  | _ -> leanFail("offsets wave: unsupported internal Nat operation")
  };
  f_offsets_wave_some(value, leanField(rightResult, 1))
}

module end;
'''
(root/'replacements/f_Meta_evalNat_visit_be1fb46d98.sk').write_text(header + body)
