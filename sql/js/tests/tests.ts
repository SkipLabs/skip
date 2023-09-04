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
    name: 'Remove root',
    fun: skdb => {
      skdb.sqlRaw(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.sqlRaw("insert into todos values (0, 'foo', 1);");

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
    fun: skdb => {
      skdb.sqlRaw(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.sqlRaw("insert into todos values (0, 'foo', 0);");

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
      skdb.sqlRaw("insert into todos values (11, 'bar', 1);")
      skdb.sqlRaw("update todos set text = 'baz' where id = 11;");

      skdb.sqlRaw("insert into todos values (1, 'bar', 1);")
      skdb.sqlRaw("update todos set text = 'baz' where id = 0;");
      skdb.sqlRaw("update todos set text = 'quux';");

      return counter;
    },
    check: res => {
      expect(res).toEqual(4);   // once for initial, insert, and then two updates
    }
}, {
    name: 'Registered function called only when complex tracked query changes',
    fun: skdb => {
      skdb.sqlRaw(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.sqlRaw("insert into todos values (0, 'foo', 0);");
      skdb.sqlRaw("insert into todos values (1, 'foo', 0);");
      skdb.sqlRaw("insert into todos values (2, 'foo', 1);");
      skdb.sqlRaw("insert into todos values (3, 'foo', 0);");

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

      skdb.sqlRaw("insert into todos values (4, 'foo', 1);");
      skdb.sqlRaw("update todos set text = 'baz' where id = 0;");

      return [counter, skdb.getRoot(ROOT_ID)];
    },
    check: res => {
      expect(res).toEqual([2, {0: 2, 1: 2}]);
    }
}, {
    name: 'onRootChange called when root changes',
    fun: skdb => {
      skdb.sqlRaw(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.sqlRaw("insert into todos values (0, 'foo', 0);");

      const ROOT_ID = 'app';

      const todos = skdb.registerFun(() => {
        let results = skdb.trackedQuery("select text from todos where id = 0");
        return {
          text: results[0].text,
        }
      });

      skdb.addRoot(ROOT_ID, todos, null);

      let counter = 0;
      skdb.onRootChange((_rootName) => {
        counter = counter + 1;
      });

      // no change
      const counterBefore = counter;
      skdb.sqlRaw("insert into todos values (1, 'bar', 1);")
      skdb.sqlRaw("update todos set text = 'baz' where id = 1;");
      const counterAfterNoOp = counter;
      // change
      skdb.sqlRaw("update todos set text = 'baz' where id = 0;");
      skdb.sqlRaw("update todos set text = 'quux';");

      return [counterBefore, counterAfterNoOp, counter];
    },
    check: res => {
      expect(res).toEqual([0, 0, 2]);
    }
}, {
    name: 'Tracked calls allow composing views made of tracked queries',
    fun: skdb => {
      skdb.sqlRaw(
        'create table if not exists todos (id integer primary key, text text, completed integer);'
      );
      skdb.sqlRaw("insert into todos values (0, 'foo', 0);");
      skdb.sqlRaw("insert into todos values (1, 'bar', 1);");
      skdb.sqlRaw("insert into todos values (2, 'baz', 0);");

      let todoTextInvocations = 0;
      const todoText = skdb.registerFun((id: number) => {
        todoTextInvocations = todoTextInvocations + 1;
        let results = skdb.trackedQuery(`select text from todos where id = ${id}`);
        return {
          text: results[0].text,
        }
      });

      let uncompletedTodosInvocations = 0;
      // somewhat convoluted example of view logic composition
      let uncompletedTodos = skdb.registerFun(() => {
        uncompletedTodosInvocations = uncompletedTodosInvocations + 1;
        const ids = skdb.trackedQuery("select id from todos where completed = 0")
        const acc = [];
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
      skdb.sqlRaw("insert into todos values (3, 'bar', 1);")
      skdb.sqlRaw("update todos set text = 'quux' where id = 1;");
      const afterBenign = [todoTextInvocations, uncompletedTodosInvocations];

      // only need to re-call one tracked query
      skdb.sqlRaw("insert into todos values (4, 'new', 0);")
      const afterInsert = [todoTextInvocations, uncompletedTodosInvocations];

      // delete
      skdb.sqlRaw("delete from todos where id = 0;")
      const afterDelete = [todoTextInvocations, uncompletedTodosInvocations];

      // everything updated (2 rows)
      skdb.sqlRaw("update todos set text = 'update' where completed = 0");
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
