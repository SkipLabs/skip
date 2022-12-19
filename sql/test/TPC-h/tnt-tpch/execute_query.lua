local clock = require 'clock'
local getopt = require 'getopt'
local yaml = require 'yaml'

local repeatN = 4
local queryN = nil
local nonoptions = {}
local verbose = false
local debug_output = false
local dryrun = false
local explain = false

local portN = 83301
local mem_size = 10 * 1024^3

local excluded_tests = {}

io.stdout:setvbuf 'no'

local function config(portN, memSz)
    if not dryrun then
        box.cfg{ listen = tonumber(portN), memtx_memory = tonumber(memSz) }
    end
end

-- concatenate lines, but split by ';', if there
-- are multiple statements
local function sql_stmts(qname)
    local f = assert(io.open(qname, "rb"))
    return function()
        local query = {}
        local line

        while true do
            line = f:read('*line')
            if not line then return nil end
            line = string.gsub(line, '%s+', ' ')

            -- skip empty lines or comments
            if not string.match(line, '^%s*$') and
               not string.match(line, '^%-%-.*$')
            then
                table.insert(query, line)
            end
            -- FIXME - assumption that ; is trailing at the line
            if string.match(line, ';%s*$') then break end
        end

        return table.concat(query, ' '):gsub('%s+', ' '):gsub(';', '')
    end
end

local nIndents = {
    Next = -2, Prev = -2,
    VPrev = -2, VNext = -2,
    SorterNext = -2, SorterSort = 2, Sort = 2,
    InitCoroutine = 2, EndCoroutine = -2,
    SeekGE = 2, SeekGT = 2, SeekLT = 2,
    Rewind = 2, RowSetRead = 2,
}
-- local azYield = { "Yield", "SeekLT", "SeekGT", "RowSetRead", "Rewind" }
-- local azGoto = { "Goto" }

local function show_plan(tuples)
    local widths = {4, 13, 4, 4, 4, 13, 2, 13}
    local headers = {'addr', 'opcode', 'p1', 'p2', 'p3', 'p4', 'p5', 'comment'}
    local strike = '-------------------------------------------'

    -- header column names
    local header = ''
    for i = 1, #headers do
        header = header .. string.ljust(headers[i], widths[i] + 1)
    end
    print(header)

    -- header underline
    header = ''
    for i = 1, #headers do
        header = header .. string.sub(strike, 1, widths[i] + 1)
    end
    print(header)

    -- local indentMx = 2 -- multiplier for indents
    local indent = 0

    -- and actual tuples
    for _, row in pairs(tuples.rows) do
        local r = {}
        local addr = row[1]
        local opcode = row[2]

        -- output row address without indents
        table.insert(r, string.ljust(''..addr, widths[1] + 1))

        local n = nIndents[opcode] or 0

        -- reduce indent before Next
        if n < 0 then
            indent = indent + n
        end

        local c = string.ljust('', indent)
        table.insert(r, string.ljust(c..opcode, widths[2] + indent + 1))

        -- output opcode and arguments with indents
        for i = 3, #row do
            local y = row[i] ~= nil and ('' .. row[i]) or ''
            table.insert(r, string.ljust(y, widths[i] + 1))
        end

        -- increase indent for Rewind
        if n > 0 then
            indent = indent + n
        end

        print(table.concat(r))
    end
end

local function exec_query(qname)
    local res, err
    local lines = sql_stmts(qname)
    for query_line in lines do
        if explain then
            query_line = 'explain ' .. query_line
        end
        if verbose then
            print(query_line .. ';;')
        end

        if not dryrun then

            if debug_output then
                box.execute('set session "sql_vdbe_debug" = true')
            end

            res, err = box.execute(query_line)

            if explain then
                show_plan(res)
            elseif verbose then
                if err ~= nil then
                    print(err)
                    return res
                else
                    print(yaml.encode(res))
                end
            end
        end
    end
    return res
end

local function bench(func)
    -- hopefully socket.gettime will provide us microsecond precision
    local t = clock.monotonic()

    for i=1,repeatN,1 do
        local t0 = clock.monotonic()
        func()
        print(i..': '..clock.monotonic() - t0)
    end
    t = clock.monotonic() - t

    -- ignore negligible timings
    if t < (0.002*repeatN) then
        return nil
    end

    return t / repeatN
end

local function single_query(q)
    local t_
    local qname = string.format("queries/%s.sql", q)
    print(qname)
    t_ = bench(
            function()
                exec_query(qname)
            end)
    print("Q"..q .. ';' .. (t_ and t_ or -1))
end

local function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

local banned_set = Set(excluded_tests)

local function show_usage()
    print(arg[-1] .. ' ' .. arg[0],
        [[

            Usage: q:n:p:m:tv

            -q N .. execute query `queries/N.sql`
            -e N .. explain query `queries/N.sql`
            -n N .. repeat N times
            -p N .. listen port N
            -m N .. memtix memory size
            -v   .. verbose (show results)
            -V   .. moch, more verbose (extra run-time execution log)
            -y   .. dry-run
        ]]
    )
end

for opt, v in getopt(arg, 'e:q:n:p:m:yvV', nonoptions) do
    if opt == 'q' then
        queryN = v
     -- explain is kinda dryrun, but with query plain displayed
    elseif opt == 'e' then
        explain = true
        queryN = v
    elseif opt == 'n' then
        repeatN = v
    elseif opt == 'p' then
        portN = v
    elseif opt == 'm' then
        mem_size = v
    elseif opt == 'y' then
        dryrun = true
    elseif opt == 'v' then
        verbose = true
    elseif opt == 'V' then
        verbose = true
        debug_output = true
    elseif opt == '?' then
        show_usage()
        os.exit(1)
    end
end

config(portN, mem_size)

-- if no query selected - process all queries
if queryN == nil then
    for q = 1,22,1 do
        if banned_set[q] == nil then
            single_query(q)
        else
            print('Q'..q..';-2')
        end
    end
else
    assert(queryN)
    single_query(queryN)
end

os.exit(0)
