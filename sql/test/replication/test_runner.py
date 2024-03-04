import asyncio
import traceback
import inspect
import sys
import multiprocessing as mp
import scheduling as sched

def run_test(args):
  name, f = args
  prefix = f"> {name}......"
  loop = asyncio.get_event_loop()
  log = []
  def collect(output):
    log.append(output)
  try:
    scheduler = f()
    # scheduler = sched.SpecificSchedule(scheduler, -1039740434997820987)
    info = loop.run_until_complete(scheduler.run(collect))
    output = "" if log == [] else ("\n".join(log) + "\n")
    return f"{output}{prefix}{info}"
  except:
    exn = traceback.format_exc()
    output = "\n".join(log)
    return f"{prefix}FAILED:\n{output}\n{exn}"


def run_tests(module, nProcs=20):
  fns = inspect.getmembers(module, inspect.isfunction)
  tests = list((name, f) for name, f in fns if name.startswith('test_'))
  with mp.Pool(nProcs) as p:
    for result in p.imap_unordered(run_test, tests):
      print(result)

def run_just(f):
  print(run_test(('debug', f)))

if __name__ == '__main__':
  run_tests(sys.modules[__name__])
