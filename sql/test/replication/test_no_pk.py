#! /usr/bin/env python3

import scheduling as sched
from model import Topology, Client, Server
from test_runner import run_tests, run_just
import sys

def create_cluster(scheduler):
  cluster = (
    Topology(scheduler)
    .schema("CREATE TABLE test_without_pk (id INTEGER, note TEXT);")
  )
  return cluster


def test_client_server_single_orthogonal_insert_each():
  scheduler = sched.AllTopoSortsScheduler()
  cluster = create_cluster(scheduler)

  server = cluster.add(Server("s1", scheduler))
  client1 = cluster.add(Client("c1", scheduler))

  cluster.mirror("test_without_pk", client1, server)

  client1.insertInto("test_without_pk", [0, 'foo'])
  server.insertInto("test_without_pk", [1, 'bar'])

  # check once all tasks have run that the cluster is silent
  cluster.isSilent()

  # and that all nodes have reached this state
  cluster.state("SELECT id, note FROM test_without_pk;").equals(
    [0, "foo"], [1, "bar"],
    colnames=['id', 'note'],
  )

  return scheduler


def test_two_clients_single_server_two_conflicting_inserts_each():
  scheduler = sched.AllTopoSortsScheduler()
  cluster = create_cluster(scheduler)

  server = cluster.add(Server("s1", scheduler))
  client1 = cluster.add(Client("c1", scheduler))
  client2 = cluster.add(Client("c2", scheduler))

  cluster.mirror("test_without_pk", client1, server)
  cluster.mirror("test_without_pk", client2, server)

  client1.insertInto("test_without_pk", [0, 'foo'])
  server.insertInto("test_without_pk", [0, 'foo'])

  # check once all tasks have run that the cluster is silent
  cluster.isSilent()

  # and that all nodes have reached this state
  cluster.state("SELECT id, note FROM test_without_pk;").equals(
    [0, "foo"], [0, "foo"],
    colnames=['id', 'note'],
  )

  return scheduler


def test_two_clients_single_server_two_conflicting_inserts_with_causality():
  scheduler = sched.AllTopoSortsScheduler(limit=5000)
  cluster = create_cluster(scheduler)

  server = cluster.add(Server("s1", scheduler))
  client1 = cluster.add(Client("c1", scheduler))
  client2 = cluster.add(Client("c2", scheduler))

  cluster.mirror("test_without_pk", client1, server)
  cluster.mirror("test_without_pk", client2, server)

  client1.insertInto("test_without_pk", [0, 'foo'])
  client1.insertInto("test_without_pk", [0, 'foo'])
  server.insertInto("test_without_pk", [0, 'foo'])

  # check once all tasks have run that the cluster is silent
  cluster.isSilent()

  # and that all nodes have reached this state
  cluster.state("SELECT id, note FROM test_without_pk;").equals(
    [0, "foo"], [0, "foo"], [0, "foo"],
    colnames=['id', 'note'],
  )

  return scheduler


def test_two_clients_single_server_single_conflicting_insert_each():
  scheduler = sched.AllTopoSortsScheduler(limit=5000)
  cluster = create_cluster(scheduler)

  server = cluster.add(Server("s1", scheduler))
  client1 = cluster.add(Client("c1", scheduler))
  client2 = cluster.add(Client("c2", scheduler))

  cluster.mirror("test_without_pk", client1, server)
  cluster.mirror("test_without_pk", client2, server)

  client1.insertInto("test_without_pk", [0, 'foo'])
  client2.insertInto("test_without_pk", [0, 'foo'])
  server.insertInto("test_without_pk", [0, 'foo'])

  # check once all tasks have run that the cluster is silent
  cluster.isSilent()

  # and that all nodes have reached this state
  cluster.state("SELECT id, note FROM test_without_pk;").isOneOf(
    [
      [[0, "foo"], [0, "foo"], [0, "foo"]],
      # TODO: this is not desired, and is a design flaw, fixed on the multi-peer branch
      [[0, "foo"], [0, "foo"], [0, "foo"], [0, "foo"]],
    ],
    colnames=['id', 'note'],
  )

  return scheduler


