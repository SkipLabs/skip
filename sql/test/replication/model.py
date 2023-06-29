from __future__ import annotations
from collections import defaultdict

task_id_counter = 0

class Task:
  def __init__(self, name):
    self.name = name
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

class MutableCompositeTask:
  taskSeq = []

  def __init__(self):
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
    # TODO:
    composed = Task(f"{send} then {recv}")
    scheduler.add(composed)
    return composed

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
    return insert

  def query(self, query):
    raise NotImplementedError()

  def initTask(self) -> Task:
    return Task("Error")

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
    return Task(f"create server {self.name}")

class Client(SkdbPeer):
  def initTask(self) -> Task:
    return Task(f"create client {self.name}")

class Topology:
  schemaQueries = []
  peers = []

  def __init__(self, scheduler):
    self.scheduler = scheduler
    self.initTask = MutableCompositeTask()
    self.scheduler.add(self.initTask)

  def schema(self, query):
    self.schemaQueries.append(query)
    return self

  def add(self, peer: SkdbPeer):
    self.peers.append(peer)
    # TODO: topology owns scheduling this so that it can batch all
    # init together. save lots of pointless extra schedules
    # TODO: pass schema queries in
    self.initTask.add(peer.initTask())
    peer.lastTask = self.initTask
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
