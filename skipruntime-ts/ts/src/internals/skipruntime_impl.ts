// prettier-ignore
import { type ptr, type Opt } from "#std/sk_types.js";
import type { Context } from "./skipruntime_types.js";
import type * as Internal from "./skipruntime_internal_types.js";
import type {
  Accumulator,
  EagerCollection,
  LazyCollection,
  Mapper,
  InputMapper,
  OutputMapper,
  TableCollection,
  SKStore,
  SKStoreFactory,
  Mapping,
  Schema,
  ColumnSchema,
  Table,
  Loadable,
  JSONObject,
  TJSON,
  Param,
  LazyCompute,
  AsyncLazyCompute,
  NonEmptyIterator,
  Index,
  Remote,
  Locale,
  EntryPoint,
  Inputs,
} from "../skipruntime_api.js";

// prettier-ignore
import type { MirrorDefn, Params, SKDBSync } from "#skdb/skdb_types.js";

type Query = { query: string; params?: JSONObject };

function assertNoKeysNaN<K extends TJSON, V extends TJSON>(
  kv_pairs: Iterable<[K, V]>,
): Iterable<[K, V]> {
  for (const [k, _v] of kv_pairs) {
    if (Number.isNaN(k)) {
      // NaN is forbidden since it breaks comparison reflexivity, ordering, etc.
      throw new Error("NaN is forbidden as a Skip collection key");
    }
  }
  return kv_pairs;
}
export const serverResponseSuffix = "__skdb_mirror_feedback";

class EagerCollectionImpl<K extends TJSON, V extends TJSON>
  implements EagerCollection<K, V>
{
  //
  protected context: Context;
  eagerHdl: string;

  constructor(context: Context, eagerHdl: string) {
    this.context = context;
    this.eagerHdl = eagerHdl;
    Object.defineProperty(this, "__sk_frozen", {
      enumerable: false,
      writable: false,
      value: true,
    });
  }

  getId(): string {
    return this.eagerHdl;
  }

  protected derive<K2 extends TJSON, V2 extends TJSON>(
    eagerHdl: string,
  ): EagerCollection<K2, V2> {
    return new EagerCollectionImpl<K2, V2>(this.context, eagerHdl);
  }

  getArray(key: K): V[] {
    return this.context.getArray(this.eagerHdl, key);
  }

  getOne(key: K): V {
    return this.context.getOne(this.eagerHdl, key);
  }

  maybeGetOne(key: K): Opt<V> {
    return this.context.maybeGetOne(this.eagerHdl, key);
  }

  size = () => {
    return this.context.size(this.eagerHdl);
  };

  map<K2 extends TJSON, V2 extends TJSON, Params extends Param[]>(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    ...params: Params
  ): EagerCollection<K2, V2> {
    params.forEach(check);
    const mapperObj = new mapper(...params);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    const eagerHdl = this.context.map(
      this.eagerHdl,
      mapperObj.constructor.name,
      (key: K, it: NonEmptyIterator<V>) =>
        assertNoKeysNaN(mapperObj.mapElement(key, it)),
    );
    return this.derive<K2, V2>(eagerHdl);
  }

  mapReduce<
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
    Params extends Param[],
  >(
    mapper: new (...params: Params) => Mapper<K, V, K2, V2>,
    accumulator: Accumulator<V2, V3>,
    ...params: Params
  ) {
    params.forEach(check);
    const mapperObj = new mapper(...params);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    const eagerHdl = this.context.mapReduce(
      this.eagerHdl,
      mapperObj.constructor.name,
      (key: K, it: NonEmptyIterator<V>) =>
        assertNoKeysNaN(mapperObj.mapElement(key, it)),
      accumulator,
    );
    return this.derive<K2, V3>(eagerHdl);
  }

  mapTo<R extends TJSON[], Params extends Param[]>(
    table: TableCollection<R>,
    mapper: new (...params: Params) => OutputMapper<R, K, V>,
    ...params: Params
  ): void {
    params.forEach(check);
    const mapperObj = new mapper(...params);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    this.context.mapToSkdb(
      this.eagerHdl,
      table.getSchema(),
      (key: K, it: NonEmptyIterator<V>) => mapperObj.mapElement(key, it),
      table.isConnected(),
    );
  }
}

