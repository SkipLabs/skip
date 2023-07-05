import inspect
import sys
import multiprocessing as mp

def run_test(args):
  name, f = args
  prefix = f"{name.replace('test_', '').replace('_', ' ')}......"
  try:
    f()
    return f"{prefix}PASS"
  except:
    return f"{prefix}FAIL"


def run_tests(module, nProcs=3):
  tests = list((name, f) for name, f in inspect.getmembers(module, inspect.isfunction)
               if name.startswith('test_'))
  with mp.Pool(nProcs) as p:
    for result in p.imap_unordered(run_test, tests):
      print(result)

if __name__ == '__main__':
  run_tests(sys.modules[__name__])
