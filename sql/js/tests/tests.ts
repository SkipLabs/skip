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
        skdb.sqlRaw('insert into t1 (b) values (22);');
    },
    check: res => {}
}, {
    name: 'Multiple field updates',
    fun: skdb => {
        skdb.sql('create table widgets (id text unique, name text);');
        skdb.sql('INSERT INTO widgets (id, name) VALUES (\'a\', \'gear\');');
        skdb.sql('UPDATE widgets SET id = \'c\', name = \'gear2\';');
        return skdb.sqlRaw('select * from widgets;');
    },
    check: res => {
        expect(res).toEqual("c|gear2\n");
    }
}, {
    name: 'Parse/print float',
    fun: skdb => {
        skdb.sql("create table widgets (id text unique , price real not null);");
        skdb.sql("INSERT INTO widgets (id, price) values ('a', 10.0);");
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
        skdb.sql('create table t1 (aBc INTEGER)');
        skdb.insert('t1', [11]);
        return skdb.sql('select * from t1')[0].aBc;
    },
    check: res => {
        expect(res).toEqual(11);
    }
}, {
    name: 'Limit',
    fun: skdb => {
        skdb.sql('create table t1 (aBc INTEGER)');
        skdb.insert('t1', [11]);
        return skdb.sql('select * from t1 limit 1')[0].aBc;
    },
    check: res => {
        expect(res).toEqual(11);
    }
}, {
    name: 'Integer root is computed',
    fun: skdb => {
      skdb.sqlRaw(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.sqlRaw(
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
    fun: skdb => {
      skdb.sqlRaw(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.sqlRaw(
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
    fun: skdb => {
      skdb.sqlRaw(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.sqlRaw(
        "insert into todos values (0, 'foo', 0);"
      );
      const ROOT_ID = 'app';

      const todos = skdb.registerFun(() => {
        let results = skdb.trackedQuery("select text from todos where id = 0");
        return {
          text: results[0].text,
        }
      });

      skdb.addRoot(ROOT_ID, todos, null);
      return skdb.getRoot(ROOT_ID);
    },
    check: res => {
      expect(res).toEqual({text: "foo"});
    }
}, {
    name: 'Multiple roots',
    fun: skdb => {
      skdb.sqlRaw(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.sqlRaw("insert into todos values (0, 'foo', 0);");
      skdb.sqlRaw("insert into todos values (1, 'bar', 1);");

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
    name: 'Registered function called only when tracked query changes',
    fun: skdb => {
      skdb.sqlRaw(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.sqlRaw("insert into todos values (0, 'foo', 0);");

      const ROOT_ID = 'app';

      let counter = 0;

      const todos = skdb.registerFun(() => {
        let results = skdb.trackedQuery("select text from todos where id = 0");
        counter = counter + 1;
        return {
          text: results[0].text,
        }
      });

      skdb.addRoot(ROOT_ID, todos, null);
      skdb.sqlRaw("insert into todos values (1, 'bar', 1);")
      skdb.sqlRaw("update todos set text = 'baz' where id = 1;");

      skdb.sqlRaw("update todos set text = 'baz' where id = 0;");
      skdb.sqlRaw("update todos set text = 'quux';");

      return counter;
    },
    check: res => {
      expect(res).toEqual(3);   // once for initial and then two updates
    }
}, {
    name: 'Params 1',
    fun: skdb => {
      skdb.sql('CREATE TABLE t1 (a INTEGER);');
      skdb.sql('INSERT INTO t1 VALUES (@key);', new Map().set("key", 13));
      return skdb.sqlRaw('SELECT * FROM t1;');
    },
    check: res => {
      expect(res).toEqual("13\n");
    }
}, {
    name: 'Params 2',
    fun: skdb => {
      skdb.sql('CREATE TABLE t1 (a INTEGER, b INTEGER, c INTEGER);');
      skdb.insert('t1', [13, 9, 42])
      return skdb.sqlRaw('SELECT * FROM t1;');
    },
    check: res => {
      expect(res).toEqual("13|9|42\n");
    }
}];
