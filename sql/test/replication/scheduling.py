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
  async def _run(schedule):
    try:
      await schedule.run()
    except AssertionError as err:
      debugRun = schedule.clone()
      try:
        log(f"> running debug test - schedule {hash(debugRun)}")
        await debugRun.run(log)
      finally:
        await debugRun.finalise()
    finally:
      await schedule.finalise()

  n = 0
  for i, schedule in enumerate(schedules):
    await _run(schedule)
    n = i + 1
  return f"Ran {n} schedules, all PASSED expectation checks"

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

class AllTopoSortsScheduler():
  def __init__(self, limit = 100, runAll = False):
    self.taskLists = [[]]
    self.graph = defaultdict(set)
    self.limit = limit
    self.runAll = runAll

  def _nodesWithNoIncomingEdge(self, nodeList, g):
    acc = set()
    for node in nodeList:
      found = False
      for (_, nodes) in g.items():
        if node in nodes:
          found = True
          break
      if not found:
        acc.add(node)
    return acc

  def _schedules(self, nodes, schedule, candidates, g):
    if candidates == set():
      if any(g[n] != list() for n in nodes):
        raise RuntimeError("Graph had a cycle")
      yield Schedule(schedule)
      return

    for n in candidates:
      ourSchedule = copy.copy(schedule)
      ourG = copy.copy(g)
      ourSchedule.append(n)
      ourG[n] = list()
      ourCandidates = candidates.union(self._nodesWithNoIncomingEdge(nodes, ourG)).difference(set(ourSchedule))
      for s in self._schedules(nodes, ourSchedule, ourCandidates, ourG):
        yield s

  def schedules(self, _log):
    for nodes in self.taskLists:
      schedule = []
      g = {n: [x for x in self.graph[n] if x in nodes] for n in nodes}
      candidates = self._nodesWithNoIncomingEdge(nodes, g)
      for sched in self._schedules(nodes, schedule, candidates, g):
        yield sched

  def tasks(self):
    for tasks in self.taskLists:
      for t in tasks:
        yield t

  def add(self, task):
    for t in self.taskLists:
      t.append(task)

  def choice(self, taskSets):
    acc = []
    for tasks in taskSets:
      for prefix in self.taskLists:
        t = copy.copy(prefix)
        t.extend(tasks)
        acc.append(t)
    self.taskLists = acc

  def happensBefore(self, a, b):
    self.graph[a].add(b)

  async def run(self, log):
    if not self.runAll:
      i = 0
      for _ in self.schedules(log):
        i = i+1
        if i > self.limit:
          raise RuntimeError(f"There are more than {self.limit} schedules")

    return await runSchedules(self.schedules(log), log)

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

  def __hash__(self) -> int:
    return hash(tuple(self.tasks))

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

class FirstN():
  def __init__(self, scheduler, N):
    self.scheduler = scheduler
    self.N = N

  def add(self, task):
    return self.scheduler.add(task)

  def choice(self, taskSets):
    return self.scheduler.choice(taskSets)

  def happensBefore(self, a, b):
    return self.scheduler.happensBefore(a,b)

  def tasks(self):
    return self.scheduler.tasks()

  async def run(self, log):
    return await runSchedules(self.schedules(log), log)

  def schedules(self, log):
    schedules = self.scheduler.schedules(log)
    return itertools.islice(schedules, self.N)

class ReservoirSample():
  def __init__(self, scheduler, N):
    self.scheduler = scheduler
    self.N = N

  def add(self, task):
    return self.scheduler.add(task)

  def choice(self, taskSets):
    return self.scheduler.choice(taskSets)

  def happensBefore(self, a, b):
    return self.scheduler.happensBefore(a,b)

  def tasks(self):
    return self.scheduler.tasks()

  async def run(self, log):
    return await runSchedules(self.schedules(log), log)

  def schedules(self, log):
    # just simple reservoir sample
    schedules = self.scheduler.schedules(log)
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
    if N < i + 1:
        log(f"WARN: We will run {N} of the {i+1} possible schedules. ~{int((N)/(i+1.0)*100)}%")
    return reservoir

class SpecificSchedule():
  def __init__(self, scheduler, hsh):
    self.scheduler = scheduler
    self.hsh = hsh

  def add(self, task):
    return self.scheduler.add(task)

  def choice(self, taskSets):
    return self.scheduler.choice(taskSets)

  def happensBefore(self, a, b):
    return self.scheduler.happensBefore(a,b)

  def tasks(self):
    return self.scheduler.tasks()

  async def run(self, log):
    return await runSchedules(self.schedules(log), log)

  def schedules(self, log):
    # just simple reservoir sample
    schedules = self.scheduler.schedules(log)
    for schedule in schedules:
      if hash(schedule) == self.hsh:
        return [schedule]
    log(f"WARN: Could not find schedule with hash {self.hsh}, running 0 schedules!")
    return []