class LazyCollectionImpl<K extends TJSON, V extends TJSON>
  implements LazyCollection<K, V>
{
  protected context: Context;
  protected lazyHdl: string;

  constructor(context: Context, lazyHdl: string) {
    this.context = context;
    this.lazyHdl = lazyHdl;
    Object.defineProperty(this, "__sk_frozen", {
      enumerable: false,
      writable: false,
      value: true,
    });
  }

  getArray(key: K): V[] {
    return this.context.getArrayLazy(this.lazyHdl, key);
  }

  getOne(key: K): V {
    return this.context.getOneLazy(this.lazyHdl, key);
  }

  maybeGetOne(key: K): Opt<V> {
    return this.context.maybeGetOneLazy(this.lazyHdl, key);
  }
}

export class LSelfImpl<K extends TJSON, V extends TJSON>
  implements LazyCollection<K, V>
{
  protected context: Context;
  protected lazyHdl: ptr<Internal.LHandle>;

  constructor(context: Context, lazyHdl: ptr<Internal.LHandle>) {
    this.context = context;
    this.lazyHdl = lazyHdl;
    Object.defineProperty(this, "__sk_frozen", {
      enumerable: false,
      writable: false,
      value: true,
    });
  }

  getArray(key: K): V[] {
    return this.context.getArraySelf(this.lazyHdl, key);
  }

  getOne(key: K): V {
    return this.context.getOneSelf(this.lazyHdl, key);
  }

  maybeGetOne(key: K): Opt<V> {
    return this.context.maybeGetOneSelf(this.lazyHdl, key);
  }
}

export class TableCollectionImpl<R extends TJSON[]>
  implements TableCollection<R>
{
  constructor(
    protected context: Context,
    protected skdb: SKDBSync,
    protected schema: Schema,
  ) {
    Object.defineProperty(this, "__sk_frozen", {
      enumerable: false,
      writable: false,
      value: true,
    });
  }

  getName() {
    return this.schema.name;
  }

  getSchema() {
    return this.schema;
  }

  isConnected() {
    return this.skdb.connectedRemote ? true : false;
  }

  get(key: TJSON, index?: string | undefined) {
    return this.context.getFromTable(this.getName(), key, index);
  }

  map<K extends TJSON, V extends TJSON, Params extends Param[]>(
    mapper: new (...params: Params) => InputMapper<R, K, V>,
    ...params: Params
  ): EagerCollection<K, V> {
    params.forEach(check);
    const mapperObj = new mapper(...params);
    Object.freeze(mapperObj);
    if (!mapperObj.constructor.name) {
      throw new Error("Mapper classes must be defined at top-level.");
    }
    const name = this.getName();
    const skname = name + "_" + mapperObj.constructor.name;
    const eagerHdl = this.context.mapFromSkdb(
      name,
      skname,
      (entry: R, occ: number) =>
        assertNoKeysNaN(mapperObj.mapElement(entry, occ)),
    );
    return new EagerCollectionImpl<K, V>(this.context, eagerHdl);
  }

  toTable() {
    return new TableImpl(this.context.noref(), this.skdb, this.schema);
  }
}

export class TableImpl<R extends TJSON[]> implements Table<R> {
  protected context: Context;
  protected skdb: SKDBSync;
  protected schema: Schema;

  constructor(context: Context, skdb: SKDBSync, schema: Schema) {
    this.context = context;
    this.skdb = skdb;
    this.schema = schema;
  }

  getName(): string {
    return this.schema.name;
  }

  insert(entries: R[] | Inputs, update?: boolean | undefined): void {
    const values = Array.isArray(entries) ? entries : entries.values;
    const columns = !Array.isArray(entries)
      ? entries.columns
      : this.schema.columns.map((c) => c.name);
    const query = toInsertQuery(this.getName(), values, update, columns);
    const params = query.params ? toParams(query.params) : undefined;
    this.skdb.exec(query.query, params);
  }

  update(entry: R, updates: JSONObject): void {
    const query = toUpdateQuery(
      this.getName(),
      this.schema.columns,
      entry,
      updates,
    );
    this.skdb.exec(
      query.query,
      query.params ? toParams(query.params) : undefined,
    );
  }

  updateWhere(where: JSONObject, updates: JSONObject): void {
    const query = toUpdateWhereQuery(this.getName(), where, updates);
    this.skdb.exec(
      query.query,
      query.params ? toParams(query.params) : undefined,
    );
  }

