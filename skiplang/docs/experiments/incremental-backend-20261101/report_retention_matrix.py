"""Reclassify completed raw spans and preserve a matched screening report."""
import argparse
import contextlib
import io
import json
from pathlib import Path
import sys

root = Path('/tmp/skip-incremental-next')
tools = Path('/home/julienv/skip/skiplang/compiler/tools')
evidence = Path('/home/julienv/skip/skiplang/docs/experiments/incremental-backend-20261101')
sys.path.insert(0, str(tools))
from incremental_profile import report_run

cases = ['cold', 'literal-1', 'control-flow-1', 'method-body-1', 'generic-1',
         'unused-1', 'history-historical-1', 'history-baseline-1']
result = dict(host_identity=json.loads((root/'host-retention/identity.json').read_text()),
              samples_per_case=1, diagnostic_fixes_excluded=['error snapshot ownership',
                  'native reference masks', 'support-module split'], modes={})
for mode in ['hierarchical', 'partitioned']:
    for directory in sorted((root/'runs').glob('retention-'+mode+'-*')):
        run = json.loads((directory/'run.json').read_text())
        assert 'end_ns' in run, directory
        if not (directory/'phases.json').exists():
            continue
        previous = json.loads((directory/'phases.json').read_text())
        if 'Specialization/class passes' in previous['exclusive_seconds']:
            (directory/'phases-before-classification.json').write_text(json.dumps(previous, indent=2)+'\n')
        with contextlib.redirect_stdout(io.StringIO()):
            report_run(argparse.Namespace(directory=directory))
    records = {}
    for case in cases:
        directory = root/'runs'/('retention-'+mode+'-'+case)
        phases = json.loads((directory/'phases.json').read_text())
        replay = json.loads((directory/'replay.json').read_text())
        assert phases['successful'] and replay['validation'] == 'passed', directory
        records[case] = {key: phases[key] for key in ['seconds', 'exclusive_seconds',
            'sampled_peak_summed_rss', 'class_group_work', 'persistent_checkpoints'] if key in phases}
        records[case]['replay'] = replay
        assert abs(sum(phases['exclusive_seconds'].values())-phases['seconds']) < 1e-6
    result['modes'][mode] = records
(evidence/'retention-matched-screen.json').write_text(json.dumps(result, indent=2)+'\n')
lines = ['# Matched class-partitioning screen after lazy-invalidation consumption fix', '',
    'One isolated optimized-host sample per case, fixed workload and toolchain. All generated compilers validate. ',
    'These are screening samples, not repeated medians or completed performance acceptance. The later error-ownership, runtime-mask and support-module changes are excluded.', '',
    '| Case | Unpartitioned seconds | Partitioned seconds |', '| --- | ---: | ---: |']
for case in cases:
    lines.append('| '+case+' | '+' | '.join(f"{result['modes'][mode][case]['seconds']:.6f}" for mode in result['modes'])+' |')
lines += ['', 'The pending-invalidation fix prevents repeated replay of the same class round, but partitioning still duplicates substantial construction and retained dependency work. It fails the full-workload gate and remains disabled.', '',
    '## Exclusive phase attribution', '',
    'Class construction, attempt-cache maintenance, request routing and coordination/publication are separate. The latter rows exclude their nested construction spans. Clang object compilation and final native linking are separate rows. Totals reconcile before rounding; shared and unattributed work remain explicit. This report refines the category names in the earlier hierarchical-only screen without changing raw timestamps.', '']
for mode, records in result['modes'].items():
    lines += ['### '+mode, '', '| Case | Peak sampled summed RSS GB | Constructed classes across executed attempts |', '| --- | ---: | ---: |']
    for case, r in records.items():
        lines.append(f"| {case} | {r['sampled_peak_summed_rss']/1e9:.3f} | {r.get('class_group_work',{}).get('constructed_classes', 'unpartitioned/not executed')} |")
    lines += ['', 'RSS samples occur once per second; very short compiler processes can finish between samples.', '']
    for group in [cases[:4], cases[4:]]:
        categories = sorted(set().union(*(records[c]['exclusive_seconds'] for c in group)))
        lines += ['| Phase | '+' | '.join(group)+' |', '| --- | '+' | '.join(['---:']*len(group))+' |']
        for category in categories:
            lines.append('| '+category+' | '+' | '.join(f"{records[c]['exclusive_seconds'].get(category,0):.6f}" for c in group)+' |')
        lines += ['| **Total** | '+' | '.join(f"**{records[c]['seconds']:.6f}**" for c in group)+' |', '']
(evidence/'retention-matched-screen.md').write_text('\n'.join(lines)+'\n')
print('All 16 completed cases validate and exclusive phase totals reconcile.')
