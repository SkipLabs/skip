--- getopt(3)-like functionality for Lua 5.1 and later
-- This is free and unencumbered software released into the public domain.

--- getopt(argv, optstring [, nonoptions])
--
-- Returns a closure suitable for "for ... in" loops. On each call the
-- closure returns the next (option, optarg). For unknown options, it
-- returns ('?', option). When a required optarg is missing, it returns
-- (':', option). It's reasonable to continue parsing after errors.
-- Returns nil when done.
--
-- The optstring follows the same format as POSIX getopt(3). However,
-- this function will never print output on its own.
--
-- Non-option arguments are accumulated, in order, in the optional
-- "nonoptions" table. If a "--" argument is encountered, appends the
-- remaining arguments to the nonoptions table and returns nil.
--
-- The input argv table is left unmodified.
local function getopt(argv, optstring, nonoptions)
    local optind = 1
    local optpos = 2
    nonoptions = nonoptions or {}
    return function()
        while true do
            local arg = argv[optind]
            if arg == nil then
                return nil
            elseif arg == '--' then
                for i = optind + 1, #argv do
                    table.insert(nonoptions, argv[i])
                end
                return nil
            elseif arg:sub(1, 1) == '-' then
                local opt = arg:sub(optpos, optpos)
                local start, stop = optstring:find(opt .. ':?')
                if not start then
                    optind = optind + 1
                    optpos = 2
                    return '?', opt
                elseif stop > start and #arg > optpos then
                    local optarg = arg:sub(optpos + 1)
                    optind = optind + 1
                    optpos = 2
                    return opt, optarg
                elseif stop > start then
                    local optarg = argv[optind + 1]
                    optind = optind + 2
                    optpos = 2
                    if optarg == nil then
                        return ':', opt
                    end
                    return opt, optarg
                else
                    optpos = optpos + 1
                    if optpos > #arg then
                        optind = optind + 1
                        optpos = 2
                    end
                    return opt, nil
                end
            else
                optind = optind + 1
                table.insert(nonoptions, arg)
            end
        end
    end
end

return getopt