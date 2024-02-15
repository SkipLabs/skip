import { useState, useEffect } from "react";
import { createContext, useContext } from "react";
import type { SKDB } from "skdb";
import { Params } from "skdb/dist/skdb_types.js";

export const SKDBContext = createContext<SKDB | undefined>(undefined);

export function SKDBProvider({
  children,
  skdb,
}: {
  children: React.ReactNode;
  skdb: SKDB;
}) {
  return <SKDBContext.Provider value={skdb}>{children}</SKDBContext.Provider>;
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
  params: Params = {},
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
    skdb
      .watch(query, params, (rows: Array<any>) => {
        setState(rows);
      })
      .then((handle) => {
        if (removeQuery) {
          return handle.close();
        }
        closeable.close = handle.close;
      });
    return () => {
      removeQuery = true;
      closeable.close();
    };
  }, deps);

  return state;
}
