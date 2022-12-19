local ffi = require 'ffi'
local getopt = require 'getopt'

local nonoptions = {}
local port = 83301
local mem_size = 10 * 1024^3

local function config(portN, memSz)
    box.cfg{ listen = tonumber(portN), memtx_memory = tonumber(memSz) }
end

local function show_usage()
    print(arg[-1] .. ' ' .. arg[0],
        [[

            Usage: m:p:

            -p N .. listen port N
            -m N .. memtx memory size
        ]]
    )
end

for opt, v in getopt(arg, 'm:p:', nonoptions) do
    if opt == 'm' then
        mem_size = v
    elseif opt == 'p' then
        port = v
    elseif opt == '?' then
        show_usage()
        os.exit(1)
    end
end

config(port, mem_size)

-- box.schema.user.drop('guest', {['read,write,execute']= 'universe'})
box.schema.user.grant('guest', 'read,write,execute', 'universe', nil,
                      {if_not_exists = true})

local function create_table(table_ddl)
    print(table_ddl)
    local lowcase = table_ddl:lower()
    local table = string.match(lowcase, '^create%s+table%s+(%a+)%s')
    if not table then return end
    local ddl = string.format('drop table if exists %s', table)
    box.execute(ddl)
    box.execute(table_ddl)
end

create_table [[
CREATE TABLE REGION (
  R_REGIONKEY INTEGER PRIMARY KEY NOT NULL,
  R_NAME      TEXT NOT NULL,
  R_COMMENT   TEXT
)
]]

create_table [[
CREATE TABLE NATION (
  N_NATIONKEY INTEGER PRIMARY KEY NOT NULL,
  N_NAME      TEXT NOT NULL,
  N_REGIONKEY INTEGER NOT NULL,
  N_COMMENT   TEXT,
  FOREIGN KEY (N_REGIONKEY) REFERENCES REGION(R_REGIONKEY)
)
]]

create_table [[
CREATE TABLE PART (
  P_PARTKEY     INTEGER PRIMARY KEY NOT NULL,
  P_NAME        TEXT NOT NULL,
  P_MFGR        TEXT NOT NULL,
  P_BRAND       TEXT NOT NULL,
  P_TYPE        TEXT NOT NULL,
  P_SIZE        INTEGER NOT NULL,
  P_CONTAINER   TEXT NOT NULL,
  P_RETAILPRICE DOUBLE NOT NULL,
  P_COMMENT     TEXT NOT NULL
)
]]

create_table [[
CREATE TABLE SUPPLIER (
  S_SUPPKEY   INTEGER PRIMARY KEY NOT NULL,
  S_NAME      TEXT NOT NULL,
  S_ADDRESS   TEXT NOT NULL,
  S_NATIONKEY INTEGER NOT NULL,
  S_PHONE     TEXT NOT NULL,
  S_ACCTBAL   DOUBLE NOT NULL,
  S_COMMENT   TEXT NOT NULL,
  FOREIGN KEY (S_NATIONKEY) REFERENCES NATION(N_NATIONKEY)
)
]]

create_table [[
CREATE TABLE PARTSUPP (
  PS_PARTKEY    INTEGER NOT NULL,
  PS_SUPPKEY    INTEGER NOT NULL,
  PS_AVAILQTY   INTEGER NOT NULL,
  PS_SUPPLYCOST DOUBLE NOT NULL,
  PS_COMMENT    TEXT NOT NULL,
  PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY),
  FOREIGN KEY (PS_SUPPKEY) REFERENCES SUPPLIER(S_SUPPKEY),
  FOREIGN KEY (PS_PARTKEY) REFERENCES PART(P_PARTKEY)
)
]]

create_table [[
CREATE TABLE CUSTOMER (
  C_CUSTKEY    INTEGER PRIMARY KEY NOT NULL,
  C_NAME       TEXT NOT NULL,
  C_ADDRESS    TEXT NOT NULL,
  C_NATIONKEY  INTEGER NOT NULL,
  C_PHONE      TEXT NOT NULL,
  C_ACCTBAL    DOUBLE NOT NULL,
  C_MKTSEGMENT TEXT NOT NULL,
  C_COMMENT    TEXT NOT NULL,
  FOREIGN KEY (C_NATIONKEY) REFERENCES NATION(N_NATIONKEY)
)
]]

create_table [[
CREATE TABLE ORDERS (
  O_ORDERKEY      INTEGER PRIMARY KEY NOT NULL,
  O_CUSTKEY       INTEGER NOT NULL,
  O_ORDERSTATUS   TEXT NOT NULL,
  O_TOTALPRICE    DOUBLE NOT NULL,
  O_ORDERDATE     DATETIME NOT NULL,
  O_ORDERPRIORITY TEXT NOT NULL,
  O_CLERK         TEXT NOT NULL,
  O_SHIPPRIORITY  INTEGER NOT NULL,
  O_COMMENT       TEXT NOT NULL,
  FOREIGN KEY (O_CUSTKEY) REFERENCES CUSTOMER(C_CUSTKEY)
)
]]

create_table [[
CREATE TABLE LINEITEM (
  L_ORDERKEY      INTEGER NOT NULL,
  L_PARTKEY       INTEGER NOT NULL,
  L_SUPPKEY       INTEGER NOT NULL,
  L_LINENUMBER    INTEGER NOT NULL,
  L_QUANTITY      INTEGER NOT NULL,
  L_EXTENDEDPRICE DOUBLE NOT NULL,
  L_DISCOUNT      DOUBLE NOT NULL,
  L_TAX           DOUBLE NOT NULL,
  L_RETURNFLAG    TEXT NOT NULL,
  L_LINESTATUS    TEXT NOT NULL,
  L_SHIPDATE      DATETIME NOT NULL,
  L_COMMITDATE    DATETIME NOT NULL,
  L_RECEIPTDATE   DATETIME NOT NULL,
  L_SHIPINSTRUCT  TEXT NOT NULL,
  L_SHIPMODE      TEXT NOT NULL,
  L_COMMENT       TEXT NOT NULL,
  PRIMARY KEY (L_ORDERKEY, L_LINENUMBER),
  FOREIGN KEY (L_ORDERKEY) REFERENCES ORDERS(O_ORDERKEY),
  FOREIGN KEY (L_PARTKEY, L_SUPPKEY) REFERENCES PARTSUPP(PS_PARTKEY, PS_SUPPKEY)
)
]]

-- should obey topological sort order
-- to not violate foreign key constraints
local tables = {
  'region', 'nation', 'part', 'supplier',
  'partsupp', 'customer', 'orders', 'lineitem'
  }
for _, tblname in ipairs(tables) do
    local f = assert(io.open(string.format("tpch-dbgen/%s.tbl", tblname), 'rb'))
    print (tblname)

    while true do
        local line = f:read('*line')
        if not line then break end

        local t = {}
        for s in string.gmatch(line, '[^|]+') do
          local cvt = tonumber(s)
          if cvt ~= nil then
            -- hack to retain doubleness for normalized numbers, e.g. 901.00
            if s:match('-?%d+%.%d+$') then
              cvt = ffi.cast('double', cvt)
            end
          -- hack to intercept datetime-like literals and convert to
          -- proper cdata type
          elseif s:match('%d%d%d%d%-%d%d%-%d%d') then
            local datetime = require 'datetime'
            cvt = datetime.parse(s)
          else
            cvt = s
          end
          table.insert(t, cvt)
        end
        local tuple = box.tuple.new(t)

        box.space[tblname:upper()]:insert(tuple)
    end
    f:close()
end

box.snapshot()

os.exit(0)
