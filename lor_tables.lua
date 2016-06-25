--[[
    Table functions.
    Sorted table iteration based on: http://lua-users.org/wiki/SortedIteration
    Author: Ragnarok.Lorand
]]

require('lor/lor_utils')
_libs.req('tables', 'maths')
_libs.lor.req('strings')
_libs.lor.tables = true


function sizeof(tbl)
    local c = 0
    for _,_ in pairs(tbl) do c = c + 1 end
    return c
end


function table.keys(t)
    local keys = T()
    local i = 1
    for k,_ in pairs(t) do
        keys[i] = k
        i = i + 1
    end
    return keys
end


function table.values(t)
    local vals = T()
    local i = 1
    for _,v in pairs(t) do
        vals[i] = v
        i = i + 1
    end
    return vals
end


function longest_wstr(tbl)
    return math.max(unpack(map(string.wlen, tbl)))
end


function longest_str(tbl)
    return math.max(unpack(map(string.len, tbl)))
end


function longest_key_len(tbl)
    return longest_str(map(tostring, T(tbl):keys()))
end


local function cmp(obj1, obj2)
    --Compare obj1 to obj2
    local t1, t2 = type(obj1), type(obj2)
    if t1 ~= t2 then
        --Type mismatch: compare types
        return t1 < t2
    --If not a type mismatch, t1 == t2, so only t1 will be used going forward
    elseif t1 == "boolean" then
        return obj1
    elseif any_eq(t1, "number", "string") then
        return obj1 < obj2
    else
        return tostring(obj1) < tostring(obj2)
    end
end


local function __genOrderedIndex(t)
    local tbl = T()
    for key in pairs(t) do
        tbl:insert(key)
    end
    tbl:sort(cmp)
    return tbl
end


local function orderedNext(t, state)
    -- Equivalent to the next function, but returns keys in order
    key = nil
    if state == nil then
        t.__orderedIndex = __genOrderedIndex(t)
        key = t.__orderedIndex[1]
    else
        for i = 1, table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end
    
    if key then
        return key, t[key]
    end
    t.__orderedIndex = nil
    return
end


function opairs(t)
    return orderedNext, t, nil
end
