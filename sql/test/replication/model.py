import asyncio
import uuid
from collections import defaultdict, deque
from scheduling import Task, MutableCompositeTask
from expect import Expectations
import os
import json

SKDB = "/skfs/build/skdb"
INITSQL = "/skfs/sql/privacy/init.sql"

def serialise(val):
  if isinstance(val, str):
    return f"'{val}'"
  return str(val)

def createNativeDb(dbkey, schemaQueries, shouldInit):
  async def f(schedule):
    guid = uuid.uuid4()
    db = f"/tmp/{guid}.db"
    schedule.storeScheduleLocal(dbkey, db)

    proc = await asyncio.create_subprocess_exec(SKDB, "--init", db)
    exit = await proc.wait()
    if exit > 0:
      raise RuntimeError("init exited non-zero")

    if shouldInit:
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

def destroyNativeDb(dbkey):
  async def f(schedule):
    db = schedule.getScheduleLocal(dbkey)
    if db is None:
      raise RuntimeError("could not get db")
    os.remove(db)
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

def runQuery(dbkey, query):
  async def f(schedule):
    db = schedule.getScheduleLocal(dbkey)
    if db is None:
      raise RuntimeError("could not get db")

    proc = await asyncio.create_subprocess_exec(SKDB, "--data", db, "--format=json",
                                                stdin=asyncio.subprocess.PIPE,
                                                stdout=asyncio.subprocess.PIPE)
    (out, _) = await proc.communicate(query.encode())
    if proc.returncode is None or proc.returncode > 0:
      raise RuntimeError(f"running '{query}' exited non-zero")

    lines = out.decode().split('\n')
    return list(json.loads(x) for x in lines if x.strip() != '')
  return f

def subscribe(dbkey, subkey, table, user, dest, peerId):
  async def f(schedule):
    db = schedule.getScheduleLocal(dbkey)
    if db is None:
      raise RuntimeError("could not get db")
    proc = await asyncio.create_subprocess_exec(SKDB, "--data", db, "subscribe", table, "--connect",
                                                # TODO:
                                                # "--user", user,
                                                "--ignore-source", dest,
                                                "--peer-id", peerId,
                                                stdout=asyncio.subprocess.PIPE)
    (out, _) = await proc.communicate()
    session = out.decode().rstrip()
    schedule.storeScheduleLocal(subkey, session)
    return session
  return f

async def tail(db, session, peerId, since):
  proc = await asyncio.create_subprocess_exec(SKDB, "--data", db, "tail",
                                              session, "--since", str(since),
                                              "--peer-id", peerId,
                                              stdout=asyncio.subprocess.PIPE)
  (out, _) = await proc.communicate()
  return out

def startStreamingWriteCsv(dbkey, writecsvKey, table, user, source, peerId):
  async def f(schedule):
    db = schedule.getScheduleLocal(dbkey)
    if db is None:
      raise RuntimeError("could not get db")

    proc = await asyncio.create_subprocess_exec(SKDB, "--data", db, "apply-diff", table,
                                                # TODO:
                                                # "--user", user,
                                                "--source", source,
                                                "--peer-id", peerId,
                                                stdin=asyncio.subprocess.PIPE,
                                                stdout=asyncio.subprocess.DEVNULL,)
    schedule.storeScheduleLocal(writecsvKey, proc)
    return proc
  return f

def getOurLastCheckpoint(current, diffOutput):
  def parse(line: str):
    event = json.loads(line)
    if event.get('type') in ['commit', 'reset']:
      return event.get('tick')
    return 0
  lines = diffOutput.split('\n')
  cps = [parse(l) for l in lines if l.strip() != '']
  cps.append(current)
  cps.append(0)
  return max(cps)

def diffOutputIsSilent(diff):
  lines = diff.split('\n')
  return all(l.strip() == "" or
             json.loads(l).get('type') in ['commit', 'reset', 'heartbeat']
             for l in lines)

