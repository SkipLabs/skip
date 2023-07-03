import asyncio
import scheduling as sched
from model import Topology, Client, Server

scheduler = sched.AllTopoSortsScheduler()

cluster = (
  Topology(scheduler)
  .schema("CREATE TABLE test_without_pk (id INTEGER, note STRING);")
)

server = cluster.add(Server("s1", scheduler))
client = cluster.add(Client("c1", scheduler))

# TODO: cluster.mirrorAll(table)?
cluster.mirror("test_without_pk", client, server)

# per each peer we run operations in order - they're assumed to be causal
c1ins1 = client.insertInto("test_without_pk", [0, 'foo'])
c1ins2 = client.insertInto("test_without_pk", [1, 'foo'])

# but this operation is concurrent to any that happen on client
s1ins1 = server.insertInto("test_without_pk", [2, 'foo'])

# unless we constrain like so:
scheduler.happensBefore(c1ins2, s1ins1)

# TODO: would this be useful?
# scheduler.happensConcurrently(c1ins1, c1ins2)

cluster.now("SELECT * FROM test_without_pk;").hasRows(
  [0, "foo"], [1, "foo"], [2, "foo"]
)

# TODO: cluster.eventually().silent() - no output on processes

asyncio.run(scheduler.run())
