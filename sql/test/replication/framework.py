from __future__ import annotations
from collections import defaultdict
from collections.abc import Set
import copy

class Connection:
  def __init__(self, a: SkdbPeer, b: SkdbPeer):
    self.a = a
    self.b = b

class FullDuplex:
  def __init__(self, a: Connection, b: Connection):
    self.a = a
    self.b = b

  def mirror(self, table: str):
    # TODO: probably just capture stuff on Connection in both directions
    pass

class Task:
  def __init__(self, name):
    self.name = name

  def __repr__(self):
    return f"{self.name}"

  def __str__(self):
    return f"{self.name}"

class SkdbPeer:
  def connectFullDuplex(self, peer: SkdbPeer):
    ltr = Connection(self, peer)
    rtl = Connection(peer, self)
    return FullDuplex(ltr, rtl)

  def insertInto(self, query: str, row):
    # TODO: construct the tasks, add to scheduler, define the relationships
    # TODO: any tasks that block on processes should have a (short) timeout
    pass

  def query(self, query):
    pass

  def initTask(self) -> Task:
    return Task("Error")

class Server(SkdbPeer):
  def initTask(self) -> Task:
    return Task("create_server")

class Client(SkdbPeer):
  def initTask(self) -> Task:
    return Task("create_client")

class Scheduler:
  tasks = set()
  graph = defaultdict(list)

  def add(self, task):
    self.tasks.add(task)

  def happensBefore(self, a, b):
    self.graph[a].append(b)

  def run(self):
    raise RuntimeError("scheduler is abstract")

class TopoSortScheduler(Scheduler):
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
      candidates.union(nodesWithNoIncomingEdge())

    def hasEdges(g):
      any(x != list() for x in g.values())

    if hasEdges(g):
      raise RuntimeError("Graph had a cycle")

    print(f"schedule: {schedule}")

class AllTopoSortsScheduler(Scheduler):
  def run(self):
    print(self.tasks)
    print(self.graph)

class NRandomSchedules(Scheduler):
  pass

class RandomScheduler(Scheduler):
  pass

class SpecificTopoSortsScheduler(Scheduler):
  pass

class Topology:
  peers = []
  scheduler = AllTopoSortsScheduler()

  def schema(self, query):
    return self

  def scheduleUsing(self, scheduler: Scheduler):
    if self.scheduler.tasks != set():
      raise RuntimeError("scheduling already begun")
    self.scheduler = scheduler
    return self

  def add(self, peer: SkdbPeer):
    self.peers.append(peer)
    self.scheduler.add(peer.initTask())
    return peer

  def start(self):
    self.scheduler.run()
    # TODO: check eventually assertions after each run. maybe we can
    # do this with a happensAfter task depending on everything

  def eventually(self, query: str):
    # TODO: capture these to be checked after scheduler
    results = ResultSets()
    for peer in self.peers:
      results.add(peer.query(query))
    return results

class ResultSets():
  def add(self, results):
    pass

  def has(self, *rows):
    pass

cluster = (
  Topology()
  .schema("CREATE TABLE test_without_pk (id INTEGER, note STRING);")
  .scheduleUsing(TopoSortScheduler())
)

server = cluster.add(Server())
client = cluster.add(Client())

client.connectFullDuplex(server).mirror("test_without_pk")

# TODO: how to make it clear what of these are sequential and which are concurrent?
client.insertInto("test_without_pk", [0, 'foo'])
client.insertInto("test_without_pk", [1, 'foo'])
server.insertInto("test_without_pk", [2, 'foo'])

cluster.eventually("SELECT * FROM test_without_pk;").has(
  [0, "foo"], [1, "foo"], [2, "foo"]
)

cluster.start()
