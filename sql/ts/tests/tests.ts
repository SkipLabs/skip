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
        await skdb.exec('create table t1 (a BOOLEAN, b boolean);');
        await skdb.exec('insert into t1 values(TRUE, false);');
        return await skdb.exec('select true, false, a, b from t1;');
      },
      check: res => {
        expect(res).toEqual([{"a": 1, "b": 0, "col<0>": 1, "col<1>": 0}])
      }
    },
    {
      name: n('Create table if not exists', asWorker),
      fun: async (skdb) => {
        await skdb.exec('create table t1 (a BOOLEAN, b boolean);');
        await skdb.exec('create table if not exists t1 (a BOOLEAN, b boolean);');
        return await skdb.exec('select 1;');
      },
      check: res => {
        expect(res).toEqual([{"col<0>": 1}]);
      }
    },
    {
      name: n('Primary key', asWorker),
      fun: async (skdb) => {
        return await skdb.exec('create table t1 (a STRING PRIMARY KEY);');
      },
      check: res => {
        expect(res).toEqual([]);
      }
    },
    {
      name: n('Primary key 2', asWorker),
      fun: async (skdb) => {
        await skdb.exec('create table t1 (a STRING PRIMARY KEY, b INTEGER);');
        try {
          await skdb.exec('insert into t1 (b) values (22);');
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
        await skdb.exec('create table widgets (id text unique, name text);');
        await skdb.exec('INSERT INTO widgets (id, name) VALUES (\'a\', \'gear\');');
        await skdb.exec('UPDATE widgets SET id = \'c\', name = \'gear2\';');
        return await skdb.exec('select * from widgets;');
      },
      check: res => {
        expect(res).toEqual([{"id": "c", "name": "gear2"}]);
      }
    },
    {
      name: n('Parse/print float', asWorker),
      fun: async (skdb) => {
        skdb.exec("create table widgets (id text unique , price real not null);");
        skdb.exec("INSERT INTO widgets (id, price) values ('a', 10.0);");
        return await skdb.exec('select * from widgets');
      },
      check: res => {
        expect(res).toEqual([{"id": "a", "price": 10}]);
      }
    },
    {
      name: n('Virtual view if not exists', asWorker),
      fun: async (skdb) => {
        await skdb.exec('create table t1 (a BOOLEAN, b boolean);');
        await skdb.exec('create virtual view v1 as select * from t1;');
        await skdb.exec('create virtual view if not exists v1 as select * from t1;');
        return await skdb.exec('select 1;');
      },
      check: res => {
        expect(res).toEqual([{"col<0>": 1}]);
      }
    },
    {
      name: n('View if not exists', asWorker),
      fun: async (skdb) => {
        await skdb.exec('create table t1 (a BOOLEAN, b boolean);');
        await skdb.exec('create view v1 as select * from t1;');
        await skdb.exec('create view if not exists v1 as select * from t1;');
        return await skdb.exec('select 1;');
      },
      check: res => {
        expect(res).toEqual([{"col<0>": 1}]);
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
    //             let queryRes = await skdb.exec('select * from t1;');
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
        await skdb.exec('create table t1 (aBc INTEGER)');
        await skdb.insert('t1', [11]);
        return await skdb.exec('select * from t1');
      },
      check: res => {
        expect(res).toEqual([{ aBc: 11 }]);
      }
    },
    {
      name: n('Limit', asWorker),
      fun: async (skdb) => {
        await skdb.exec('create table t1 (aBc INTEGER)');
        await skdb.insert('t1', [11]);
        await skdb.insert('t1', [12]);
        await skdb.insert('t1', [13]);
        return await skdb.exec('select * from t1 limit 1');
      },
      check: res => {
        expect(res).toEqual([{ aBc: 11 }]);
      }
    }, {
      name: n('Params 1', asWorker),
      fun: async (skdb) => {
        await skdb.exec('CREATE TABLE t1 (a INTEGER);');
        await skdb.exec('INSERT INTO t1 VALUES (@key);', new Map().set("key", 13));
        return skdb.exec('SELECT * FROM t1;');
      },
      check: res => {
        expect(res).toEqual([{ "a": 13 }]);
      }
    }, {
      name: n('Params as object', asWorker),
      fun: async (skdb) => {
        await skdb.exec('CREATE TABLE t1 (a INTEGER);');
        await skdb.exec('INSERT INTO t1 VALUES (@key);', { key: 13 });
        return skdb.exec('SELECT * FROM t1;');
      },
      check: res => {
        expect(res).toEqual([{ "a": 13 }]);
      }
    }, {
      name: n('Params 2', asWorker),
      fun: async (skdb) => {
        await skdb.exec('CREATE TABLE t1 (a INTEGER, b INTEGER, c INTEGER);');
        await skdb.insert('t1', [13, 9, 42])
        return skdb.exec('SELECT * FROM t1;');
      },
      check: res => {
        expect(res).toEqual([{ "a": 13, "b": 9, "c": 42 }]);
      }
    }
  ];
  return tests;
}
