async function test() {
  let skdb = await SKDB.create(true);
  skdb.sqlRaw('create table if not exists todos (id text primary key, text text, completed integer);')

  const ROOT_ID = 'todosRoot'

  // Make a callable that returns the SQL query string we want to run
  const queryStringCallable = skdb.registerFun(() => `select * from todos`)
  
  // Make a tracked function which fetches the query string and then runs the query
  const todos = skdb.registerFun(() => {
    const queryString = skdb.trackedCall(queryStringCallable, null)
    return skdb.trackedQuery(queryString)
  })

  // Add a root for the tracked function and get its result
  skdb.addRoot(ROOT_ID, todos, null)
  console.log('todos', skdb.getRoot(ROOT_ID));
}

test();