def test_two_clients_single_server_multiple_inserts_on_client1_insert_on_each():
  scheduler = sched.AllTopoSortsScheduler(limit=5000)
  cluster = create_cluster(scheduler)

  server = cluster.add(Server("s1", scheduler))
  client1 = cluster.add(Client("c1", scheduler))
  client2 = cluster.add(Client("c2", scheduler))

  cluster.mirror("test_without_pk", client1, server)
  cluster.mirror("test_without_pk", client2, server)

  client1.insertInto("test_without_pk", [0, 'foo'])
  client1.insertInto("test_without_pk", [0, 'foo'])
  client2.insertInto("test_without_pk", [0, 'foo'])

  # check once all tasks have run that the cluster is silent
  cluster.isSilent()

  # and that all nodes have reached this state
  cluster.state("SELECT id, note FROM test_without_pk;").isOneOf(
    [
      [[0, "foo"], [0, "foo"], [0, "foo"]],
      # TODO: this is not desired, and is a design flaw, fixed on the multi-peer branch
      [[0, "foo"], [0, "foo"], [0, "foo"], [0, "foo"]],
    ],
    colnames=['id', 'note'],
  )

  return scheduler


def test_two_clients_insert_and_delete():
  scheduler = sched.AllTopoSortsScheduler(limit=5000)
  cluster = create_cluster(scheduler)

  server = cluster.add(Server("s1", scheduler))
  client1 = cluster.add(Client("c1", scheduler))
  client2 = cluster.add(Client("c2", scheduler))

  cluster.mirror("test_without_pk", client1, server)
  cluster.mirror("test_without_pk", client2, server)

  insert = client1.insertInto("test_without_pk", [0, 'foo'])
  delete = server.deleteFromWhere("test_without_pk", "id = 0")

  # check once all tasks have run that the cluster is silent
  cluster.isSilent()

  # and that all nodes have reached this state
  cluster.state("SELECT id, note FROM test_without_pk;").match(
    colnames=['id', 'note'],
  ).clause(
    # does s1 see the insert before it does its delete?
    lambda schedule: any(schedule.happensBefore(delivery, delete['s1'][0])
                         for delivery in insert['s1']),
    []
  ).elze(
    [[0, "foo"]]
  )

  return scheduler


# TODO: ignore - no multi-peer yet
def ignore_test_full_mesh_two_conflicting_inserts():
  scheduler = sched.AllTopoSortsScheduler(limit=5000)
  cluster = create_cluster(scheduler)

  server = cluster.add(Server("s1", scheduler))
  client1 = cluster.add(Client("c1", scheduler))
  client2 = cluster.add(Client("c2", scheduler))

  cluster.mirror("test_without_pk", client1, server)
  cluster.mirror("test_without_pk", client2, server)
  cluster.mirror("test_without_pk", client1, client2)

  client1.insertInto("test_without_pk", [0, 'foo'])
  server.insertInto("test_without_pk", [0, 'foo'])

  # check once all tasks have run that the cluster is silent
  cluster.isSilent()

  # and that all nodes have reached this state
  cluster.state("SELECT id, note FROM test_without_pk;").equals(
    [0, "foo"], [0, "foo"],
    colnames=['id', 'note'],
  )

  return scheduler


# TODO: ignore - no multi-peer yet
def ignore_test_full_mesh_with_insert_and_delete():
  scheduler = sched.AllTopoSortsScheduler(limit=5000)
  cluster = create_cluster(scheduler)

  server = cluster.add(Server("s1", scheduler))
  client1 = cluster.add(Client("c1", scheduler))
  client2 = cluster.add(Client("c2", scheduler))

  cluster.mirror("test_without_pk", client1, server)
  cluster.mirror("test_without_pk", client2, server)
  cluster.mirror("test_without_pk", client1, client2)

  insert = client1.insertInto("test_without_pk", [0, 'foo'])
  delete = server.deleteFromWhere("test_without_pk", "id = 0")

  # check once all tasks have run that the cluster is silent
  cluster.isSilent()

  # and that all nodes have reached this state
  cluster.state("SELECT id, note FROM test_without_pk;").match(
    colnames=['id', 'note'],
  ).clause(
    # TODO: make this more readable. the logic: does s1 see the insert
    # before it does its delete?
    lambda schedule: any(schedule.happensBefore(delivery, delete['s1'][0])
                         for delivery in insert['s1']),
    []
  ).elze(
    [[0, "foo"]]
  )

  return scheduler


if __name__ == '__main__':
  run_tests(sys.modules[__name__])
