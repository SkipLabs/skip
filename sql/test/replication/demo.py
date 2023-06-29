import scheduling as sched
from model import Topology, Client, Server

scheduler = sched.ArbitraryTopoSortScheduler()

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
