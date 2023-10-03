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
  { children, skdb, create }: {
    children: React.ReactNode,
    skdb: SKDB,
    create: (accessKey: string) => Promise<SKDB>
  }
) {
// TODO: this won't be sticky between reloads. need to useEffect to query skdb users table for list of users
  const [users, setUsers] = useState({"root": skdb});
  const [currentUser, setCurrentUser] = useState("root");

  const addUser = async () => {
    const remote = await skdb.connectedRemote();
    if (remote === undefined) {
      throw new Error("SKDB not connected");
    }
    const cred = await remote.createUser();
    const newUserSkdb = await create(cred.accessKey)
    // TODO: create a connected skdb lazily
    users[cred.accessKey] = newUserSkdb;
    setUsers({
      ...users,
    });
    // TODO: maybe give a friendly name to each? or a colour?
  };

  const changeUser = (key: string) => {
    // TODO: create a connected skdb lazily
    if (!(key in users)) {
      throw new Error("Chose a user that does not exist")
    }
    setCurrentUser(key);
  };

  // TODO: need a callback for this?
  // @ts-ignore
  window.skdb = users[currentUser];

  // TODO: need to get at user ids easily
  // TODO: could expand on this greatly to allow conveniently defining groups, setting permisssions, etc.

  return (
    <SKDBContext.Provider value={users[currentUser]}>
      <div id="skdb_user_picker">
        <UserSelector users={Object.keys(users)} select={changeUser} />
        <button onClick={e => addUser()}>+</button>
      </div>
      {children}
    </SKDBContext.Provider>
  )
}
