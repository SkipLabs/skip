import asyncio
import uuid
from collections import defaultdict, deque
from scheduling import Task, MutableCompositeTask

SKDB = "/skfs/build/skdb"
INITSQL = "/skfs/sql/privacy/init.sql"

def serialise(val):
  if isinstance(val, str):
    return f"'{val}'"
  return str(val)

def createNativeDb(dbkey, schemaQueries):
  async def f(schedule):
    guid = uuid.uuid4()
    db = f"/tmp/{guid}.db"
    schedule.storeScheduleLocal(dbkey, db)

    proc = await asyncio.create_subprocess_exec(SKDB, "--init", db)
    exit = await proc.wait()
    if exit > 0:
      raise RuntimeError("init exited non-zero")

    init = open(INITSQL)
    proc = await asyncio.create_subprocess_exec(SKDB, "--data", db, stdin=init)
    exit = await proc.wait()
    init.close()
    if exit > 0:
      raise RuntimeError("init exited non-zero")

    qs = "\n".join(schemaQueries)
    proc = await asyncio.create_subprocess_exec(SKDB, "--data", db,
                                                stdin=asyncio.subprocess.PIPE)
    await proc.communicate(qs.encode())
    if proc.returncode is None or proc.returncode > 0:
      raise RuntimeError("init exited non-zero")
  return f

def runDmlQuery(dbkey, query):
  async def f(schedule):
    db = schedule.getScheduleLocal(dbkey)
    if db is None:
      raise RuntimeError("could not get db")

    proc = await asyncio.create_subprocess_exec(SKDB, "--data", db,
                                                stdin=asyncio.subprocess.PIPE)
    await proc.communicate(query.encode())
    if proc.returncode is None or proc.returncode > 0:
      raise RuntimeError(f"running '{query}' exited non-zero")
  return f

def startStreamingTail(dbkey, tailkey, table, user, replicationId):
  async def f(schedule):
    db = schedule.getScheduleLocal(dbkey)
    if db is None:
      raise RuntimeError("could not get db")
    proc = await asyncio.create_subprocess_exec(SKDB, "--data", db, "subscribe", table, "--connect",
                                                # TODO:
                                                # "--user", user,
                                                "--ignore-source", replicationId,
                                                stdout=asyncio.subprocess.PIPE)
    (out, _) = await proc.communicate()
    session = out.decode().rstrip()
    proc = await asyncio.create_subprocess_exec(SKDB, "--data", db, "tail",
                                                "--format=csv", str(session), "--since", "0",
                                                "--follow",
                                                stdout=asyncio.subprocess.PIPE)
    schedule.storeScheduleLocal(tailkey, proc)
    return proc
  return f

def startStreamingWriteCsv(dbkey, writecsvKey, table, user, replicationId):
  async def f(schedule):
    db = schedule.getScheduleLocal(dbkey)
    if db is None:
      raise RuntimeError("could not get db")

    proc = await asyncio.create_subprocess_exec(SKDB, "--data", db, "write-csv", table,
                                                # TODO:
                                                # "--user", user,
                                                "--source", replicationId,
                                                stdin=asyncio.subprocess.PIPE)
    schedule.storeScheduleLocal(writecsvKey, proc)
    return proc
  return f

class HalfStream:

  def __init__(self, sender, receiver, sendTask, recvTask):
    self.sender = sender
    self.receiver = receiver
    self.sendTaskFactory = sendTask
    self.recvTaskFactory = recvTask

  def __repr__(self):
    return f"<{self.sender} -> {self.receiver}>"

  def __str__(self):
    return f"<{self.sender} -> {self.receiver}>"

  def send(self, schedule, payload):
    schedule.getScheduleLocal(self).append(payload)
    return self

  def recv(self, schedule):
    return schedule.getScheduleLocal(self).pop()

  def initTask(self):
    async def f(schedule):
      schedule.storeScheduleLocal(self, deque())
    return Task(f"setup {self} channel", f)

  def clockTask(self):
    send = self.sendTaskFactory(self)
    recv = self.recvTaskFactory(self)
    # originally we added the two tasks separtely with a
    # happens-before relation, but this blows up the number of
    # schedules
    async def f(schedule):
      await send.run(schedule)
      await recv.run(schedule)
    return Task(f"{send} then {recv}", f)