  select(select: JSONObject, columns?: string[]): JSONObject[] {
    const query = toSelectQuery(this.getName(), select, columns);
    return this.skdb.exec(
      query.query,
      query.params ? toParams(query.params) : undefined,
    ) as JSONObject[];
  }

  delete(entry: R): void {
    const query = toDeleteQuery(this.getName(), this.schema.columns, entry);
    this.skdb.exec(
      query.query,
      query.params ? toParams(query.params) : undefined,
    );
  }

  deleteWhere(where: JSONObject): void {
    const query = toDeleteWhereQuery(this.getName(), where);
    this.skdb.exec(
      query.query,
      query.params ? toParams(query.params) : undefined,
    );
  }
  watch = (update: (rows: JSONObject[]) => void, feedback: boolean = false) => {
    const name = feedback
      ? this.getName() + serverResponseSuffix
      : this.getName();
    const query = toSelectQuery(name, {});
    return this.skdb.watch(
      query.query,
      query.params ? toParams(query.params) : {},
      update,
    );
  };

  watchChanges = (
    init: (rows: JSONObject[]) => void,
    update: (added: JSONObject[], removed: JSONObject[]) => void,
    feedback: boolean = false,
  ) => {
    const name = feedback
      ? this.getName() + serverResponseSuffix
      : this.getName();
    const query = toSelectQuery(name, {});
    return this.skdb.watchChanges(
      query.query,
      query.params ? toParams(query.params) : {},
      init,
      update,
    );
  };
}

export class SKStoreImpl implements SKStore {
  private context: Context;

  constructor(context: Context) {
    this.context = context;
    Object.defineProperty(this, "__sk_frozen", {
      enumerable: false,
      writable: false,
      value: true,
    });
  }

  multimap<
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
  >(mappings: Mapping<K1, V1, K2, V2>[]): EagerCollection<K2, V2> {
    let name = "";
    const ctxmapping = mappings.map((mapping) => {
      const params = mapping.params ?? [];
      params.forEach(check);
      /* eslint-disable-next-line @typescript-eslint/no-unsafe-argument */
      const mapperObj = new mapping.mapper(...params);
      Object.freeze(mapperObj);
      name += mapperObj.constructor.name;
      return {
        source: mapping.source,
        mapper: (key: K1, it: NonEmptyIterator<V1>) =>
          mapperObj.mapElement(key, it),
      };
    });
    const eagerHdl = this.context.multimap(name, ctxmapping);
    return new EagerCollectionImpl<K2, V2>(this.context, eagerHdl);
  }

  multimapReduce<
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
  >(
    mappings: Mapping<K1, V1, K2, V2>[],
    accumulator: Accumulator<V2, V3>,
  ): EagerCollection<K2, V3> {
    let name = "";
    const ctxmapping = mappings.map((mapping) => {
      const params = mapping.params ?? [];
      params.forEach(check);
      /* eslint-disable-next-line @typescript-eslint/no-unsafe-argument */
      const mapperObj = new mapping.mapper(...params);
      Object.freeze(mapperObj);
      name += mapperObj.constructor.name;
      return {
        source: mapping.source,
        mapper: (key: K1, it: NonEmptyIterator<V1>) =>
          mapperObj.mapElement(key, it),
      };
    });
    const eagerHdl = this.context.multimapReduce(name, ctxmapping, accumulator);
    return new EagerCollectionImpl<K2, V3>(this.context, eagerHdl);
  }

  lazy<K extends TJSON, V extends TJSON, Params extends Param[]>(
    compute: new (...params: Params) => LazyCompute<K, V>,
    ...params: Params
  ): LazyCollection<K, V> {
    params.forEach(check);
    const computeObj = new compute(...params);
    Object.freeze(computeObj);
    const name = computeObj.constructor.name;
    const lazyHdl = this.context.lazy(
      name,
      (selfHdl: LazyCollection<K, V>, key: K) =>
        computeObj.compute(selfHdl, key),
    );
    return new LazyCollectionImpl<K, V>(this.context, lazyHdl);
  }

