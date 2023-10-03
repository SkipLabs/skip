import { useState, useEffect } from 'react'
import { createContext, useContext } from 'react';
import type { SKDB } from 'skdb'

const SKDBContext = createContext<SKDB|undefined>(undefined);

export function SKDBProvider({ children, skdb }: { children: React.ReactNode, skdb: SKDB }) {
  return (
    <SKDBContext.Provider value={skdb}>
      {children}
    </SKDBContext.Provider>
  )
}

export function useSKDB(): SKDB {
  const skdb = useContext(SKDBContext);

  if (skdb === undefined) {
    throw new Error("Missing SKDBProvider component.");
  }

  return skdb;
}

export function useQuery(
  query: string,
  params: Object = {},
  defaultRows: Array<any> = [],
): any {
  const skdb = useSKDB();
  const [state, setState] = useState(defaultRows);

  const deps = Object.values(params);
  deps.push(skdb);
  deps.push(query);

  useEffect(() => {
    let removeQuery = false;
    const closeable = { close: () => {} };
    skdb.watch(query, params, (rows: Array<any>) => {
      setState(rows);
    }).then(handle => {
      if (removeQuery) {
        return handle.close();
      }
      closeable.close = handle.close
    });
    return () => {
      removeQuery = true;
      closeable.close();
    };
  }, deps);

  return state;
}

// TODO: move this stuff out to another file and check that it doesn't compile/link in if not used
function UserSelector({users, select}: {users: string[], select: (accessKey: string) => void}) {
  const list = users.map(user => <option value={user} key={user}>{user}</option>)
  return (
    <select onChange={e => select(e.target.value)}>
      {list}
    </select>
  )
}

// TODO: need to migrate the users table and permissions. need to ensure idempotent
export function SKDBMultiUserProvider(
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
    // TODO: maybe give a friendly name to each? or a colour?
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

  // TODO: need a callback for this? no, dev console!
  // @ts-ignore
  window.skdb = skdbs[currentUser];

  // TODO: need to get at user ids easily
  // TODO: could expand on this greatly to allow conveniently defining
  // groups, setting permisssions, etc. console! and watch tables!

  return (
    <SKDBContext.Provider value={skdbs[currentUser]}>
      <div id="skdb_user_picker">
        <UserSelector users={users} select={changeUser} />
        <button onClick={e => addUser()}>+</button>
      </div>
      {children}
    </SKDBContext.Provider>
  )
}
