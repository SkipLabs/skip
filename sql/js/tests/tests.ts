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
    name: 'Adding a root',
    fun: skdb => {
        skdb.sqlRaw(
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
    },
    check: res => {
        expect(res).toEqual("[]");
    }
}];
