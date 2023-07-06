import asyncio
import traceback
import inspect
import sys
import multiprocessing as mp

def run_test(args):
  name, f = args
  prefix = f">>> {name.replace('test_', '').replace('_', ' ')}......"
  loop = asyncio.get_event_loop()
  log = []
  def collect(output):
    log.append(output)
  try:
    info = loop.run_until_complete(f().run(collect))
    output = "" if log == [] else "\n".join(log)
    return f"{output}\n{prefix}{info}"
  except:
    exn = traceback.format_exc()
    output = "\n".join(log)
    return f"{prefix}FAILED:\n{output}\n{exn}"


def run_tests(module, nProcs=3):
  fns = inspect.getmembers(module, inspect.isfunction)
  tests = list((name, f) for name, f in fns if name.startswith('test_'))
  with mp.Pool(nProcs) as p:
    for result in p.imap_unordered(run_test, tests):
      print(result)

if __name__ == '__main__':
  run_tests(sys.modules[__name__])
