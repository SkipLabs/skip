import { expect } from '@playwright/test';
import { SKDB } from 'skdb';

function n(name: string, asWorker: boolean) {
  if (asWorker)
    return name + " in Worker";
  return name;
}

export const tests = (asWorker: boolean) => {
  let tests = [
    {
      name: n('Boolean', asWorker),
      fun: async (skdb: SKDB) => {
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
      fun: async (skdb: SKDB) => {
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
      fun: async (skdb: SKDB) => {
        return await skdb.exec('create table t1 (a STRING PRIMARY KEY);');
      },
      check: res => {
        expect(res).toEqual([]);
      }
    },
    {
      name: n('Primary key 2', asWorker),
      fun: async (skdb: SKDB) => {
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
      fun: async (skdb: SKDB) => {
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
      fun: async (skdb: SKDB) => {
        await skdb.exec("create table widgets (id text unique , price real not null);");
        await skdb.exec("INSERT INTO widgets (id, price) values ('a', 10.0);");
        return await skdb.exec('select * from widgets');
      },
      check: res => {
        expect(res).toEqual([{"id": "a", "price": 10}]);
      }
    },
    {
      name: n('Virtual view if not exists', asWorker),
      fun: async (skdb: SKDB) => {
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
      fun: async (skdb: SKDB) => {
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
    //     fun: async (skdb: SKDB) => {
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
      fun: async (skdb: SKDB) => {
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
      fun: async (skdb: SKDB) => {
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
      fun: async (skdb: SKDB) => {
        await skdb.exec('CREATE TABLE t1 (a INTEGER);');
        await skdb.exec('INSERT INTO t1 VALUES (@key);', new Map().set("key", 13));
        return skdb.exec('SELECT * FROM t1;');
      },
      check: res => {
        expect(res).toEqual([{ "a": 13 }]);
      }
    }, {
      name: n('Params as object', asWorker),
      fun: async (skdb: SKDB) => {
        await skdb.exec('CREATE TABLE t1 (a INTEGER);');
        await skdb.exec('INSERT INTO t1 VALUES (@key);', { key: 13 });
        return skdb.exec('SELECT * FROM t1;');
      },
      check: res => {
        expect(res).toEqual([{ "a": 13 }]);
      }
    }, {
      name: n('Params 2', asWorker),
      fun: async (skdb: SKDB) => {
        await skdb.exec('CREATE TABLE t1 (a INTEGER, b INTEGER, c INTEGER);');
        await skdb.insert('t1', [13, 9, 42])
        return skdb.exec('SELECT * FROM t1;');
      },
      check: res => {
        expect(res).toEqual([{ "a": 13, "b": 9, "c": 42 }]);
      }
    },
    {
      name: n('Test reactive query updated on insert and then closed', asWorker),
      fun: async (skdb: SKDB) => {
        await skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
        await skdb.insert('t1', [13, "9", 42.1]);
        let result: Array<any> = [];
        let handle = await skdb.watch('SELECT * FROM t1;', {}, (changes: Array<any>) => result.push(changes));
        await skdb.insert('t1', [14, "bar", 44.5]);
        await handle.close();
        await skdb.insert('t1', [15, "foo", 46.8]);
        return result;
      },
      check: res => {
        let expected = [
          [
            {"a": 13, "b": "9", "c": 42.1}
          ],
          [
            {"a": 13, "b": "9", "c": 42.1},
            {"a": 14, "b": "bar", "c": 44.5}
          ]
        ];
        expect(res).toEqual(expected);
      }
    },
    {
      name: n('Test reactive query updated on update and then closed', asWorker),
      fun: async (skdb: SKDB) => {
        await skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
        await skdb.insert('t1', [13, "9", 42.1]);
        let result: Array<any> = [];
        let handle = await skdb.watch('SELECT * FROM t1;', {}, (changes: Array<any>) => result.push(changes));
        await skdb.exec("update t1 set b = 'foo' where a = 13")
        await handle.close();
        await skdb.exec("update t1 set b = 'bar' where a = 13")
        return result;
      },
      check: res => {
        expect(res).toEqual(
          [
            [
              {"a": 13, "b": "9", "c": 42.1}
            ],
            [
              {"a": 13, "b": "foo", "c": 42.1},
            ],
          ]
        );
      }
    },
    {
      name: n('Test reactive query updated on delete and then closed', asWorker),
      fun: async (skdb: SKDB) => {
        await skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
        await skdb.insert('t1', [13, "9", 42.1]);
        await skdb.insert('t1', [14, "9", 42.1]);
        let result: Array<any> = [];
        let handle = await skdb.watch('SELECT * FROM t1;', {}, (changes: Array<any>) => result.push(changes));
        await skdb.exec("delete from t1 where a = 13");
        await handle.close();
        await skdb.exec("delete from t1 where a = 14");
        return result;
      },
      check: res => {
        expect(res).toEqual(
          [
            [
              {"a": 13, "b": "9", "c": 42.1},
              {"a": 14, "b": "9", "c": 42.1}
            ],
            [
              {"a": 14, "b": "9", "c": 42.1}
            ]
          ]
        );
      }
    },
    {
      name: n('Test reactive query is not n^2', asWorker),
      fun: async (skdb: SKDB) => {
        await skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
        await skdb.insert('t1', [13, "9", 42.1]);
        await skdb.insert('t1', [14, "9", 42.1]);
        await skdb.insert('t1', [15, "9", 42.1]);
        await skdb.insert('t1', [16, "9", 42.1]);
        let result: Array<any> = [];
        let handle = await skdb.watch('SELECT * FROM t1 WHERE a > 13;', {}, (changes: Array<any>) => result.push(changes));
        // update all 4 rows. we're checking this doesn't result in 16
        // objects built in js.
        await skdb.exec("update t1 set b = 'foo';")
        await handle.close();
        await skdb.exec("update t1 set b = 'bar';")
        return result;
      },
      check: res => {
        expect(res).toEqual(
          [
            [
              {"a": 14, "b": "9", "c": 42.1},
              {"a": 15, "b": "9", "c": 42.1},
              {"a": 16, "b": "9", "c": 42.1},
            ],
            [
              {"a": 14, "b": "foo", "c": 42.1},
              {"a": 15, "b": "foo", "c": 42.1},
              {"a": 16, "b": "foo", "c": 42.1},
            ],
          ]
        );
      }
    },
    ,
  {
    name: n('Test filtering reactive query updated on insert and then closed', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec('CREATE TABLE t1 (a INTEGER, b INTEGER, c INTEGER);');
      await skdb.insert('t1', [13, 9, 42]);
      let result: Array<any> = [];
      let handle = await skdb.watch('SELECT * FROM t1 where a = 13 or a = 14;', {}, (changes) => {
        result.push(changes);
      });
      await skdb.insert('t1', [14, 9, 44]);
      await handle.close();
      return result;
    },
    check: res => {
      expect(res).toEqual(
        [
          [
            {"a": 13, "b": 9, "c": 42}
          ],
          [
            {"a": 13, "b": 9, "c": 42},
            {"a": 14, "b": 9, "c": 44}
          ]
        ]
      );
    }
  },
  {
    name: n('Test filtering reactive query updated on update and then closed', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      await skdb.insert('t1', [13, "9", 42.1]);
      let result: Array<any> = [];
      let handle = await skdb.watch('SELECT * FROM t1 where a = 13 or a = 14;', {}, (changes) => {
        result.push(changes);
      });
      await skdb.exec("update t1 set b = 'foo' where a = 13")
      await handle.close();
      await skdb.exec("update t1 set b = 'bar' where a = 13")
      return result;
    },
    check: res => {
      expect(res).toEqual(
        [
          [
            {"a": 13, "b": "9", "c": 42.1}
          ],
          [
            {"a": 13, "b": "foo", "c": 42.1},
          ],
        ]
      );
    }
  },
  {
    name: n('Test filtering reactive query updated on delete and then closed', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      await skdb.insert('t1', [13, "9", 42.1]);
      await skdb.insert('t1', [14, "9", 42.1]);
      let result: Array<any> = [];
      let handle = await skdb.watch('SELECT * FROM t1 where a = 13 or a = 14;', {}, (changes) => {
        result.push(changes);
      });
      await skdb.exec("delete from t1 where a = 13");
      await handle.close();
      await skdb.exec("delete from t1 where a = 14");
      return result;
    },
    check: res => {
      expect(res).toEqual(
        [
          [
            {"a": 13, "b": "9", "c": 42.1},
            {"a": 14, "b": "9", "c": 42.1}
          ],
          [
            {"a": 14, "b": "9", "c": 42.1}
          ]
        ]
      );
    }
  },
  {
    name: n('Complex reactive query updated on insert, update, delete, then closed', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      await skdb.exec([
        "insert into todos values (0, 'foo', 0);",
        "insert into todos values (1, 'foo', 0);",
        "insert into todos values (2, 'foo', 1);",
        "insert into todos values (3, 'foo', 0);"
      ].join("\n"));
      let result: Array<any> = [];
      let handle = await skdb.watch(
        'select completed, count(*) as n from (select * from todos where id > 0) group by completed',
        {}, (changes) => {
        result.push(changes);
      });

      await skdb.exec("insert into todos values (4, 'foo', 1);");
      await skdb.exec("update todos set text = 'baz' where id = 0;");

      await handle.close();
      return result
    },
    check: res => {
      expect(res).toEqual(
        [
          [{completed: 0, n: 2}, {completed: 1, n: 1}],
          [{completed: 0, n: 2}, {completed: 1, n: 2}],
        ]
      );
    }
  },
  {
    name: n('Reactive queries support params', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec([
        'create table if not exists test (x integer primary key, y string, z float, w integer);',
        "insert into test values (0, 'foo', 1.2, 42);"
      ].join("\n"));
      let result: Array<any> = [];
      let handle = await skdb.watch(
        "select w from test where x = @x and y = @y and z = @zed",
        new Map<string, string|number>([["x", 0], ["y", "foo"], ["zed", 1.2]]),
        (changes) => {
        result.push(changes);
      });
      await skdb.exec("update test set w = 21 where y = 'foo';");
      await handle.close();
      return result
    },
    check: res => {
      expect(res).toEqual([
        [{w:42}],
        [{w:21}],
      ]);
    }
  },
  {
    name: n('Reactive queries support object params', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec([
        'create table if not exists test (x integer primary key, y string, z float, w integer);',
        "insert into test values (0, 'foo', 1.2, 42);"
      ].join("\n"));
      let result: Array<any> = [];
      let handle = await skdb.watch(
        "select w from test where x = @x and y = @y and z = @zed",
        {x: 0, y: 'foo', zed: 1.2},
        (changes) => {
        result.push(changes);
      });
      await skdb.exec("update test set w = 21 where y = 'foo';");
      await handle.close();
      return result
    },
    check: res => {
      expect(res).toEqual([
        [{w:42}],
        [{w:21}],
      ]);
    }
  },
  {
    name: n('A reactive query can be updated with new spliced arguments', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      await skdb.insert('t1', [13, "9", 42.1]);
      let result: Array<any> = [];
      let handle = await skdb.watch('SELECT * FROM t1 where a = 13;', {}, (changes) => {
        result.push(changes);
      });
      await skdb.insert('t1', [14, "bar", 44.5]);
      await handle.close();
      handle = await skdb.watch('SELECT * FROM t1 where a = 14;', {}, (changes) => {
        result.push(changes);
      });
      await skdb.insert('t1', [15, "foo", 46.8]);
      await handle.close();
      return result;
    },
    check: res => {
      expect(res).toEqual(
        [
          [
            {"a": 13, "b": "9", "c": 42.1}
          ],
          [
            {"a": 14, "b": "bar", "c": 44.5}
          ]
        ]
      );
    }
  },
  {
    name: n('A reactive query can be replaced with new params', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      await skdb.insert('t1', [13, "9", 42.1]);
      let result: Array<any> = [];
      let handle = await skdb.watch('SELECT * FROM t1 where a = @a;', {a: 13}, (changes) => {
        result.push(changes);
      });
      await skdb.insert('t1', [14, "bar", 44.5]);
      await handle.close();
      handle = await skdb.watch('SELECT * FROM t1 where a = @a;', {a: 14}, (changes) => {
        result.push(changes);
      });
      await skdb.insert('t1', [15, "foo", 46.8]);
      await handle.close();
      return result;
    },
    check: res => {
      expect(res).toEqual(
        [
          [
            {"a": 13, "b": "9", "c": 42.1}
          ],
          [
            {"a": 14, "b": "bar", "c": 44.5}
          ]
        ]
      );
    }
  },
  {
    name: n('Concurrent non-overlapping reactive queries can co-exist', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec([
        'CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);',
        'CREATE TABLE t2 (a INTEGER, b STRING, c FLOAT);'
      ].join("\n"));
      await skdb.insert('t1', [13, "9", 42.1]);
      await skdb.insert('t2', [13, "9", 42.1]);

      let result1: Array<any> = [];
      let result2: Array<any> = [];

      let handle1 = await skdb.watch('SELECT * FROM t1 where a = @a;', {a: 13}, (changes) => {
        result1.push(changes);
      });
      let handle2 = await skdb.watch('SELECT * FROM t2 where a = @a;', {a: 13}, (changes) => {
        result2.push(changes);
      });

      await skdb.exec("update t1 set b = 'foo';");
      await skdb.exec("update t2 set b = 'bar';");

      await handle1.close();
      await handle2.close();

      return [result1, result2];
    },
    check: res => {
      expect(res).toEqual(
        [
          [
            [
              {"a": 13, "b": "9", "c": 42.1}
            ],
            [
              {"a": 13, "b": "foo", "c": 42.1}
            ],
          ],
          [
            [
              {"a": 13, "b": "9", "c": 42.1}
            ],
            [
              {"a": 13, "b": "bar", "c": 42.1}
            ],
          ]
        ]
      );
    }
  },
  {
    name: n('Concurrent non-overlapping (same table) reactive queries can co-exist', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      await skdb.insert('t1', [13, "9", 42.1]);
      await skdb.insert('t1', [15, "9", 42.1]);

      let result1: Array<any> = [];
      let result2: Array<any> = [];

      let handle1 = await skdb.watch('SELECT * FROM t1 where a < @a;', {a: 15}, (changes) => {
        result1.push(changes);
      });
      let handle2 = await skdb.watch('SELECT * FROM t1 where a > @a;', {a: 13}, (changes) => {
        result2.push(changes);
      });

      await skdb.exec("update t1 set b = 'foo';");

      await handle1.close();
      await handle2.close();

      return [result1, result2];
    },
    check: res => {
      expect(res).toEqual(
        [
          [
            [
              {"a": 13, "b": "9", "c": 42.1},
            ],
            [
              {"a": 13, "b": "foo", "c": 42.1},
            ],
          ],
          [
            [
              {"a": 15, "b": "9", "c": 42.1},
            ],
            [
              {"a": 15, "b": "foo", "c": 42.1},
            ],
          ]
        ]
      );
    }
  },
  {
    name: n('Concurrent overlapping reactive queries can co-exist', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      await skdb.insert('t1', [13, "9", 42.1]);
      await skdb.insert('t1', [14, "9", 42.1]);
      await skdb.insert('t1', [15, "9", 42.1]);

      let result1: Array<any> = [];
      let result2: Array<any> = [];

      let handle1 = await skdb.watch('SELECT * FROM t1 where a < @a;', {a: 15}, (changes) => {
        result1.push(changes);
      });
      let handle2 = await skdb.watch('SELECT * FROM t1 where a > @a;', {a: 13}, (changes) => {
        result2.push(changes);
      });

      await skdb.exec("update t1 set b = 'foo';");

      await handle1.close();
      await handle2.close();

      return [result1, result2];
    },
    check: res => {
      expect(res).toEqual(
        [
          [
            [
              {"a": 13, "b": "9", "c": 42.1},
              {"a": 14, "b": "9", "c": 42.1}
            ],
            [
              {"a": 13, "b": "foo", "c": 42.1},
              {"a": 14, "b": "foo", "c": 42.1}
            ],
          ],
          [
            [
              {"a": 14, "b": "9", "c": 42.1},
              {"a": 15, "b": "9", "c": 42.1},
            ],
            [
              {"a": 14, "b": "foo", "c": 42.1},
              {"a": 15, "b": "foo", "c": 42.1},
            ],
          ]
        ]
      );
    }
  },
  {
    name: n('Schema for all', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec('create table t1 (a BOOLEAN, b boolean);');
      return await skdb.schema();
    },
    check: res => {
      expect(res).toMatch(/^CREATE TABLE t1/);
    }
  },
  {
    name: n('Schema for table', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec('create table t1 (a BOOLEAN, b boolean);');
      return await skdb.schema('t1');
    },
    check: res => {
      expect(res).toMatch(/^CREATE TABLE t1/);
    }
  },
  {
    name: n('Schema for view', asWorker),
    fun: async (skdb: SKDB) => {
      await skdb.exec('create table t1 (a BOOLEAN, b boolean);');
      await skdb.exec('create virtual view v1 as select * from t1;');
      return await skdb.schema('v1');
    },
    check: res => {
      expect(res).toMatch(/^create virtual view v1/);
    }
  },
  ];
  return tests;
}
