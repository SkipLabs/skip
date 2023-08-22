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
        expect(res).toMatch(/Error: line 1, characters 0-0:Cannot generate a string primary/);
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
    },

  ];
  if (!asWorker) {
    tests.push({
      name: n('Adding a root', asWorker),
      fun: async (skdb) => {
        if (typeof skdb.registerFun == "function") {
          await skdb.sqlRaw(
            'create table if not exists todos (id text primary key, text text, completed integer);'
          );

          const ROOT_ID = 'todosRoot';

          // Make a callable that returns the SQL query string we want to run
          const queryStringCallable = skdb.registerFun(() => `select * from todos`);

          // Make a tracked function which fetches the query string and then runs the query
          const todos = skdb.registerFun(() => {
            const queryString = skdb.trackedCall(queryStringCallable, null);
            return skdb.trackedQuery(queryString);
          });

          // Add a root for the tracked function and get its result
          skdb.addRoot(ROOT_ID, todos, null);
          return skdb.getRoot(ROOT_ID);
        }
        return "[]";
      },
      check: res => {
        expect(res).toEqual("[]");
      }
    });
  };
  return tests;
}
