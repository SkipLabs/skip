from __future__ import annotations
from collections import defaultdict
import copy

class HalfStream:
  buf = []

  def __init__(self, sender, receiver, sendTask, recvTask):
    self.sender = sender
    self.receiver = receiver
    self.sendTaskFactory = sendTask
    self.recvTaskFactory = recvTask

  def __repr__(self):
    return f"<{self.sender} -> {self.receiver}>"
  def __str__(self):
    return f"<{self.sender} -> {self.receiver}>"

  def send(self, payload):
    self.buf.append(payload)
    return self

  def recv(self):
    return self.buf.pop()

  def clock(self, scheduler):
    send = self.sendTaskFactory(self)
    recv = self.recvTaskFactory(self)
    # originally we added the two tasks separtely with a
    # happens-before relation, but this blows up the number of
    # schedules even more than I thought it would
    composed = Task(f"{send} then {recv}")
    scheduler.add(composed)
    return composed

id_counter = 0
class Task:
  def __init__(self, name):
    self.name = name
    global id_counter
    self.uid = id_counter
    id_counter = id_counter + 1

  def __repr__(self):
    return f"{self.name}"

  def __str__(self):
    return f"{self.name}"

  def __hash__(self) -> int:
    return hash(self.uid)

  def __eq__(self, value: Task) -> bool:
    return self.uid == value.uid

class SkdbPeer:
  streams = defaultdict(list)
  lastTask = None

  def __init__(self, name, scheduler):
    self.name = name
    self.scheduler = scheduler

  def __repr__(self):
    return self.name

  def __str__(self):
    return self.name

  def connect(self, table, stream: HalfStream):
    self.streams[table].append(stream)
    return self

  def insertInto(self, table: str, row):
    # TODO: the actual task created should be delegated to children
    insert = Task(f"insert {row} in to '{table}' on {self}")
    self.scheduler.add(insert)
    self.scheduler.happensBefore(self.lastTask, insert)
    self.lastTask = insert
    # TODO: this will need to traverse the graph of connections, not just the current single hop
    for stream in self.streams[table]:
      send = stream.clock(self.scheduler)
      self.scheduler.happensBefore(insert, send)

  def query(self, query):
    raise NotImplementedError()

  def initTask(self) -> Task:
    init = Task("Error")
    self.lastTask = init
    return init

  def tailTask(self, table):
    def factory(stream):
      return Task(f"read {table} tail from {self} and send to {stream}")
    return factory

  def writeTask(self, table):
    def factory(stream):
      return Task(f"read from {stream} and write to {self} {table}")
    return factory

class Server(SkdbPeer):
  def initTask(self) -> Task:
    init = Task(f"create server {self.name}")
    self.lastTask = init
    return init

class Client(SkdbPeer):
  def initTask(self) -> Task:
    init = Task(f"create client {self.name}")
    self.lastTask = init
    return init

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

class Topology:
  schemaQueries = []
  peers = []

  def __init__(self, scheduler):
    self.scheduler = scheduler

  def schema(self, query):
    self.schemaQueries.append(query)
    return self

  def add(self, peer: SkdbPeer):
    self.peers.append(peer)
    # TODO: topology owns scheduling this so that it can batch all
    # init together. save lots of pointless extra schedules
    # TODO: pass schema queries in
    self.scheduler.add(peer.initTask())
    return peer

  def mirror(self, table, a, b):
    atob = HalfStream(a,b, a.tailTask(table), b.writeTask(table))
    btoa = HalfStream(b,a, b.tailTask(table), a.writeTask(table))
    a.connect(table, atob)
    b.connect(table, btoa)
    return self

  def eventually(self, query: str):
    # TODO: capture these to be checked after scheduler
    results = ResultSets()
    # for peer in self.peers:
    #   results.add(peer.query(query))
    return results

class ResultSets():
  def add(self, results):
    raise NotImplementedError()

  def has(self, *rows):
    pass

scheduler = AllTopoSortsScheduler()

cluster = (
  Topology(scheduler)
  .schema("CREATE TABLE test_without_pk (id INTEGER, note STRING);")
)

server = cluster.add(Server("s1", scheduler))
client = cluster.add(Client("c1", scheduler))

# TODO: cluster.mirrorAll(table)?
cluster.mirror("test_without_pk", client, server)

# TODO: how to make it clear what of these are sequential and which are concurrent?
client.insertInto("test_without_pk", [0, 'foo'])
client.insertInto("test_without_pk", [1, 'foo'])
server.insertInto("test_without_pk", [2, 'foo'])

cluster.eventually("SELECT * FROM test_without_pk;").has(
  [0, "foo"], [1, "foo"], [2, "foo"]
)

# TODO: cluster.eventually().silent() - no output on processes

scheduler.run()
