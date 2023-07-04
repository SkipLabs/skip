import asyncio
import scheduling as sched
from model import Topology, Client, Server

scheduler = sched.ReservoirSample(sched.AllTopoSortsScheduler(), 5000)

cluster = (
  Topology(scheduler)
  .schema("CREATE TABLE test_without_pk (id INTEGER, note STRING);")
)

server = cluster.add(Server("s1", scheduler))
client1 = cluster.add(Client("c1", scheduler))
client2 = cluster.add(Client("c2", scheduler))

cluster.mirror("test_without_pk", client1, server)
cluster.mirror("test_without_pk", client2, server)

# per each peer we run operations in order - they're assumed to be causal
c1ins1 = client1.insertInto("test_without_pk", [0, 'foo'])
c1ins2 = client1.insertInto("test_without_pk", [0, 'foo'])

# but this operation is concurrent to any that happen on client1 or client2
s1ins1 = server.insertInto("test_without_pk", [0, 'foo'])

# and this is concurrent to anything happening on client1 or server
c2ins1 = client2.insertInto("test_without_pk", [0, 'foo'])

# unless we constrain like so:
scheduler.happensBefore(c1ins2, s1ins1)
scheduler.happensBefore(c1ins2, c2ins1)
scheduler.happensBefore(s1ins1, c2ins1)

# check once all tasks have run that the cluster is silent
cluster.isSilent()

# and that all nodes have reached this state
cluster.state("SELECT id, note FROM test_without_pk;").hasRows(
  [0, "foo"],
  colnames=['id', 'note'],
)

asyncio.run(scheduler.run())
