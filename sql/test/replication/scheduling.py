from collections import defaultdict
import copy

class Scheduler:
  tasks = set()
  graph = defaultdict(list)

  def add(self, task):
    self.tasks.add(task)

  def happensBefore(self, a, b):
    self.graph[a].append(b)

  def run(self):
    raise RuntimeError("scheduler is abstract")

class ArbitraryTopoSortScheduler(Scheduler):
  def run(self):
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

    # TODO:
    print("schedule:")
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

  def run(self):
    schedule = []
    candidates = self._nodesWithNoIncomingEdge(self.graph)
    # TODO: there are more than N schedules, are you sure?
    for i, schedule in enumerate(self._schedules(schedule, candidates, self.graph)):
      print(f"{i}: {schedule}")

class RandomTopoSortsScheduler():
  # TODO: you will only test x% of the schedules are you aware?
  # TODO: must be streaming really, we don't want to calculate the schedules repeatedly or keep them
  pass
