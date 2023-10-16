import { useState, useEffect, useRef } from 'react'
import { SKDBContext, useQuery, useSKDB } from './skdb-react.js'
import type { SKDB } from 'skdb'
import skLogo from './assets/sk.svg'
import './dev-console.css'

function Section({children, heading}: {children: React.ReactNode, heading: string}) {
  return (
    <div className="section">
      <div className="section-heading">{heading}</div>
      <div className="section-body">
        {children}
      </div>
    </div>
  )
}

function UserSelector(
  {users, select, add}: {
    users: string[],
    select: (accessKey: string) => void,
    add: () => void,
  },
) {
  const list = users.map(user => <option value={user} key={user}>{user}</option>)
  return (
    <Section heading="Current user">
      <div className="users-panel" onMouseDown={e => e.stopPropagation()}>
        <select onChange={e => select(e.target.value)}>
          {list}
        </select>
        <button className="add-user" onClick={_e => add()}>&#x002B;</button>
      </div>
    </Section>
  )
}

function ReactiveQueryViewer() {
  const [query, setQuery] = useState('SELECT * FROM');
  const [queries, setQueries] = useState<string[]>([]);
  const [error, setError] = useState<string|undefined>(undefined);
  const skdb = useSKDB();

  const show = async (query: string) => {
    try {
      setError(undefined);
      await skdb.exec(query);   // run it up front to catch any errors
      const qs = queries.slice();
      qs.unshift(query);
      setQueries(qs);
    } catch (ex: any) {
      setError(ex.message);
    }
  }

  const removeQuery = (q: string) => {
    const qIdx = queries.findIndex((x) => x === q)
    setQueries(queries.filter((_val, idx) => idx != qIdx))
  }

  const tables = queries.map(q => (
    <SKDBTable key={q} query={q} removeQuery={removeQuery} />
  ));

  const errorComponent =  error ? (
    <div className="query-error">
      <pre><code>{error}</code></pre>
    </div>
  ) : <div />

  return (
    <Section heading="Watched queries">
      <div className="queries-panel" onMouseDown={e => e.stopPropagation()}>
        <input value={query}
          onChange={e => setQuery(e.target.value)}
          onKeyDown={e => {if (e.key === 'Enter') show(query)}} />
        <button className="add-query" onClick={_e => show(query)}>&#x002B;</button>
      </div>
      {errorComponent}
      {tables}
    </Section>
  )
}

function SKDBTable({query, removeQuery}) {
  const [visible, setVisible] = useState(true);
  const rows = useQuery(query);
  const keys = rows.length < 1 ? [] : Object.keys(rows[0])
  let i = 0;
  const acc = rows.map((row: Object) => {
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
    <div className="skdb-table" onMouseDown={e => e.stopPropagation()}>
      <div className="skdb-table-header">
        <div onClick={() => setVisible(!visible)} className="skdb-table-query">
          {visible ? "\u25BC" : "\u25B2"}  {query}
        </div>
        <button className="close-query" onClick={_e => removeQuery(query)}>&#x2718;</button>
      </div>
      <div className="skdb-table-body">
        <table className={visible ? "visible" : "hidden"}>
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
    </div>
  )
}

function Draggable({children}) {
  const [position, setPosition] = useState<{x?:number, y?:number}>({x: undefined, y: undefined})
  const ref = useRef<HTMLDivElement>(null)

  // Monitor changes to position state and update DOM
  useEffect(() => {
    if (ref.current) {
      if (position.x !== undefined || position.y !== undefined) {
        const right = window.innerWidth - ((position.x||0) + ref.current.offsetWidth);
        ref.current.style.top = `${position.y}px`;
        ref.current.style.right = `${right}px`;
      }
    }
  }, [position])

  const globalMousemove = (offsetX: number, offsetY: number) => {
    return (event: MouseEvent) => {
      setPosition({
        x: event.clientX - offsetX,
        y: event.clientY - offsetY
      })
      event.preventDefault();
    }
  }

  const globalMouseup = (move: (event: MouseEvent) => void) => {
    return (_event: MouseEvent) => {
      document.removeEventListener('mousemove', move);
      document.removeEventListener('mouseup', this);
    }
  }

  const mouseDown = (e: React.MouseEvent) => {
    const move = globalMousemove(
      e.clientX - (ref.current?.offsetLeft||0),
      e.clientY - (ref.current?.offsetTop||0),
    );
    document.addEventListener('mousemove', move);
    document.addEventListener('mouseup', globalMouseup(move));
  }

  return (
    <div ref={ref} className="skdb-dev-console-draggable" onMouseDown={mouseDown}>
      {children}
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
  const [skdbs, setSkdbs] = useState({"root": skdbAsRoot});
  const [expanded, setExpanded] = useState(false);

  useEffect(() => {
    skdbAsRoot.connectedRemote().then((remote) => {
      if (remote === undefined) {
        throw new Error("SKDB not connected");
      }
      remote.exec("SELECT userUUID FROM skdb_users").then((userRows) => {
        setUsers(userRows.map(row => row.userUUID));
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

  return (
    <SKDBContext.Provider value={skdbs[currentUser]}>
      <Draggable>
        <div id="skdb_dev_console">
          <img src={skLogo} alt="SKDB Dev Console" className="logo collapse"
            onClick={() => setExpanded(!expanded)}/>
          <div className={expanded ? "visible" : "hidden"}>
            <UserSelector users={users} select={changeUser} add={addUser} />
            <ReactiveQueryViewer />
          </div>
        </div>
      </Draggable>
      {children}
    </SKDBContext.Provider>
  )
}