  asyncLazy<
    K extends TJSON,
    V extends TJSON,
    P extends TJSON,
    M extends TJSON,
    Params extends Param[],
  >(
    compute: new (...params: Params) => AsyncLazyCompute<K, V, P, M>,
    ...params: Params
  ): LazyCollection<K, Loadable<V, M>> {
    params.forEach(check);
    const computeObj = new compute(...params);
    const name = computeObj.constructor.name;
    Object.freeze(computeObj);
    const lazyHdl = this.context.asyncLazy<K, V, P, M>(
      name,
      (key: K) => computeObj.params(key),
      (key: K, params: P) => computeObj.call(key, params),
    );
    return new LazyCollectionImpl<K, Loadable<V, M>>(this.context, lazyHdl);
  }

  getToken(key: string) {
    return this.context.getToken(key);
  }

  jsonExtract(value: JSONObject, pattern: string): TJSON[] {
    return this.context.jsonExtract(value, pattern);
  }

  log(object: any): void {
    if (
      typeof object == "object" &&
      (("__isArrayProxy" in object && object.__isArrayProxy) ||
        ("__isObjectProxy" in object && object.__isObjectProxy)) &&
      "clone" in object
    ) {
      /* eslint-disable-next-line @typescript-eslint/no-unsafe-call */
      console.log(object.clone());
    } else {
      console.log(object);
    }
  }
}

export class SKStoreFactoryImpl implements SKStoreFactory {
  private context: () => Context;
  private create: (init: () => void, tokens: Record<string, number>) => void;
  private createSync: (
    dbName?: string,
    asWorker?: boolean,
  ) => Promise<SKDBSync>;
  private createKey: (key: string) => Promise<CryptoKey>;

  constructor(
    context: () => Context,
    create: (init: () => void, tokens: Record<string, number>) => void,
    createSync: (dbName?: string, asWorker?: boolean) => Promise<SKDBSync>,
    createKey: (key: string) => Promise<CryptoKey>,
  ) {
    this.context = context;
    this.create = create;
    this.createSync = createSync;
    this.createKey = createKey;
  }

  getName = () => "SKStore";

  runSKStore = async (
    init: (
      skstore: SKStore,
      tables: Record<string, TableCollection<TJSON[]>>,
    ) => void,
    locale: Locale,
    remotes: Record<string, Remote> = {},
    tokens: Record<string, number> = {},
  ): Promise<Record<string, Table<TJSON[]>>> => {
    const context = this.context();
    const tables = await mirror(
      context,
      this.createSync,
      locale,
      remotes,
      this.createKey,
    );
    const skstore = new SKStoreImpl(context);
    this.create(() => {
      init(skstore, tables);
    }, tokens);
    const result: Record<string, Table<TJSON[]>> = {};
    for (const [key, value] of Object.entries(tables)) {
      result[key] = (value as TableCollectionImpl<TJSON[]>).toTable();
    }
    return result;
  };
}

function toWs(entryPoint: EntryPoint) {
  if (entryPoint.secured) return `wss://${entryPoint.host}:${entryPoint.port}`;
  return `ws://${entryPoint.host}:${entryPoint.port}`;
}

/**
 * Mirror Skip tables from SKDB, with support for custom schemas and SQL filters
 * @param context
 * @param createSkdb
 * @param locale
 * @param remotes
 * @param createKey
 * @returns - the mirrors table handles
 */
export async function mirror(
  context: Context,
  createSkdb: () => Promise<SKDBSync>,
  locale: Locale,
  remotes: Record<string, Remote>,
  createKey: (key: string) => Promise<CryptoKey>,
): Promise<Record<string, TableCollection<TJSON[]>>> {
  const tHandles: Record<string, TableCollection<TJSON[]>> = {};
  if (locale.database) {
    remotes["__sk_locale"] = {
      database: locale.database,
      tables: locale.tables,
    };
  } else {
    for (const table of locale.tables) {
      const skdb = await createSkdb();
      const query = create(table);
      skdb.exec(query.query, query.params ? toParams(query.params) : undefined);
      if (table.indexes) {
        const indexes = table.indexes.map((idx) =>
          createIndex(table.name, idx),
        );
        skdb.exec(indexes.join("\n"));
      }
      tHandles[table.name] = new TableCollectionImpl(context, skdb, table);
    }
  }
  for (const remote of Object.values(remotes)) {
    const skdb = await createSkdb();
    const database = remote.database;
    const privateKey = await createKey(database.private);
    await skdb.connect(
      database.name,
      database.access,
      privateKey,
      database.endpoint ? toWs(database.endpoint) : undefined,
    );
    if (!skdb.connectedRemote) {
      throw new Error("Unable to connect to server.");
    }
    for (const table of remote.tables) {
      const with_access =
        table.columns.filter((v) => v.name == "skdb_access").length > 0;
      if (!with_access) {
        table.columns.push({
          name: "skdb_access",
          type: "TEXT",
        });
      }
      const query = create(table);
      await skdb.connectedRemote.exec(
        query.query,
        query.params ? toParams(query.params) : undefined,
      );
      tHandles[table.name] = new TableCollectionImpl(context, skdb, table);
    }
    /* eslint-disable-next-line @typescript-eslint/no-floating-promises */
    const definitions = toMirrorDefinitions(...remote.tables);

    await skdb.mirror(...definitions);
  }
  return tHandles;
}

