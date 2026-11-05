#!/usr/bin/env python3
"""Translate Lean's saved mono IR into a module-organized Skip project."""
import argparse
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent / 'tools'))
from lean_skip.ir import Catalog, TranslationError, quote, symbol
from lean_skip.emit import Emitter
from lean_skip.project import transpile

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('--prefix', action='append', default=[])
    args = parser.parse_args()
    try:
        transpile(args.input, args.output, args.prefix)
    except TranslationError as error:
        parser.exit(1, f'translation failed: {error}\n')
