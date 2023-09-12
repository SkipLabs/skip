import { expect } from '@playwright/test';
import { SKDB } from '../src/skdb';

export const tests = [
  {
    name: 'Run local',
    // basic sanity test. does wasm load up and can we call it?
    fun: (skdb: SKDB) => {
      return skdb.runLocal(['dump'], '');
    },
    check: res => {
      expect(res).toEqual("")
    }
  },
  {
    name: 'Boolean',
    fun: (skdb: SKDB) => {
      skdb.exec('create table t1 (a BOOLEAN, b boolean);');
      skdb.exec('insert into t1 values(TRUE, false);');
      return skdb.exec('select true, false, a, b from t1;');
    },
    check: res => {
      expect(res).toEqual([{"a": 1, "b": 0, "col<0>": 1, "col<1>": 0}])
    }
  },
  {
    name: 'Create table if not exists',
    fun: (skdb: SKDB) => {
      skdb.exec('create table t1 (a BOOLEAN, b boolean);');
      skdb.exec('create table if not exists t1 (a BOOLEAN, b boolean);');
      return skdb.exec('select 1;');
    },
    check: res => {
      expect(res).toEqual([{"col<0>": 1}]);
    }
  },
  {
    name: 'Primary key',
    fun: (skdb: SKDB) => {
      skdb.exec('create table t1 (a STRING PRIMARY KEY);');
    },
    check: _res => {}
  },
  {
    name: 'Primary key 2',
    fun: (skdb: SKDB) => {
      skdb.exec('create table t1 (a STRING PRIMARY KEY, b INTEGER);');
      skdb.exec("insert into t1 (a, b) values ('foo', 22);");
      return skdb.exec('select a, b from t1');
    },
    check: res => {
      expect(res).toEqual([{a: 'foo', b: 22}]);
    }
  },
  {
    name: 'Multiple field updates',
    fun: (skdb: SKDB) => {
      skdb.exec('create table widgets (id text unique, name text);');
      skdb.exec('INSERT INTO widgets (id, name) VALUES (\'a\', \'gear\');');
      skdb.exec('UPDATE widgets SET id = \'c\', name = \'gear2\';');
      return skdb.exec('select * from widgets;');
    },
    check: res => {
      expect(res).toEqual([{"id": "c", "name": "gear2"}]);
    }
  },
  {
    name: 'Parse/print float',
    fun: (skdb: SKDB) => {
      skdb.exec("create table widgets (id text unique , price real not null);");
      skdb.exec("INSERT INTO widgets (id, price) values ('a', 10.0);");
      return skdb.exec('select * from widgets');
    },
    check: res => {
      expect(res).toEqual([{"id": "a", "price": 10}]);
    }
  },
  {
    name: 'Virtual view if not exists',
    fun: (skdb: SKDB) => {
      skdb.exec('create table t1 (a BOOLEAN, b boolean);');
      skdb.exec('create virtual view v1 as select * from t1;');
      skdb.exec('create virtual view if not exists v1 as select * from t1;');
      return skdb.exec('select 1;');
    },
    check: res => {
      expect(res).toEqual([{"col<0>": 1}]);
    }
  },
  {
    name: 'View if not exists',
    fun: (skdb: SKDB) => {
      skdb.exec('create table t1 (a BOOLEAN, b boolean);');
      skdb.exec('create view v1 as select * from t1;');
      skdb.exec('create view if not exists v1 as select * from t1;');
      return skdb.exec('select 1;');
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
  //     fun: (skdb: SKDB) => {
  //         let res = 0;
  //         for(let i = 0; i < 10000; i++) {
  //             let queryRes = skdb.exec('select * from t1;');
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
    name: 'Column casting',
    fun: (skdb: SKDB) => {
      skdb.exec('create table t1 (aBc INTEGER)');
      skdb.insert('t1', [11]);
      return skdb.exec('select * from t1')[0].aBc;
    },
    check: res => {
      expect(res).toEqual(11);
    }
  },
  {
    name: 'Limit',
    fun: (skdb: SKDB) => {
      skdb.exec('create table t1 (aBc INTEGER)');
      skdb.insert('t1', [11]);
      return skdb.exec('select * from t1 limit 1')[0].aBc;
    },
    check: res => {
      expect(res).toEqual(11);
    }
  },
  {
    name: 'Params 1',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER);');
      skdb.exec('INSERT INTO t1 VALUES (@key);', new Map().set("key", 13));
      return skdb.exec('SELECT * FROM t1;');
    },
    check: res => {
      expect(res).toEqual([{"a": 13}]);
    }
  },
  {
    name: 'Params as object',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER);');
      skdb.exec('INSERT INTO t1 VALUES (@key);', {key: 13});
      return skdb.exec('SELECT * FROM t1;');
    },
    check: res => {
      expect(res).toEqual([{"a": 13}]);
    }
  },
  {
    name: 'Params 2',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b INTEGER, c INTEGER);');
      skdb.insert('t1', [13, 9, 42])
      return skdb.exec('SELECT * FROM t1;');
    },
    check: res => {
      expect(res).toEqual([{"a": 13, "b": 9, "c": 42}]);
    }
  },
  {
    name: 'Test reactive query updated on insert and then closed',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      skdb.insert('t1', [13, "9", 42.1]);
      let result: Array<any> = [];
      let handle = skdb.watch('SELECT * FROM t1;', {}, (changes) => {
        result.push(changes);
      });
      skdb.insert('t1', [14, "bar", 44.5]);
      handle.close();
      skdb.insert('t1', [15, "foo", 46.8]);
      return result;
    },
    check: res => {
      expect(res).toEqual(
        [
          [
            {"a": 13, "b": "9", "c": 42.1}
          ],
          [
            {"a": 13, "b": "9", "c": 42.1},
            {"a": 14, "b": "bar", "c": 44.5}
          ]
        ]
      );
    }
  },
  {
    name: 'Test reactive query updated on update and then closed',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      skdb.insert('t1', [13, "9", 42.1]);
      let result: Array<any> = [];
      let handle = skdb.watch('SELECT * FROM t1;', {}, (changes) => {
        result.push(changes);
      });
      skdb.exec("update t1 set b = 'foo' where a = 13")
      handle.close();
      skdb.exec("update t1 set b = 'bar' where a = 13")
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
          // TODO: getting an extra callback
          [
            {"a": 13, "b": "foo", "c": 42.1},
          ],
        ]
      );
    }
  },
  {
    name: 'Test reactive query updated on delete and then closed',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      skdb.insert('t1', [13, "9", 42.1]);
      skdb.insert('t1', [14, "9", 42.1]);
      let result: Array<any> = [];
      let handle = skdb.watch('SELECT * FROM t1;', {}, (changes) => {
        result.push(changes);
      });
      skdb.exec("delete from t1 where a = 13");
      handle.close();
      skdb.exec("delete from t1 where a = 14");
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
    name: 'Test filtering reactive query updated on insert and then closed',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b INTEGER, c INTEGER);');
      skdb.insert('t1', [13, 9, 42]);
      let result: Array<any> = [];
      let handle = skdb.watch('SELECT * FROM t1 where a = 13 or a = 14;', {}, (changes) => {
        result.push(changes);
      });
      skdb.insert('t1', [14, 9, 44]);
      handle.close();
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
    name: 'Test filtering reactive query updated on update and then closed',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      skdb.insert('t1', [13, "9", 42.1]);
      let result: Array<any> = [];
      let handle = skdb.watch('SELECT * FROM t1 where a = 13 or a = 14;', {}, (changes) => {
        result.push(changes);
      });
      skdb.exec("update t1 set b = 'foo' where a = 13")
      handle.close();
      skdb.exec("update t1 set b = 'bar' where a = 13")
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
          // TODO: extra because of update
          [
            {"a": 13, "b": "foo", "c": 42.1},
          ]
        ]
      );
    }
  },
  {
    name: 'Test filtering reactive query updated on delete and then closed',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      skdb.insert('t1', [13, "9", 42.1]);
      skdb.insert('t1', [14, "9", 42.1]);
      let result: Array<any> = [];
      let handle = skdb.watch('SELECT * FROM t1 where a = 13 or a = 14;', {}, (changes) => {
        result.push(changes);
      });
      skdb.exec("delete from t1 where a = 13");
      handle.close();
      skdb.exec("delete from t1 where a = 14");
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
    name: 'Complex reactive query updated on insert, update, delete, then closed',
    fun: (skdb: SKDB) => {
      skdb.exec(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.exec("insert into todos values (0, 'foo', 0);");
      skdb.exec("insert into todos values (1, 'foo', 0);");
      skdb.exec("insert into todos values (2, 'foo', 1);");
      skdb.exec("insert into todos values (3, 'foo', 0);");

      let result: Array<any> = [];
      let handle = skdb.watch(
        'select completed, count(*) as n from (select * from todos where id > 0) group by completed',
        {}, (changes) => {
        result.push(changes);
      });

      skdb.exec("insert into todos values (4, 'foo', 1);");
      skdb.exec("update todos set text = 'baz' where id = 0;");

      handle.close();
      return result
    },
    check: res => {
      expect(res).toEqual(
        [
          [{completed: 0, n: 2}, {completed: 1, n: 1}],
          [{completed: 0, n: 2}, {completed: 1, n: 2}],
          // TODO: extra because of update
          [{completed: 0, n: 2}, {completed: 1, n: 2}],
        ]
      );
    }
  },
  {
    name: 'Reactive queries support params',
    fun: (skdb: SKDB) => {
      skdb.exec(
        'create table if not exists test (x integer primary key, y string, z float, w integer);'
      );
      skdb.exec("insert into test values (0, 'foo', 1.2, 42);");


      let result: Array<any> = [];
      let handle = skdb.watch(
        "select w from test where x = @x and y = @y and z = @zed",
        new Map<string, string|number>([["x", 0], ["y", "foo"], ["zed", 1.2]]),
        (changes) => {
        result.push(changes);
      });

      skdb.exec("update test set w = 21 where y = 'foo';");

      handle.close();
      return result
    },
    check: res => {
      expect(res).toEqual([
        [{w:42}],
        [{w:21}],
        // TODO: extra because of update
        [{w:21}]
      ]);
    }
  },
  {
    name: 'Reactive queries support object params',
    fun: (skdb: SKDB) => {
      skdb.exec(
        'create table if not exists test (x integer primary key, y string, z float, w integer);'
      );
      skdb.exec("insert into test values (0, 'foo', 1.2, 42);");


      let result: Array<any> = [];
      let handle = skdb.watch(
        "select w from test where x = @x and y = @y and z = @zed",
        {x: 0, y: 'foo', zed: 1.2},
        (changes) => {
        result.push(changes);
      });

      skdb.exec("update test set w = 21 where y = 'foo';");

      handle.close();
      return result
    },
    check: res => {
      expect(res).toEqual([
        [{w:42}],
        [{w:21}],
        // TODO: extra because of update
        [{w:21}],
      ]);
    }
  },
  {
    name: 'A reactive query can be updated with new spliced arguments',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      skdb.insert('t1', [13, "9", 42.1]);
      let result: Array<any> = [];
      let handle = skdb.watch('SELECT * FROM t1 where a = 13;', {}, (changes) => {
        result.push(changes);
      });
      skdb.insert('t1', [14, "bar", 44.5]);
      handle.close();
      handle = skdb.watch('SELECT * FROM t1 where a = 14;', {}, (changes) => {
        result.push(changes);
      });
      skdb.insert('t1', [15, "foo", 46.8]);
      handle.close();
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
    name: 'A reactive query can be replaced with new params',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      skdb.insert('t1', [13, "9", 42.1]);
      let result: Array<any> = [];
      let handle = skdb.watch('SELECT * FROM t1 where a = @a;', {a: 13}, (changes) => {
        result.push(changes);
      });
      skdb.insert('t1', [14, "bar", 44.5]);
      handle.close();
      handle = skdb.watch('SELECT * FROM t1 where a = @a;', {a: 14}, (changes) => {
        result.push(changes);
      });
      skdb.insert('t1', [15, "foo", 46.8]);
      handle.close();
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
    name: 'Concurrent non-overlapping reactive queries can co-exist',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      skdb.exec('CREATE TABLE t2 (a INTEGER, b STRING, c FLOAT);');
      skdb.insert('t1', [13, "9", 42.1]);
      skdb.insert('t2', [13, "9", 42.1]);

      let result1: Array<any> = [];
      let result2: Array<any> = [];

      let handle1 = skdb.watch('SELECT * FROM t1 where a = @a;', {a: 13}, (changes) => {
        result1.push(changes);
      });
      let handle2 = skdb.watch('SELECT * FROM t2 where a = @a;', {a: 13}, (changes) => {
        result2.push(changes);
      });

      skdb.exec("update t1 set b = 'foo';");
      skdb.exec("update t2 set b = 'bar';");

      handle1.close();
      handle2.close();

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
            // TODO: extra because of update
            [
              {"a": 13, "b": "foo", "c": 42.1}
            ]
          ],
          [
            [
              {"a": 13, "b": "9", "c": 42.1}
            ],
            [
              {"a": 13, "b": "bar", "c": 42.1}
            ],
            // TODO: extra because of update
            [
              {"a": 13, "b": "bar", "c": 42.1}
            ]
          ]
        ]
      );
    }
  },
  {
    name: 'Concurrent non-overlapping (same table) reactive queries can co-exist',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      skdb.insert('t1', [13, "9", 42.1]);
      skdb.insert('t1', [15, "9", 42.1]);

      let result1: Array<any> = [];
      let result2: Array<any> = [];

      let handle1 = skdb.watch('SELECT * FROM t1 where a < @a;', {a: 15}, (changes) => {
        result1.push(changes);
      });
      let handle2 = skdb.watch('SELECT * FROM t1 where a > @a;', {a: 13}, (changes) => {
        result2.push(changes);
      });

      skdb.exec("update t1 set b = 'foo';");

      handle1.close();
      handle2.close();

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
            // TODO: extra because of update
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
            // TODO: extra because of update
            [
              {"a": 15, "b": "foo", "c": 42.1},
            ],
          ]
        ]
      );
    }
  },
  {
    name: 'Concurrent overlapping reactive queries can co-exist',
    fun: (skdb: SKDB) => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b STRING, c FLOAT);');
      skdb.insert('t1', [13, "9", 42.1]);
      skdb.insert('t1', [14, "9", 42.1]);
      skdb.insert('t1', [15, "9", 42.1]);

      let result1: Array<any> = [];
      let result2: Array<any> = [];

      let handle1 = skdb.watch('SELECT * FROM t1 where a < @a;', {a: 15}, (changes) => {
        result1.push(changes);
      });
      let handle2 = skdb.watch('SELECT * FROM t1 where a > @a;', {a: 13}, (changes) => {
        result2.push(changes);
      });

      skdb.exec("update t1 set b = 'foo';");

      handle1.close();
      handle2.close();

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
            // TODO: extra because of update
            [
              {"a": 13, "b": "foo", "c": 42.1},
              {"a": 14, "b": "foo", "c": 42.1}
            ],
            [
              {"a": 13, "b": "foo", "c": 42.1},
              {"a": 14, "b": "foo", "c": 42.1}
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
            // TODO: extra because of update
            [
              {"a": 14, "b": "foo", "c": 42.1},
              {"a": 15, "b": "foo", "c": 42.1},
            ],
            [
              {"a": 14, "b": "foo", "c": 42.1},
              {"a": 15, "b": "foo", "c": 42.1},
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
];