function toColumn(column: ColumnSchema): string {
  let res = `${column.name} ${column.type}`;
  if (column.notnull) {
    res += " NOT NULL";
  }
  if (column.primary) {
    res += " PRIMARY KEY";
  }
  return res;
}

function toColumns(columns: ColumnSchema[]): string {
  return `(${columns.map(toColumn).join(",")})`;
}

function toMirrorDefinition(table: Schema): MirrorDefn {
  return {
    table: table.name,
    expectedColumns: toColumns(table.columns),
    filterExpr: table.filter ? table.filter.filter : undefined,
    filterParams: table.filter?.params
      ? toParams(table.filter.params)
      : undefined,
  };
}

function toMirrorDefinitions(...tables: Schema[]): MirrorDefn[] {
  return tables.map(toMirrorDefinition);
}

function createIndex(table: string, index: Index): string {
  return `CREATE ${index.unique ? "UNIQUE " : ""}INDEX IF NOT EXISTS ${
    index.name
  } ON ${table}(${index.columns.join(", ")});`;
}

function create(table: Schema): Query {
  const query = `CREATE TABLE IF NOT EXISTS "${table.name}" ${toColumns(
    table.columns,
  )};`;
  return { query };
}

function toValues(entry: TJSON[], prefix: string = ""): Query {
  const exprs: string[] = [];
  const params: JSONObject = {};
  for (let i = 0; i < entry.length; i++) {
    const field = entry[i];
    const prefixedI = `${prefix}${i}`;
    if (
      typeof field == "string" ||
      typeof field == "number" ||
      typeof field == "boolean"
    ) {
      params[prefixedI] = field;
    } else {
      params[prefixedI] = JSON.stringify(field);
    }
    exprs.push(`@${prefixedI}`);
  }
  return {
    query: exprs.join(" , "),
    params,
  };
}

function toWhere(
  columns: ColumnSchema[],
  entry: TJSON[],
  prefix: string = "",
): Query {
  if (columns.length != entry.length) throw new Error("Invalid entry type.");
  const exprs: string[] = [];
  const params: JSONObject = {};
  for (let i = 0; i < columns.length; i++) {
    const column = columns[i];
    const field = entry[i];
    if (Array.isArray(field)) {
      const inVal: string[] = [];
      for (let idx = 0; idx < field.length; idx++) {
        const pName = `${prefix}${idx}_${column.name}`;
        params[pName] = field[idx];
        inVal.push(`@${pName}`);
      }
      exprs.push(`${column.name} IN (${inVal.join(", ")})`);
    } else {
      const pName = `${prefix}${i}_value`;
      params[pName] = field;
      exprs.push(`${column.name} = @${pName}`);
    }
  }
  return {
    query: exprs.join(" AND "),
    params,
  };
}

function toSets(update: JSONObject, prefix: string = ""): Query {
  const exprs: string[] = [];
  const params: JSONObject = {};
  Object.keys(update).forEach((column: string & keyof JSONObject) => {
    const field = update[column];
    const prefixedColumn = `${prefix}${column}`;
    params[prefixedColumn] = field;
    exprs.push(`${column} = @${prefixedColumn}`);
  });
  return {
    query: exprs.join(" , "),
    params,
  };
}

