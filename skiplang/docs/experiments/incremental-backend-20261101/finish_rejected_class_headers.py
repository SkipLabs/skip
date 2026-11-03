"""Preserve the early rejection and retire its cache before the next gate."""
import json
from pathlib import Path
import shutil
from statistics import median
import subprocess

root = Path('/tmp/skip-incremental-next')
repo = Path('/home/julienv/skip')
evidence = repo/'skiplang/docs/experiments/incremental-backend-20261101'
tools = repo/'skiplang/compiler/tools'
checkpoint = 'class-header-boundary-headers-literal-2'
result = dict(language=0, language_passed=True, control=0,
              headers='rejected_after_two_literal_edits', timing_matrix_complete=False,
              reason='Literal updates regress from 0.785 seconds to approximately 73 seconds; cold optimization adds 74 seconds.')

def run(script, *args):
    subprocess.run(['python3', str(root/script), *args], check=True)

def phases(policy, suffix):
    path = root/'runs'/f'class-header-boundary-{policy}-{suffix}'
    assert json.loads((path/'replay.json').read_text())['validation'] == 'passed'
    return json.loads((path/'phases.json').read_text())

try:
    assert json.loads((root/'runs'/checkpoint/'replay.json').read_text())['validation'] == 'passed'
    subprocess.run(['python3', '-m', 'unittest', '-q', 'test_llvm_artifact_diff',
                    'test_incremental_profile'], cwd=tools, check=True)
    subprocess.run(['python3', str(tools/'incremental_profile.py'), 'run', '--root', str(root),
        '--label', 'class-header-boundary-headers-full-census', '--timeout', '900', '--',
        'python3', str(root/'census_class_header_full.py'), 'headers', '--checkpoint', checkpoint], check=True)
    run('export_class_header_matrix.py', 'headers')
    run('retire_class_header_cache.py', 'headers', '--checkpoint', checkpoint)
    groups = {
        'control_cold': [phases('control', 'cold')],
        'headers_cold': [phases('headers', 'cold')],
        'control_literal': [phases('control', f'literal-{i}') for i in range(1,4)],
        'headers_literal': [phases('headers', f'literal-{i}') for i in range(1,3)],
    }
    rows = sorted(set().union(*(set(s['exclusive_seconds']) for samples in groups.values() for s in samples)))
    phase_table = {name:{key:median(s['exclusive_seconds'].get(name,0) for s in samples)
                        for key,samples in groups.items()} for name in rows}
    report = dict(result, host_identity=json.loads((root/'host-class-headers/identity.json').read_text()),
        samples={key:[s['seconds'] for s in samples] for key,samples in groups.items()},
        exclusive_phase_seconds=phase_table,
        native_work={key:[s['clang_object_work'] for s in samples] for key,samples in groups.items()},
        source_fallback_correction='BackendProgram.sk now gates headers off for inline/IPA/debug; not present in this frozen host. All these timed cases have inline and IPA disabled.',
        limits='Candidate stopped early after two validated literal edits. Other candidate cases and branch directions are unmeasured. Control phase medians use three literal edits; candidate uses two. Census checkpoints differ: control is after its second branch return, candidate after its second literal edit; do not infer a memory-policy improvement from that pair.',
        final_candidate_checkpoint=checkpoint)
    (evidence/'class-header-boundary-rejected-screen.json').write_text(json.dumps(report,indent=2)+'\n')
    lines=['# Keyed class-header screen: rejected', '',
        'The candidate is rejected in its current form. All recorded outputs validate, but literal updates regress from a 0.785-second control median to about 73 seconds. Cold optimization adds approximately 74 seconds. The candidate was stopped after its second literal edit; its other edit categories and branch cases were not run.', '',
        'Both policies use one frozen optimized host, fresh independent caches and matching development/native flags. Compiler phase/memory hooks are enabled. Inlining and IPA are disabled. The later inline/IPA/debug fallback correction is absent from this binary and would not change these cases.', '',
        '| Measurement | Control | Headers |', '| --- | ---: | ---: |']
    for label,a,b in [('Cold','control_cold','headers_cold'),('Literal median','control_literal','headers_literal')]:
        lines.append(f'| {label} | {median(report["samples"][a]):.6f} s | {median(report["samples"][b]):.6f} s |')
    lines += ['', 'Cold cases have one sample each; literal cases have three control and two candidate samples.', '',
        '| Exclusive phase, seconds | Control cold | Headers cold | Control literal median | Headers literal median |',
        '| --- | ---: | ---: | ---: | ---: |']
    for name,values in phase_table.items():
        if max(values.values()) < .0005: continue
        lines.append('| '+name+' | '+' | '.join(f'{values[key]:.6f}' for key in groups)+' |')
    lines += ['', 'Clang is accounted by the union of its object-compilation intervals. Summed command durations and maximum concurrency are preserved in the JSON, separately from final linking. Per-phase medians need not sum to the median total.', '',
        'The complete control includes branch updates of 68.291782/71.322259 seconds. Its post-timing LLVM diagnostic finds all 265 modules changed on the historical move and all 265 byte-identical to the original baseline on return. Bounded examples identify declaration parameter-name and debug-label churn; they do not quantify how much of the total update is avoidable.', '',
        report['limits'], '', 'Both replay caches were exported, verified and removed.']
    (evidence/'class-header-boundary-rejected-screen.md').write_text('\n'.join(lines)+'\n')
    for name in ['finish_rejected_class_headers.py','census_class_header_full.py','retire_class_header_cache.py']:
        shutil.copy2(root/name,evidence/name)
    result['evidence_exported'] = True
    result['caches_retired'] = True
    result['complete'] = True  # The bounded experiment is finished; the candidate is rejected.
finally:
    (root/'class-headers-integration-and-measure-result.json').write_text(json.dumps(result,indent=2)+'\n')
