# Schema Migration

This section describes the desired behavior from a user perspective. See below
for internal details.

SKDB supports schema migrations via SQL `alter table` statements, through which
a `root` user can update their database schema in the cloud without incurring
downtime or disrupting existing clients that may still be using an old schema.

## Supported Schema-Change Operations

SKDB only supports *backwards-compatible* schema migrations, such that reads and
writes from clients with out-of-date schemas can still be processed.

Currently-supported schema migrations either **add** a column to a table or
**extract** a column to a one-to-many relation.

To **add** a column, simply use a `ALTER TABLE <table> ADD COLUMN <column-def>`
statement.  In order to maintain backwards-compatibility, the added column must
either be nullable or provide a default value, and must not impose any
uniqueness constraint.

To **extract** a column `c` from a table `t` with primary key column `id`,
construct a transaction that first extracts the current values to a separate
table with `CREATE TABLE t_c AS SELECT c, id, skdb_access, true AS skdb_original
FROM t;`, then drops the old column with `ALTER TABLE t DROP COLUMN c;`.  The
`skdb_original` column is used to identify which extracted data came from the
original table, so as to serve clients on the pre-extraction schema.

## Schema Versioning

Since SKDB enforces that schema migrations are backwards-compatible, there is no
need for explicit schema versioning.  Clients simply request whatever schema
they expect/require, and the server provides data and accepts writes in that
schema, translating to the most up-to-date schema as needed.

This makes schema migrations easy, but can also be used to support different
clients which require different subsets of the data.  For example, if you have
database columns which are only used in your desktop client, then you can
specify a schema without those columns in your iOS client and avoid transferring
more data than necessary over mobile networks.

# Design & Implementation

The primary goal in implementing these features is to make it as transparent as
possible to clients: from their perspective, they are just mirroring a table
with some specified schema, while all translation between schemas happens on the
server side.

There are three main areas to consider:

- **Migration:** how do we interpret/apply the actual schema migration
  operation?
- **Reads:** how do we serve data to clients on legacy schemas?
- **Writes:** how do we process updates from clients on legacy schemas?

## Add Column

### **Migration**

At migration-time, adding a column is easy: we parse the new column definition
and (under a lock) convert the pre-migration data to the new schema.  Existing
tailers can stay alive, as they refer only to column indices strictly less than
that of the added column.

### **Reads**

When a client connects with a schema that is a subset of our server schema
(meaning that they are either unaware of or uninterested in some columns) we
associate with the tailer a `fieldTransform` specifying a subset/permutation of
the existing columns.

For example, if we have a table with schema

```sql
(id INTEGER PRIMARY KEY, x TEXT, y TEXT, skdb_access TEXT, addedCol TEXT)
```

and a client — perhaps unaware of column `addedCol` and/or with a different
preference for column ordering — initiates a mirror with schema

```sql
(x TEXT, y TEXT, skdb_access TEXT, id INTEGER PRIMARY KEY)
```

then the server will record a `fieldTransform` of `[1, 2, 3, 0]` mapping its own
columns to those of the client.

### **Writes**

Since we enforce that added columns are either nullable or provide a default, we
can accept writes on any schema that permutes our columns or elides
nullable/default columns.

The `write-csv` subcommand of the `skdb` CLI now has an `expect-schemas` flag
which, if enabled, causes it to read JSON-encoded client schemas on stdin and
use those schemas to interpret the incoming data.

## Extract Column

Column extraction is significantly more complex than column addition, since (a)
removing a column can affect the index of other columns and (b) reads and writes
from legacy-schema clients need to interact with multiple tables instead of just
applying a per-row transformation.

### **Migration**

At migration-time, we first validate that the column-extraction transaction has
the expected form: a create-table-as-select and corresponding drop-column
statement, maintaining primary-key and `skdb_access` from the source table and
marking extracted data as `skdb_original`.

Then, we apply the following operations in sequence (erroring out of the
transaction if any fail)

(1) Create the new table with the extracted column and populate it from the
existing data of the source table

(2) Set up a virtual view to check the constraint that there is at most 1 row
marked as `skdb_original` in the new table for each primary key

(3) Drop the column from the source table, and error any existing subscriptions
on that table

(4) Create a virtual “legacy view” joining the source table with `skdb_original`
rows of the extracted table, on the primary key, registering it in a directory
`/legacyViews/` with some metadata. Subsequent column extractions proceed
recursively, joining the newly-extracted column onto the previous legacy view
and overwriting the metadata in `/legacyViews/`

### Reads

When a client initiates a mirror with a schema that includes a now-extracted
column, we can serve it from the corresponding legacy view, which we set up at
migration time.  At the data layer, the only real difference here from tailing
any other virtual view is that the server and client have different names for
it: the client knows it as the original table name, and the server as some
legacy view name `__skdb_legacy_schema_...` .  All over-the-wire communication
uses the client name.

### Writes

When `write-csv` receives data from a client that includes some extracted
column(s), it propagates writes to the corresponding tables.  For example,
suppose a client has schema

```sql
CREATE TABLE t (id INTEGER PRIMARY KEY, x TEXT, y TEXT, skdb_access TEXT);
```

but column `y` has been extracted on the server, which now has two tables with
schemas

```sql
CREATE TABLE t (id INTEGER PRIMARY KEY, x TEXT, skdb_access TEXT);
CREATE TABLE t_y (id INTEGER, y TEXT, skdb_access TEXT, skdb_original INTEGER);
```

and we receive CSV data from that legacy client adding two rows to `t` : `(1,
'ONE', 'I', 'read-write')` and `(2, 'TWO', 'II', 'read-write')` .

The server will propagate the necessary data to the proper tables, writing rows
`(1, ‘ONE’, ‘read-write’)` and `(2, 'TWO', 'read-write')` to `t` and rows `(1,
'I', 'read-write', 1)` and `(2, 'II', 'read-write', 1)` to `t_y`.

Some care is required in this case to avoid echoing the writes back to the
legacy-schema client. The pre-existing mechanism compares data sources to
subscriber IDs, and only sends data when they differ.  So, we override the
source field of data as it propagates up to the legacy view so that data sources
in the legacy view maintain the same correspondence with subscribers as they
would in a regular table.
