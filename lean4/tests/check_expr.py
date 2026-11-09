#!/usr/bin/env python3
"""Compare ExprProbe output with the pinned native ExprReference output.

The first five groups have exact answers. The final native group gives exact
equality answers; Skip emits six budgeted runs. Exhaustion may depend on object
sharing, but every definite answer must match native Lean.
"""
import argparse
import json
from pathlib import Path


def groups(path):
    return [json.loads(line) for line in path.read_text().splitlines()
            if line.startswith('[')]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('skip_output', type=Path)
    parser.add_argument('native_output', type=Path)
    args = parser.parse_args()
    actual, expected = groups(args.skip_output), groups(args.native_output)
    assert len(actual) == len(expected) == 6, 'Expected six expression groups'
    for index, (left, right) in enumerate(zip(actual[:5], expected[:5])):
        assert left == right, f'Expression group {index} differs from native Lean'
    assert len(actual[5]) == 6, 'Expected six traversal budgets'
    definite = 0
    unknowns = []
    for fuel, rows in zip([0, 1, 2, 4, 16, 4096], actual[5]):
        assert len(rows) == len(expected[5]), f'Wrong comparison count at fuel {fuel}'
        unknown = 0
        for index, (answers, wanted) in enumerate(zip(rows, expected[5])):
            assert len(answers) == len(wanted) == 2
            for answer, truth in zip(answers, wanted):
                assert answer in (0, 1, 2), f'Invalid Lean LBool ordinal: {answer}'
                if answer == 2:
                    unknown += 1
                else:
                    assert bool(answer) == truth, f'Wrong answer at fuel {fuel}, pair {index}'
                    definite += 1
        unknowns.append(unknown)
    assert unknowns[-1] == 0, 'Largest budget must settle every comparison'
    print(json.dumps({'exactGroupsMatched': 5,
                      'exactGroupLengths': [len(g) for g in actual[:5]],
                      'definiteBudgetAnswersMatched': definite,
                      'unknownsPerBudget': unknowns}))


if __name__ == '__main__':
    main()