function toSelectWhere(select: JSONObject, prefix: string = ""): Query {
  const keys = Object.keys(select);
  if (keys.length <= 0) return { query: "true" };
  const exprs: string[] = [];
  const params: JSONObject = {};
  keys.forEach((column: keyof JSONObject, c: number) => {
    const field = select[column];
    if (Array.isArray(field) && field.length > 1) {
      const inVal: string[] = [];
      for (let idx = 0; idx < field.length; idx++) {
        const pName = `${prefix}${idx}_${column}`;
        params[pName] = field[idx];
        inVal.push(`@${pName}`);
      }
      exprs.push(`${column} IN (${inVal.join(", ")})`);
    } else {
      const value = Array.isArray(field) ? field[0] : field;
      const pName = `${prefix}${c}_${column}`;
      params[pName] = value;
      exprs.push(`${column} = @${pName}`);
    }
  });
  return {
    query: exprs.join(" AND "),
    params,
  };
}

function toParams(params: JSONObject): Params {
  const res: Record<string, string | number | boolean> = {};
  Object.keys(params).forEach((key: string & keyof JSONObject) => {
    const v = params[key];
    if (typeof v == "string") {
      res[key] = v;
    } else if (typeof v == "number") {
      res[key] = v;
    } else if (typeof v == "boolean") {
      res[key] = v;
    } else {
      res[key] = JSON.stringify(v);
    }
  });
  return res;
}

function toUpdateQuery(
  name: string,
  columns: ColumnSchema[],
  entry: TJSON[],
  updates: JSONObject,
): Query {
  const where = toWhere(columns, entry, "w_");
  const sets = toSets(updates, "u_");
  const query = `UPDATE "${name}" SET ${sets.query} WHERE ${where.query};`;
  return { query, params: { ...sets.params, ...where.params } };
}

function toSelectQuery(
  name: string,
  select: JSONObject,
  columns?: string[],
): Query {
  const where = toSelectWhere(select, "s_");
  const strColumns = columns ? columns.join(", ") : "*";
  const orderBy = columns
    ? " ORDER BY " + columns.map((n) => n + " ASC").join(", ")
    : "";
  const query = `SELECT ${strColumns} FROM "${name}" WHERE ${where.query}${orderBy};`;
  return { query, params: where.params };
}

function toInsertQuery(
  name: string,
  entries: TJSON[][],
  update?: boolean | undefined,
  columns?: string[],
): Query {
  let params: JSONObject = {};
  const values = entries.map((vs, idx) => {
    const q = toValues(vs, `v${idx}_`);
    params = { ...params, ...q.params };
    return q;
  });
  const strColumns =
    columns && columns.length > 0 ? `(${columns.join(",")}) ` : "";
  const strValue = values.map((v) => `(${v.query})`).join(",");
  const query = `INSERT ${
    update ? "OR REPLACE " : ""
  }INTO "${name}" ${strColumns}VALUES ${strValue};`;
  return { query, params };
}

function toDeleteQuery(
  name: string,
  columns: ColumnSchema[],
  entry: TJSON[],
): Query {
  const where = toWhere(columns, entry);
  const query = `DELETE FROM "${name}" WHERE ${where.query};`;
  return { query, params: where.params };
}

function toDeleteWhereQuery(name: string, where: JSONObject): Query {
  const qWhere = toSelectWhere(where, "d_");
  const query = `DELETE FROM "${name}" WHERE ${qWhere.query};`;
  return { query, params: qWhere.params };
}

function toUpdateWhereQuery(
  name: string,
  where: JSONObject,
  updates: JSONObject,
): Query {
  const qWhere = toSelectWhere(where, "uw_");
  const sets = toSets(updates, "us_");
  const query = `UPDATE "${name}" SET ${sets.query} WHERE ${qWhere.query};`;
  return { query, params: { ...sets.params, ...qWhere.params } };
}

export function check<T>(value: T): void {
  const type = typeof value;
  if (type == "string" || type == "number" || type == "boolean") {
    return;
  } else if (type == "object") {
    const jso = value as any;
    if (jso.__sk_frozen) {
      return;
    } else if (Object.isFrozen(jso)) {
      if (Array.isArray(jso)) {
        for (let i = 0; i < length; i++) {
          check(jso[i]);
        }
      } else {
        /* eslint-disable-next-line @typescript-eslint/no-unsafe-argument */
        for (const key of Object.keys(jso)) {
          check(jso[key]);
        }
      }
    } else {
      throw new Error("Invalid object: must be frozen.");
    }
  } else {
    throw new Error("'" + type + "' cannot be manage by skstore.");
  }
}
