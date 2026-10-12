"""Build a disposable diagnostic compiler from an existing generated LLVM image."""
from pathlib import Path
import argparse
import re
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--compiler-ir', type=Path, required=True)
parser.add_argument('--runtime-out', type=Path, required=True,
                    help='stdlib build out directory containing runtime and libbacktrace objects')
parser.add_argument('--runtime-src', type=Path, required=True)
parser.add_argument('--out', type=Path, required=True)
args = parser.parse_args()
source_dir = Path(__file__).resolve().parent
out = args.out.resolve()
out.mkdir(parents=True, exist_ok=True)
llvm = args.compiler_ir.read_text()
llvm, count = re.subn(r'(target triple = [^\n]+\n)',
                     r'\1declare void @SKIP_shape_probe(ptr, ptr, i64)\n', llvm, count=1)
assert count == 1, 'missing target triple'
pattern = (r'(  tail call void @sk\.OuterIstToIR_Specializer__toFixed'
           r'\(ptr (%[^,]+), ptr ([^)]+)\), !dbg ![0-9]+\n)')
assert len(list(re.finditer(pattern, llvm))) == 2, 'expected two final specialization paths'
llvm = re.sub(pattern, lambda match:
              f'  call void @SKIP_shape_probe(ptr {match[3]}, ptr {match[2]}, i64 1)\n'
              + match[1]
              + f'  call void @SKIP_shape_probe(ptr {match[3]}, ptr {match[2]}, i64 2)\n', llvm)
(out / 'compiler.ll').write_text(llvm)
commands = [
    ['clang', '-O2', '-g', '-DSKIP64', '-I', str(args.runtime_src.resolve()),
     '-c', str(source_dir / 'shapes.c'), '-o', str(out / 'shapes.o')],
    ['clang', '-O2', '-c', str(out / 'compiler.ll'), '-o', str(out / 'compiler.o')],
]
objects = sorted(args.runtime_out.resolve().glob('*.o'))
objects += sorted((args.runtime_out.resolve() / 'libbacktrace').glob('*.o'))
assert objects, 'runtime objects missing'
commands.append(['clang++', '-no-pie', str(out / 'compiler.o'), str(out / 'shapes.o'),
                 *map(str, objects), '-lpthread', '-ldl', '-lm', '-o', str(out / 'skc-shapes')])
for command in commands:
    subprocess.run(command, check=True)
print(out / 'skc-shapes')