class HalfStream:

  def __init__(self, sender, receiver, sendTask, recvTask):
    self.other: HalfStream | None = None
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
    payload =  schedule.getScheduleLocal(self).pop()
    schedule.debug(payload.decode())
    return payload

  def initTask(self):
    t = MutableCompositeTask()
    send = self.sendTaskFactory(self, init=True)
    t.add(send)
    recv = self.recvTaskFactory(self, init=True)
    t.add(recv)
    async def f(schedule):
      schedule.storeScheduleLocal(self, deque())
    t.add(Task(f"create {self} channel buffer", f))
    return t

  def sendTask(self):
    return self.sendTaskFactory(self, init=False)

  def recvTask(self):
    return self.recvTaskFactory(self, init=False)

  def clockTask(self):
    # originally we added the two tasks separtely with a
    # happens-before relation, but this blows up the number of
    # schedules
    t = MutableCompositeTask()
    t.add(self.sendTask())
    t.add(self.recvTask())
    return t

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
    # we prime the visited set with the inverse streams. this has the
    # effect of not sending echo responses. they are assumed to be
    # filtered and so are always a no-op. this reduces schedule sizes
    # dramatically (orders of magnitude), so is worth not testing
    visited = set(s.other for s in self.streams[table] if s.other)
    def traverse(before, streams):
      for stream in streams:
        if stream in visited:
          continue
        visited.add(stream)
        send = stream.clockTask()
        self.scheduler.add(send)
        self.scheduler.happensBefore(before, send)
        traverse(send, stream.receiver.streams[table])
    traverse(insert, self.streams[table])
    return insert

  def insertOrReplace(self, table: str, row):
    rowStr = ", ".join(serialise(val) for val in row)
    q = f"INSERT OR REPLACE INTO {table} VALUES ({rowStr});"
    insert = Task(f"insert with replace {row} in to '{table}' on {self}", runDmlQuery(self, q))
    self.scheduler.add(insert)
    self.scheduler.happensBefore(self.lastTask, insert)
    self.lastTask = insert
    # we prime the visited set with the inverse streams. this has the
    # effect of not sending echo responses. they are assumed to be
    # filtered and so are always a no-op. this reduces schedule sizes
    # dramatically (orders of magnitude), so is worth not testing
    visited = set(s.other for s in self.streams[table] if s.other)
    def traverse(before, streams):
      for stream in streams:
        if stream in visited:
          continue
        visited.add(stream)
        send = stream.clockTask()
        self.scheduler.add(send)
        self.scheduler.happensBefore(before, send)
        traverse(send, stream.receiver.streams[table])
    traverse(insert, self.streams[table])
    return insert

  async def query(self, schedule, query):
    return await runQuery(self, query)(schedule)

  def initTask(self) -> Task:
    raise NotImplementedError()

  def tailTask(self, table, dest, peerId):
    def factory(stream, init):
      subkey = (self, stream, 'sub')

      async def start(schedule):
        user = "todo"               # TODO:
        start = subscribe(self, subkey, table, user, dest, peerId)
        await start(schedule)

      async def pull(schedule):
        sinceKey = (self, stream, 'since')
        db = schedule.getScheduleLocal(self)
        session = schedule.getScheduleLocal(subkey)
        since = schedule.getScheduleLocal(sinceKey) or 0
        payload = await tail(db, session, peerId, since)
        stream.send(schedule, payload)
        schedule.storeScheduleLocal(sinceKey, getOurLastCheckpoint(since, payload.decode()))

      if init:
        return Task(f"create subscription for {self} {table} {stream}", start)
      return Task(f"<{self} {table}> -> {stream}", pull)
    return factory

  def writeTask(self, table, source, peerId):
    def factory(stream, init):
      key = (self, stream, 'write')
      async def start(schedule):
        user = "todo"               # TODO:
        start = startStreamingWriteCsv(self, key, table, user, source, peerId)
        await start(schedule)

      async def stop(schedule):
        proc = schedule.getScheduleLocal(key)
        proc.terminate()

      async def push(schedule):
        proc = schedule.getScheduleLocal(key)

        payload = stream.recv(schedule)
        proc.stdin.write(payload)

      if init:
        return Task(f"start write-csv for {self} {table} {stream}", start, stop)
      return Task(f"{stream} -> <{self} {table}>", push)
    return factory

class Server(SkdbPeer):
  def initTask(self) -> Task:
    return Task(f"create server {self.name}",
                createNativeDb(self, self.schema, shouldInit=True),
                destroyNativeDb(self))

class Client(SkdbPeer):
  def initTask(self) -> Task:
    return Task(f"create client {self.name}",
                createNativeDb(self, self.schema, shouldInit=False),
                destroyNativeDb(self))

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
    aId = self._genReplicationId()
    bId = self._genReplicationId()
    atob = HalfStream(a, b,
                      a.tailTask(table, dest=bId, peerId=aId),
                      b.writeTask(table, source=aId, peerId=bId))
    btoa = HalfStream(b, a,
                      b.tailTask(table, dest=aId, peerId=bId),
                      a.writeTask(table, source=bId, peerId=aId))
    atob.other = btoa
    btoa.other = atob
    self.initTask.add(atob.initTask())
    self.initTask.add(btoa.initTask())
    a.notifyConnection(table, atob)
    b.notifyConnection(table, btoa)
    return self

  def state(self, query: str):
    expectations = Expectations()
    async def f(schedule):
      results = await asyncio.gather(
        *[peer.query(schedule, query) for peer in self.peers]
      )
      expectations.check(results)
    checkTask = Task(f"Check {expectations} on {query}", f)
    for scheduled in self.scheduler.tasks():
      self.scheduler.happensBefore(scheduled, checkTask)
    self.scheduler.add(checkTask)
    return expectations

  def isSilent(self):
    streams = [
      stream
      for peer in self.peers
      for table in peer.streams
      for stream in peer.streams[table]
    ]
    t = MutableCompositeTask()
    for s in streams:
      t.add(s.sendTask())
    async def f(schedule):
      for s in streams:
        out = s.recv(schedule).decode()
        if not diffOutputIsSilent(out):
          raise AssertionError(f"Not silent: {s} {out}")
    checkTask = Task(f"Check all tail output silent", f)
    t.add(checkTask)
    for scheduled in self.scheduler.tasks():
      self.scheduler.happensBefore(scheduled, t)
    self.scheduler.add(t)
