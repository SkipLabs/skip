import { expect } from '@playwright/test';

function n(name: string, asWorker: boolean) {
  if (asWorker)
    return name + " in Worker";
  return name;
}

export const tests = (asWorker: boolean) => {
  let tests = [
    {
      name: n('Boolean', asWorker),
      fun: async (skdb) => {
        await skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');
        await skdb.sqlRaw('insert into t1 values(TRUE, false);');
        return await skdb.sqlRaw('select true, false, a, b from t1;');
      },
      check: res => {
        expect(res).toEqual("1|0|1|0\n")
      }
    },
    {
      name: n('Create table if not exists', asWorker),
      fun: async (skdb) => {
        await skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');
        await skdb.sqlRaw('create table if not exists t1 (a BOOLEAN, b boolean);');
        return await skdb.sqlRaw('select 1;');
      },
      check: res => {
        expect(res).toEqual("1\n");
      }
    },
    {
      name: n('Primary key', asWorker),
      fun: async (skdb) => {
        return await skdb.sqlRaw('create table t1 (a STRING PRIMARY KEY);');
      },
      check: res => {
        expect(res).toEqual("");
      }
    },
    {
      name: n('Primary key 2', asWorker),
      fun: async (skdb) => {
        await skdb.sqlRaw('create table t1 (a STRING PRIMARY KEY, b INTEGER);');
        try {
          await skdb.sqlRaw('insert into t1 (b) values (22);');
        } catch (e) {
          return (e as Error).message;
        }
      },
      check: res => {
        expect(res).toMatch(/Error: line 1, characters 0-0:\sCannot generate a string primary/);
      }
    },
    {
      name: n('Multiple field updates', asWorker),
      fun: async (skdb) => {
        skdb.sql('create table widgets (id text unique, name text);');
        skdb.sql('INSERT INTO widgets (id, name) VALUES (\'a\', \'gear\');');
        skdb.sql('UPDATE widgets SET id = \'c\', name = \'gear2\';');
        return await skdb.sqlRaw('select * from widgets;');
      },
      check: res => {
        expect(res).toEqual("c|gear2\n");
      }
    },
    {
      name: n('Parse/print float', asWorker),
      fun: async (skdb) => {
        skdb.sql("create table widgets (id text unique , price real not null);");
        skdb.sql("INSERT INTO widgets (id, price) values ('a', 10.0);");
        return await skdb.sqlRaw('select * from widgets');
      },
      check: res => {
        expect(res).toEqual("a|10.0\n");
      }
    },
    {
      name: n('Virtual view if not exists', asWorker),
      fun: async (skdb) => {
        await skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');
        await skdb.sqlRaw('create virtual view v1 as select * from t1;');
        await skdb.sqlRaw('create virtual view if not exists v1 as select * from t1;');
        return await skdb.sqlRaw('select 1;');
      },
      check: res => {
        expect(res).toEqual("1\n");
      }
    },
    {
      name: n('View if not exists', asWorker),
      fun: async (skdb) => {
        await skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');
        await skdb.sqlRaw('create view v1 as select * from t1;');
        await skdb.sqlRaw('create view if not exists v1 as select * from t1;');
        return await skdb.sqlRaw('select 1;');
      },
      check: res => {
        expect(res).toEqual("1\n");
      }
    },
    // TODO: uncomment this once we have errors propagated back to the JS
    // NOTE: This test is currently failing because 'table `t1` does not
    // exist' is not being returned in the result (probably being
    // printed on stderr).
    // {
    //     name: 'Error memory',
    //     fun: async (skdb) => {
    //         let res = 0;
    //         for(let i = 0; i < 10000; i++) {
    //             let queryRes = await skdb.sqlRaw('select * from t1;');
    //             if (queryRes.includes('does not exist')) {
    //                 res += 1;
    //             }
    //         }
    //         return res;
    //     },
    //     check: res => {
    //         expect(res).toEqual(10000);
    //     }
    // },
    {
      name: n('Column casting', asWorker),
      fun: async (skdb) => {
        await skdb.sql('create table t1 (aBc INTEGER)');
        await skdb.insert('t1', [11]);
        return await skdb.sql('select * from t1');
      },
      check: res => {
        expect(res).toEqual([{ aBc: 11 }]);
      }
    },
    {
      name: n('Limit', asWorker),
      fun: async (skdb) => {
        await skdb.sql('create table t1 (aBc INTEGER)');
        await skdb.insert('t1', [11]);
        await skdb.insert('t1', [12]);
        await skdb.insert('t1', [13]);
        return await skdb.sql('select * from t1 limit 1');
      },
      check: res => {
        expect(res).toEqual([{ aBc: 11 }]);
      }
    }, {
      name: n('Params 1', asWorker),
      fun: async (skdb) => {
        await skdb.sql('CREATE TABLE t1 (a INTEGER);');
        await skdb.sql('INSERT INTO t1 VALUES (@key);', new Map().set("key", 13));
        return skdb.sqlRaw('SELECT * FROM t1;');
      },
      check: res => {
        expect(res).toEqual("13\n");
      }
    }, {
      name: n('Params as object', asWorker),
      fun: async (skdb) => {
        await skdb.sql('CREATE TABLE t1 (a INTEGER);');
        await skdb.sql('INSERT INTO t1 VALUES (@key);', { key: 13 });
        return skdb.sqlRaw('SELECT * FROM t1;');
      },
      check: res => {
        expect(res).toEqual("13\n");
      }
    }, {
      name: n('Params 2', asWorker),
      fun: async (skdb) => {
        await skdb.sql('CREATE TABLE t1 (a INTEGER, b INTEGER, c INTEGER);');
        await skdb.insert('t1', [13, 9, 42])
        return skdb.sqlRaw('SELECT * FROM t1;');
      },
      check: res => {
        expect(res).toEqual("13|9|42\n");
      }
    }
  ];
  if (!asWorker) {
    [{
      name: 'Integer root is computed',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists todos (id integer primary key, text text, completed integer);'
        );
        await skdb.sqlRaw(
          "insert into todos values (0, 'foo', 0);"
        );
        const ROOT_ID = 'app';

        const todos = skdb.registerFun(() => {
          let results = skdb.trackedQuery("select id from todos where id = 0");
          return results[0].id
        });

        skdb.addRoot(ROOT_ID, todos, null);
        return skdb.getRoot(ROOT_ID);
      },
      check: res => {
        expect(res).toEqual(0);
      }
    }, {
      name: 'String root is computed',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists todos (id integer primary key, text text, completed integer);'
        );
        await skdb.sqlRaw(
          "insert into todos values (0, 'foo', 0);"
        );
        const ROOT_ID = 'app';

        const todos = skdb.registerFun(() => {
          let results = skdb.trackedQuery("select text from todos where id = 0");
          return results[0].text
        });

        skdb.addRoot(ROOT_ID, todos, null);
        return skdb.getRoot(ROOT_ID);
      },
      check: res => {
        expect(res).toEqual("foo");
      }
    }, {
      name: 'Composite root is computed',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists todos (id integer primary key, text text, completed integer);'
        );
        await skdb.sqlRaw(
          "insert into todos values (0, 'foo', 0);"
        );
        const ROOT_ID = 'app';

        const todos = skdb.registerFun(() => {
          let results = skdb.trackedQuery("select text from todos where id = 0");
          return { text: results[0].text }
        });

        skdb.addRoot(ROOT_ID, todos, null);
        return skdb.getRoot(ROOT_ID);
      },
      check: res => {
        expect(res).toEqual({ text: "foo" });
      }
    }, {
      name: 'Multiple roots',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists todos (id integer primary key, text text, completed integer);'
        );
        await skdb.sqlRaw("insert into todos values (0, 'foo', 0);");
        await skdb.sqlRaw("insert into todos values (1, 'bar', 1);");

        const foo = skdb.registerFun(() => {
          let results = skdb.trackedQuery("select text from todos where id = 0");
          return results[0].text
        });
        const bar = skdb.registerFun(() => {
          let results = skdb.trackedQuery("select text from todos where id = 1");
          return results[0].text
        });

        skdb.addRoot("foo", foo);
        skdb.addRoot("bar", bar);
        return [skdb.getRoot("foo"), skdb.getRoot("bar")];
      },
      check: res => {
        expect(res).toEqual(["foo", "bar"]);
      }
    }, {
      name: 'Remove root',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists todos (id integer primary key, text text, completed integer);'
        );
        await skdb.sqlRaw("insert into todos values (0, 'foo', 1);");

        const foo = skdb.registerFun(() => {
          let results = skdb.trackedQuery("select text from todos where id = 0");
          return results[0].text
        });

        skdb.addRoot("foo", foo);
        const root = skdb.getRoot("foo");
        skdb.removeRoot("foo");
        const rootAfterRemove = skdb.getRoot("foo");
        return [root, rootAfterRemove];
      },
      check: res => {
        expect(res).toEqual(["foo", undefined]);
      }
    }, {
      name: 'Registered function called only when tracked query changes',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists todos (id integer primary key, text text, completed integer);'
        );
        await skdb.sqlRaw("insert into todos values (0, 'foo', 0);");

        const ROOT_ID = 'app';

        let counter = 0;

        const todos = skdb.registerFun(() => {
          let results = skdb.trackedQuery("select text from todos where id < 10");
          counter = counter + 1;
          return {
            text: results[0].text,
          }
        });

        skdb.addRoot(ROOT_ID, todos, null);
        await skdb.sqlRaw("insert into todos values (11, 'bar', 1);")
        await skdb.sqlRaw("update todos set text = 'baz' where id = 11;");

        await skdb.sqlRaw("insert into todos values (1, 'bar', 1);")
        await skdb.sqlRaw("update todos set text = 'baz' where id = 0;");
        await skdb.sqlRaw("update todos set text = 'quux';");

        return counter;
      },
      check: res => {
        expect(res).toEqual(4);   // once for initial, insert, and then two updates
      }
    }, {
      name: 'Registered function called only when complex tracked query changes',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists todos (id integer primary key, text text, completed integer);'
        );
        await skdb.sqlRaw("insert into todos values (0, 'foo', 0);");
        await skdb.sqlRaw("insert into todos values (1, 'foo', 0);");
        await skdb.sqlRaw("insert into todos values (2, 'foo', 1);");
        await skdb.sqlRaw("insert into todos values (3, 'foo', 0);");

        const ROOT_ID = 'app';

        let counter = 0;

        const todos = skdb.registerFun(() => {
          let results = skdb.trackedQuery("select completed, count(*) as n from (select * from todos where id > 0) group by completed");
          counter = counter + 1;
          const acc = {}
          for (const row of results) {
            acc[row.completed] = row.n
          }
          return acc
        });

        skdb.addRoot(ROOT_ID, todos, null);

        await skdb.sqlRaw("insert into todos values (4, 'foo', 1);");
        await skdb.sqlRaw("update todos set text = 'baz' where id = 0;");

        return [counter, skdb.getRoot(ROOT_ID)];
      },
      check: res => {
        expect(res).toEqual([2, { 0: 2, 1: 2 }]);
      }
    }, {
      name: 'onRootChange called when root changes',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists todos (id integer primary key, text text, completed integer);'
        );
        await skdb.sqlRaw("insert into todos values (0, 'foo', 0);");

        const ROOT_ID = 'app';

        const todos = skdb.registerFun(() => {
          let results = skdb.trackedQuery("select text from todos where id = 0");
          return { text: results[0].text }
        });

        skdb.addRoot(ROOT_ID, todos, null);

        let counter = 0;
        skdb.onRootChange((rootName) => {
          if (rootName == ROOT_ID) {
            counter = counter + 1
          }
        });

        // no change
        const counterBefore = counter;
        await skdb.sqlRaw([
          "insert into todos values (1, 'bar', 1);",
          "update todos set text = 'baz' where id = 1;"
        ].join("\n"))
        const counterAfterNoOp = counter;
        // change
        await skdb.sqlRaw([
          "update todos set text = 'baz' where id = 0;",
          "update todos set text = 'quux';"
        ].join("\n"));

        return [counterBefore, counterAfterNoOp, counter];
      },
      check: res => {
        expect(res).toEqual([0, 0, 2]);
      }
    }, {
      name: 'A root can be updated/re-rendered with a new argument',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists todos (id integer primary key, text text, completed integer);'
        );
        await skdb.sqlRaw("insert into todos values (0, 'foo', 0), (1, 'bar', 0);");
        const ROOT_ID = 'app';

        const todos = skdb.registerFun((id) => {
          let results = skdb.trackedQuery(`select text from todos where id = ${id}`);
          return {
            text: results[0].text,
          }
        });

        skdb.addRoot(ROOT_ID, todos, 0);

        let counter = 0;
        skdb.onRootChange((_rootName) => {
          counter = counter + 1;
        });

        const startCounter = counter;
        const valueBefore = skdb.getRoot(ROOT_ID);
        skdb.addRoot(ROOT_ID, todos, 1);
        const valueAfter = skdb.getRoot(ROOT_ID);
        const counterAfterRootChange = counter;

        // change
        await skdb.sqlRaw("update todos set text = 'quux' where id = 1;");
        const counterAfterChange = counter;

        // would have updated the old root but not the new
        await skdb.sqlRaw(
          [
            "update todos set text = 'baz' where id = 0;",
            "update todos set text = 'xyz' where id = 0;"
          ].join("\n")
        );

        return [
          startCounter, counterAfterRootChange,
          valueBefore, valueAfter,
          skdb.getRoot(ROOT_ID),
          counterAfterChange, counter,
        ];
      },
      check: res => {
        expect(res).toEqual([
          0,                      // no executions, no changes yet
          1,                      // root changed, because we updated it
          { text: "foo" },          // initial value
          { text: "bar" },          // after we change the arg
          { text: "quux" },         // after we update the row the value changes
          2,                      // change to the root so this bumps
          // TODO: this should be 2. we wrongly trigger an update on the
          // js subscription on the first update to the old value, but
          // no more after that.
          3,                      // not tracking the id=0 so this does not bump
        ]);
      }
    }, {
      name: 'Tracked calls allow composing views made of tracked queries',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists todos (id integer primary key, text text, completed integer);'
        );

        await skdb.sqlRaw([
          "insert into todos values (0, 'foo', 0);",
          "insert into todos values (1, 'bar', 1);",
          "insert into todos values (2, 'baz', 0);"
        ].join("\n"))

        let todoTextInvocations = 0;
        const todoText = skdb.registerFun((id: number) => {
          todoTextInvocations = todoTextInvocations + 1;
          let results = skdb.trackedQuery(`select text from todos where id = ${id}`);
          return { text: results[0].text }
        });

        let uncompletedTodosInvocations = 0;
        // somewhat convoluted example of view logic composition
        let uncompletedTodos = skdb.registerFun(() => {
          uncompletedTodosInvocations = uncompletedTodosInvocations + 1;
          const ids = skdb.trackedQuery("select id from todos where completed = 0")
          const acc: Array<string> = [];
          for (const id of ids.map(x => x.id)) {
            const t = skdb.trackedCall(todoText, id);
            acc.push(t.text);
          }
          return acc;
        });

        const beforeRoot = [todoTextInvocations, uncompletedTodosInvocations];
        skdb.addRoot("uncompleted", uncompletedTodos);
        const afterRoot = [todoTextInvocations, uncompletedTodosInvocations];

        // no invocations
        await skdb.sqlRaw([
          "insert into todos values (3, 'bar', 1);",
          "update todos set text = 'quux' where id = 1;"
        ].join("\n"))

        const afterBenign = [todoTextInvocations, uncompletedTodosInvocations];

        // only need to re-call one tracked query
        await skdb.sqlRaw("insert into todos values (4, 'new', 0);")
        const afterInsert = [todoTextInvocations, uncompletedTodosInvocations];

        // delete
        await skdb.sqlRaw("delete from todos where id = 0;")
        const afterDelete = [todoTextInvocations, uncompletedTodosInvocations];

        // everything updated (2 rows)
        await skdb.sqlRaw("update todos set text = 'update' where completed = 0");
        const afterUpdate = [todoTextInvocations, uncompletedTodosInvocations];

        const root = skdb.getRoot("uncompleted");

        return [
          beforeRoot, afterRoot, afterBenign, afterInsert,
          afterDelete, afterUpdate, root
        ];
      },
      check: res => {
        expect(res).toEqual([
          [0, 0],                 // no calls yet, definitions don't get run eagerly
          [2, 1],                 // initial state built as now added to root
          [2, 1],                 // no change as these mutations didn't touch interesting rows
          [3, 2],                 // one new row, so one tracked query to execute and cascade up for the select id
          [3, 4],                 // one less row, so tracked call twice (once for select id and once for the row select)
          // TODO: this is currently quadratic behaviour. on updating 2
          // rows, uncompletedTodos is called for each - which is fine - this
          // calls the trackedCall for each row. but these are not
          // cached as they should be and the trackedCall's query is
          // re-run for each invocation. the following should be [5,6]
          // not [6,6].
          [6, 6],                 // 2 rows changed, so tracked call twice for each, tracked query 3 times??
          ["update", "update"]]);
      }
    }, {
      name: 'Tracked queries support params',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists test (x integer primary key, y string, z float, w integer);'
        );
        await skdb.sqlRaw(
          "insert into test values (0, 'foo', 1.2, 42);"
        );
        const ROOT_ID = 'app';
        let count = 0;
        const todos = skdb.registerFun(() => {
          let r = skdb.trackedQuery(
            "select w from test where x = @x and y = @y and z = @zed",
            new Map<string, string | number>([["x", 0], ["y", "foo"], ["zed", 1.2]]),
          )
          return r;
        });

        skdb.addRoot(ROOT_ID, todos, null);
        count++;
        // check the root gets reactively updated
        await skdb.sqlRaw("update test set w = 21 where y = 'foo';");

        return skdb.getRoot(ROOT_ID);
      },
      check: res => {
        expect(res).toEqual([{ w: 21 }]);
      }
    }, 
    {
      name: 'Tracked queries support object params',
      fun: async (skdb) => {
        await skdb.sqlRaw(
          'create table if not exists test (x integer primary key, y string, z float, w integer);'
        );
        await skdb.sqlRaw(
          "insert into test values (0, 'foo', 1.2, 42);"
        );
        const ROOT_ID = 'app';

        const todos = skdb.registerFun(() => {
          return skdb.trackedQuery(
            "select w from test where x = @x and y = @y and z = @zed",
            { x: 0, y: 'foo', zed: 1.2 }
          );
        });

        skdb.addRoot(ROOT_ID, todos, null);

        // check the root gets reactively updated
        await skdb.sqlRaw("update test set w = 21 where y = 'foo';");

        return skdb.getRoot(ROOT_ID);
      },
      check: res => {
        expect(res).toEqual([{ w: 21 }]);
      }
    }
    ].forEach(item => tests.push(item as any));
  };
  return tests;
}
