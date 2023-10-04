import { useState, useEffect } from 'react'
import { SKDBContext, useQuery } from './skdb-react.js'
import type { SKDB } from 'skdb'

function UserSelector({users, select}: {users: string[], select: (accessKey: string) => void}) {
  const list = users.map(user => <option value={user} key={user}>{user}</option>)
  return (
    <div>
      <div>Users</div>
      <select onChange={e => select(e.target.value)}>
        {list}
      </select>
    </div>
  )
}

function ReactiveQueryViewer() {
  const [query, setQuery] = useState('');
  const [queries, setQueries] = useState<string[]>([]);

  const show = async (query: string) => {
    setQueries(queries.concat(query))
  }

  const removeQuery = (q) => {
    const qIdx = queries.findIndex((x) => x === q)
    setQueries(queries.filter((val, idx) => idx != qIdx))
  }

  const tables = queries.map(q => <SKDBTable key={q} query={q} removeQuery={removeQuery} />);

  return (
    <div>
      <div>Watched queries</div>
      <input value={query}
        onChange={e => setQuery(e.target.value)}
        onKeyDown={e => {if (e.key === 'Enter') show(query)}} />
      {tables}
    </div>
  )
}

function SKDBTable({query, removeQuery}) {
  const rows = useQuery(query);
  const keys = rows.length < 1 ? [] : Object.keys(rows[0])
  let i = 0;
  const acc = rows.map(row => {
    let j = 0;
    const tds: JSX.Element[] = [];
    for (const k of keys) {
      tds.push(<td key={j++}>{row[k]}</td>);
    }
    return (
      <tr key={i++}>{tds}</tr>
    )
  })
  return (
    <div>
      <span>{query}</span>
      <button onClick={e => removeQuery(query)}>X</button>
      <table>
        <thead>
          <tr>
            {keys.map((k,idx) => <th key={idx}>{k}</th>)}
          </tr>
        </thead>
        <tbody>
          {acc}
        </tbody>
      </table>
    </div>
  )
}

export function SKDBDevConsoleProvider(
  { children, skdbAsRoot, create }: {
    children: React.ReactNode,
    skdbAsRoot: SKDB,
    create: (accessKey: string) => Promise<SKDB>
  }
) {
  const [users, setUsers] = useState(["root"]);
  const [currentUser, setCurrentUser] = useState("root");
  const [skdbs, setSkdbs] = useState({"root": skdbAsRoot})

  useEffect(() => {
    skdbAsRoot.connectedRemote().then((remote) => {
      if (remote === undefined) {
        throw new Error("SKDB not connected");
      }
      remote.exec("SELECT userName FROM skdb_users").then((userRows) => {
        setUsers(userRows.map(row => row.userName));
      });
    });
  });

  const addUser = async () => {
    const remote = await skdbAsRoot.connectedRemote();
    if (remote === undefined) {
      throw new Error("SKDB not connected");
    }
    const cred = await remote.createUser();
    setUsers(users.concat(cred.accessKey));
  };

  const changeUser = async (key: string) => {
    if (!(key in skdbs)) {
      const newUserSkdb = await create(key)
      skdbs[key] = newUserSkdb;
      setSkdbs({
        ...skdbs
      })
    }
    setCurrentUser(key);
  };

  // TODO: move button in to user selector
  return (
    <SKDBContext.Provider value={skdbs[currentUser]}>
      <div id="skdb_user_picker">
        <UserSelector users={users} select={changeUser} />
        <button onClick={e => addUser()}>+</button>
        <ReactiveQueryViewer />
      </div>
      {children}
    </SKDBContext.Provider>
  )
}
