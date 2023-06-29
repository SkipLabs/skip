from collections import defaultdict
import itertools
import random
import copy

class Scheduler:
  tasks = set()
  graph = defaultdict(list)

  def add(self, task):
    self.tasks.add(task)

  def happensBefore(self, a, b):
    self.graph[a].append(b)

class ArbitraryTopoSortScheduler(Scheduler):
  def schedules(self):
    # kahn's algo, we pick from multiple choices arbitrarily

    g = copy.deepcopy(self.graph)

    def nodesWithNoIncomingEdge():
      acc = set()
      for node in self.tasks:
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
      g[n] = list()
      candidates = candidates.union(nodesWithNoIncomingEdge()).difference(set(schedule))

    def hasEdges(g):
      any(x != list() for x in g.values())

    if hasEdges(g):
      raise RuntimeError("Graph had a cycle")

    yield schedule

  def run(self):
    # TODO:
    print("schedule:")
    for schedule in self.schedules():
      for i, s in enumerate(schedule):
        print(f"{i}: {s}")

class AllTopoSortsScheduler(Scheduler):
  def _nodesWithNoIncomingEdge(self, g):
    acc = set()
    for node in self.tasks:
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
      yield schedule
      return

    for n in candidates:
      ourCandidates = copy.deepcopy(candidates)
      ourSchedule = copy.deepcopy(schedule)
      ourG = copy.deepcopy(g)
      ourSchedule.append(n)
      ourG[n] = list()
      ourCandidates = ourCandidates.union(self._nodesWithNoIncomingEdge(ourG)).difference(set(ourSchedule))
      for s in self._schedules(ourSchedule, ourCandidates, ourG):
        yield s

  def schedules(self):
    schedule = []
    candidates = self._nodesWithNoIncomingEdge(self.graph)
    return self._schedules(schedule, candidates, self.graph)

  def run(self, limit = 100, runAll = False):
    if not runAll:
      i = 0
      for _ in self.schedules():
        i = i+1
        if i > limit:
          raise RuntimeError(f"There are more than {limit} schedules")

    for i, schedule in enumerate(self.schedules()):
      # TODO:
      print(f"{i}: {schedule}")

class RandomTopoSortsScheduler(Scheduler):
  def __init__(self, scheduler, N):
    self.scheduler = scheduler
    self.N = N

  def schedules(self):
    # just simple reservoir sample
    schedules = self.scheduler.schedules()
    reservoir = list(itertools.islice(schedules, self.N))
    i = self.N - 1
    for schedule in schedules:
      i = i + 1
      randIdx = random.randint(0, i)
      if randIdx < self.N:
        reservoir[randIdx] = schedule
    print(f"We will run {self.N} of the {i+1} possible schedules. ~{int((self.N)/(i+1.0)*100)}%")
    return reservoir

  def run(self):
    for i, schedule in enumerate(self.schedules()):
      # TODO:
      print(f"{i}: {schedule}")
