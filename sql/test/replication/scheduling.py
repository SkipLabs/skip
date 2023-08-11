from __future__ import annotations
from collections import defaultdict
import itertools
import random
import copy
import sys
import asyncio

task_id_counter = 0

async def anop(*args, **kwargs):
  pass

def nop(*args, **kwargs):
  pass

async def runSchedules(schedules, log):
  failLock = asyncio.Lock()
  async def _run(schedule):
    try:
      await schedule.run()
    except AssertionError as err:
      if failLock.locked():
        return
      await failLock.acquire() # just deal with first failure
      debugRun = schedule.clone()
      try:
        print("> running debug test", file=sys.stderr)
        await debugRun.run(log)
      except AssertionError as err:
        sys.exit(1)
      finally:
        await debugRun.finalise()
    finally:
      await schedule.finalise()

  n = 0
  tasks = set()
  # 8 is fairly arbitrary. a few experimental runs suggests it's
  # quite good on an m1 macbook. this whole batch gather model
  # isn't great, but it's easy to code and good enough to run
  # hundreds of schedules in a few secs.
  sem = asyncio.Semaphore(8)
  for i, schedule in enumerate(schedules):
    n = i
    await sem.acquire()
    t = asyncio.create_task(_run(schedule))
    tasks.add(t)
    t.add_done_callback(lambda t: (tasks.discard(t), sem.release()))
  await asyncio.gather(*tasks)
  return f"Ran {n+1} schedules, all PASSED expectation checks"

class Task:
  def __init__(self, name, fn, final = anop):
    self.name = name
    self.fn = fn
    self.final = final
    global task_id_counter
    self.uid = task_id_counter
    task_id_counter = task_id_counter + 1

  def __repr__(self):
    return f"{self.name}"

  def __str__(self):
    return f"{self.name}"

  def __hash__(self) -> int:
    return hash(self.uid)

  def __eq__(self, value: Task) -> bool:
    return self.uid == value.uid

  async def run(self, schedule):
    await self.fn(schedule)

  async def finalise(self, schedule):
    await self.final(schedule)

class MutableCompositeTask:
  def __init__(self):
    self.taskSeq = []

    global task_id_counter
    self.uid = task_id_counter
    task_id_counter = task_id_counter + 1

  def add(self, task):
    self.taskSeq.append(task)
    return self

  def __repr__(self):
    return " then ".join(str(x) for x in self.taskSeq)

  def __str__(self):
    return " then ".join(str(x) for x in self.taskSeq)

  def __hash__(self) -> int:
    return hash(self.uid)

  def __eq__(self, value: Task) -> bool:
    return self.uid == value.uid

  async def run(self, schedule):
    for t in self.taskSeq:
      await t.run(schedule)

  async def finalise(self, schedule):
    for t in reversed(self.taskSeq):
      await t.finalise(schedule)

class Scheduler:
  def __init__(self):
    self.t = []
    self.graph = defaultdict(set)

  def add(self, task):
    self.t.append(task)

  def happensBefore(self, a, b):
    self.graph[a].add(b)

  def schedules(self):
    return []

  def tasks(self):
    return self.t

  async def run(self, log):
    return await runSchedules(self.schedules(), log)

class Schedule:
  def __init__(self, tasks):
    self.state = {}
    self.tasks = tasks

  def clone(self):
    return Schedule(self.tasks)

  def storeScheduleLocal(self, key, value):
    self.state[key] = value

  def getScheduleLocal(self, key):
    return self.state.get(key)

  def __repr__(self):
    lst = "\n".join(f"{i}: {x}" for i,x in enumerate(self.tasks))
    return f"schedule:\n{lst}"

  def __str__(self):
    return self.__repr__()

  def happensBefore(self, t1, t2) -> bool:
    rest = itertools.dropwhile(lambda x: x!=t1, self.tasks)
    return t2 in rest

  async def run(self, debug=nop):
    self.debug=debug
    for i,t in enumerate(self.tasks):
      debug(f"> {i}: {t}")
      await t.run(self)

  async def finalise(self):
    for t in reversed(self.tasks):
      await t.finalise(self)

class ArbitraryTopoSortScheduler(Scheduler):
  def schedules(self):
    # kahn's algo, we pick from multiple choices arbitrarily

    g = copy.deepcopy(self.graph)

    def nodesWithNoIncomingEdge():
      acc = set()
      for node in self.t:
        found = False
        for (_, nodes) in g.items():
          if node in nodes:
            found = True
            break
        if not found:
          acc.add(node)
      return acc

    schedule = []
    candidates = nodesWithNoIncomingEdge()
    while candidates != set():
      n = candidates.pop()
      schedule.append(n)
      g[n] = set()
      candidates = candidates.union(nodesWithNoIncomingEdge()).difference(set(schedule))

    def hasEdges(g):
      any(x != list() for x in g.values())

    if hasEdges(g):
      raise RuntimeError("Graph had a cycle")

    yield Schedule(schedule)

class AllTopoSortsScheduler(Scheduler):
  def __init__(self, limit = 100, runAll = False):
    super().__init__()
    self.limit = limit
    self.runAll = runAll

  def _nodesWithNoIncomingEdge(self, g):
    acc = set()
    for node in self.t:
      found = False
      for (_, nodes) in g.items():
        if node in nodes:
          found = True
          break
      if not found:
        acc.add(node)
    return acc

  def _schedules(self, schedule, candidates, g):
    if candidates == set():
      if any(x != list() for x in g.values()):
        raise RuntimeError("Graph had a cycle")
      yield Schedule(schedule)
      return

    for n in candidates:
      ourCandidates = copy.copy(candidates)
      ourSchedule = copy.copy(schedule)
      ourG = copy.copy(g)
      ourSchedule.append(n)
      ourG[n] = list()
      ourCandidates = ourCandidates.union(self._nodesWithNoIncomingEdge(ourG)).difference(set(ourSchedule))
      for s in self._schedules(ourSchedule, ourCandidates, ourG):
        yield s

  def schedules(self):
    schedule = []
    candidates = self._nodesWithNoIncomingEdge(self.graph)
    return self._schedules(schedule, candidates, self.graph)

  async def run(self, log):
    if not self.runAll:
      i = 0
      for _ in self.schedules():
        i = i+1
        if i > self.limit:
          raise RuntimeError(f"There are more than {self.limit} schedules")

    return await super().run(log)

class ReservoirSample():
  def __init__(self, scheduler, N):
    super().__init__()
    self.scheduler = scheduler
    self.N = N

  def add(self, task):
    return self.scheduler.add(task)

  def happensBefore(self, a, b):
    return self.scheduler.happensBefore(a,b)

  def tasks(self):
    return self.scheduler.tasks()

  async def run(self, log):
    return await runSchedules(self.schedules(log), log)

  def schedules(self, log):
    # just simple reservoir sample
    schedules = self.scheduler.schedules()
    reservoir = list(itertools.islice(schedules, self.N))
    N = len(reservoir)
    i = N - 1
    for schedule in schedules:
      i = i + 1
      if (i+1) % 1e6 == 0:
        log(f"WARN: Looked at {i+1} schedules so far")
      randIdx = random.randint(0, i)
      if randIdx < self.N:
        reservoir[randIdx] = schedule
    log(f"WARN: We will run {N} of the {i+1} possible schedules. ~{int((N)/(i+1.0)*100)}%")
    return reservoir
