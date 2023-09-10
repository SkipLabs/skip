import { expect } from '@playwright/test';

export const tests = [{
    name: 'Boolean',
    fun: skdb => {
        skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');
        skdb.sqlRaw('insert into t1 values(TRUE, false);');
        return skdb.sqlRaw('select true, false, a, b from t1;');
    },
    check: res => {
        expect(res).toEqual("1|0|1|0\n")
    }
}, {
    name: 'Create table if not exists',
    fun: skdb => {
        skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');
        skdb.sqlRaw('create table if not exists t1 (a BOOLEAN, b boolean);');
        return skdb.sqlRaw('select 1;');
    },
    check: res => {
        expect(res).toEqual("1\n");
    }
}, {
    name: 'Primary key',
    fun: skdb => {
        skdb.sqlRaw('create table t1 (a STRING PRIMARY KEY);');
    },
    check: _res => {}
}, {
    name: 'Primary key 2',
    fun: skdb => {
      skdb.sqlRaw('create table t1 (a STRING PRIMARY KEY, b INTEGER);');
      skdb.sqlRaw("insert into t1 (a, b) values ('foo', 22);");
      return skdb.exec('select a, b from t1');
    },
    check: res => {
      expect(res).toEqual([{a: 'foo', b: 22}]);
    }
}, {
    name: 'Multiple field updates',
    fun: skdb => {
        skdb.exec('create table widgets (id text unique, name text);');
        skdb.exec('INSERT INTO widgets (id, name) VALUES (\'a\', \'gear\');');
        skdb.exec('UPDATE widgets SET id = \'c\', name = \'gear2\';');
        return skdb.sqlRaw('select * from widgets;');
    },
    check: res => {
        expect(res).toEqual("c|gear2\n");
    }
}, {
    name: 'Parse/print float',
    fun: skdb => {
        skdb.exec("create table widgets (id text unique , price real not null);");
        skdb.exec("INSERT INTO widgets (id, price) values ('a', 10.0);");
        return skdb.sqlRaw('select * from widgets');
    },
    check: res => {
        expect(res).toEqual("a|10.0\n");
    }
}, {
    name: 'Virtual view if not exists',
    fun: skdb => {
        skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');
        skdb.sqlRaw('create virtual view v1 as select * from t1;');
        skdb.sqlRaw('create virtual view if not exists v1 as select * from t1;');
        return skdb.sqlRaw('select 1;');
    },
    check: res => {
        expect(res).toEqual("1\n");
    }
}, {
    name: 'View if not exists',
    fun: skdb => {
        skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');
        skdb.sqlRaw('create view v1 as select * from t1;');
        skdb.sqlRaw('create view if not exists v1 as select * from t1;');
        return skdb.sqlRaw('select 1;');
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
//     fun: skdb => {
//         let res = 0;
//         for(let i = 0; i < 10000; i++) {
//             let queryRes = skdb.sqlRaw('select * from t1;');
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
    fun: skdb => {
        skdb.exec('create table t1 (aBc INTEGER)');
        skdb.insert('t1', [11]);
        return skdb.exec('select * from t1')[0].aBc;
    },
    check: res => {
        expect(res).toEqual(11);
    }
}, {
    name: 'Limit',
    fun: skdb => {
        skdb.exec('create table t1 (aBc INTEGER)');
        skdb.insert('t1', [11]);
        return skdb.exec('select * from t1 limit 1')[0].aBc;
    },
    check: res => {
        expect(res).toEqual(11);
    }
}, {
    name: 'Params 1',
    fun: skdb => {
      skdb.exec('CREATE TABLE t1 (a INTEGER);');
      skdb.exec('INSERT INTO t1 VALUES (@key);', new Map().set("key", 13));
      return skdb.sqlRaw('SELECT * FROM t1;');
    },
    check: res => {
      expect(res).toEqual("13\n");
    }
}, {
    name: 'Params as object',
    fun: skdb => {
      skdb.exec('CREATE TABLE t1 (a INTEGER);');
      skdb.exec('INSERT INTO t1 VALUES (@key);', {key: 13});
      return skdb.sqlRaw('SELECT * FROM t1;');
    },
    check: res => {
      expect(res).toEqual("13\n");
    }
}, {
    name: 'Params 2',
    fun: skdb => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b INTEGER, c INTEGER);');
      skdb.insert('t1', [13, 9, 42])
      return skdb.sqlRaw('SELECT * FROM t1;');
    },
    check: res => {
      expect(res).toEqual("13|9|42\n");
    }
}, {
    name: 'Test reactive query',
    fun: skdb => {
      skdb.exec('CREATE TABLE t1 (a INTEGER, b INTEGER, c INTEGER);');
      skdb.insert('t1', [13, 9, 42]);
      let result = [];
      let handle = skdb.watch('SELECT * FROM t1;', {}, (changes) => {
        result.push(changes);
      });
      skdb.insert('t1', [14, 9, 44]);
      handle.close();
      return result;
    },
    check: res => {
      expect(res).toEqual(
        [[{"a": 13, "b": 9, "c": 42}],
         [{"a": 13, "b": 9, "c": 42}, {"a": 14, "b": 9, "c": 44}]
        ]);
    }
}];