class SkdbPeer:

  def __init__(self, name, scheduler):
    self.schema = ['foo']
    self.streams = defaultdict(list)
    self.lastTask: None|Task|MutableCompositeTask = None
    self.name = name
    self.scheduler = scheduler

  def __repr__(self):
    return self.name

  def __str__(self):
    return self.name

  def notifyConnection(self, table, stream: HalfStream):
    self.streams[table].append(stream)
    return self

  def insertInto(self, table: str, row):
    rowStr = ", ".join(serialise(val) for val in row)
    q = f"INSERT INTO {table} VALUES ({rowStr});"
    insert = Task(f"insert {row} in to '{table}' on {self}", runDmlQuery(self, q))
    self.scheduler.add(insert)
    self.scheduler.happensBefore(self.lastTask, insert)
    self.lastTask = insert
    # TODO: this will need to traverse the graph of connections, not just the current single hop
    for stream in self.streams[table]:
      send = stream.clockTask()
      self.scheduler.add(send)
      self.scheduler.happensBefore(insert, send)
    return insert

  async def query(self, query):
    raise NotImplementedError()

  def initTask(self) -> Task:
    raise NotImplementedError()

  def tailTask(self, table, replicationId):
    raise NotImplementedError()

  def writeTask(self, table, replicationId):
    def factory(stream):
      async def f(schedule):
        key = (self, stream, 'write')
        proc = schedule.getScheduleLocal(key)
        if proc is None:
          user = "todo"               # TODO:
          start = startStreamingWriteCsv(self, key, table, user, replicationId)
          proc = await start(schedule)

        payload = stream.recv(schedule)
        proc.stdin.write(payload.encode())
      return Task(f"read from {stream} and write to {self} {table}", f)
    return factory

class Server(SkdbPeer):

  def initTask(self) -> Task:
    return Task(f"create server {self.name}", createNativeDb(self, self.schema))

  def tailTask(self, table, replicationId):
    def factory(stream):
      async def f(schedule):
        tailkey = (self, stream, 'tail')
        tailProc = schedule.getScheduleLocal(tailkey)
        if tailProc is None:
          user = "todo"               # TODO:
          start = startStreamingTail(self, tailkey, table, user, replicationId)
          tailProc = await start(schedule)

        buf = []
        while True:
          # TODO: need timeout
          data = await tailProc.stdout.readline()
          line = data.decode()
          buf.append(line)
          if line.startswith(":"):
            payload = "".join(buf)
            stream.send(schedule, payload)
            return

      return Task(f"read {table} tail from {self} and send to {stream}", f)
    return factory

class Client(SkdbPeer):

  def initTask(self) -> Task:
    return Task(f"create client {self.name}", createNativeDb(self, self.schema))

  # TODO:
  def tailTask(self, table, replicationId):
    def factory(stream):
      async def f(schedule):
        tailkey = (self, stream, 'tail')
        tailProc = schedule.getScheduleLocal(tailkey)
        if tailProc is None:
          user = "todo"               # TODO:
          start = startStreamingTail(self, tailkey, table, user, replicationId)
          tailProc = await start(schedule)

        buf = []
        while True:
          # TODO: need timeout
          data = await tailProc.stdout.readline()
          line = data.decode()
          buf.append(line)
          if line.startswith(":"):
            payload = "".join(buf)
            stream.send(schedule, payload)
            return

      return Task(f"read {table} tail from {self} and send to {stream}", f)
    return factory

class Topology:

  def __init__(self, scheduler):
    self.replicationIdGen = 0
    self.schemaQueries = []
    self.peers = []
    self.scheduler = scheduler
    self.initTask = MutableCompositeTask()
    self.scheduler.add(self.initTask)

  def schema(self, query):
    self.schemaQueries.append(query)
    return self

  def add(self, peer: SkdbPeer):
    self.peers.append(peer)
    peer.schema = self.schemaQueries
    self.initTask.add(peer.initTask())
    peer.lastTask = self.initTask
    return peer

  def _genReplicationId(self):
    self.replicationIdGen = self.replicationIdGen + 1
    return str(self.replicationIdGen)

  def mirror(self, table, a, b):
    repId = self._genReplicationId()
    atob = HalfStream(a,b, a.tailTask(table, repId), b.writeTask(table, repId))
    repId = self._genReplicationId()
    btoa = HalfStream(b,a, b.tailTask(table, repId), a.writeTask(table, repId))
    self.initTask.add(atob.initTask())
    self.initTask.add(btoa.initTask())
    a.notifyConnection(table, atob)
    b.notifyConnection(table, btoa)
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
