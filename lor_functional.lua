--[[
    Adds some convenience functions.
    Author: Ragnarok.Lorand
--]]

require('lor/lor_utils')
_libs.req('tables', 'functions')
_libs.lor.functional = true


function all_eq(val, ...)
    --Returns true iff every argument is equal to val
    for _,arg in pairs({...}) do
        if arg ~= val then return false end
    end
    return true
end


function any_eq(val, ...)
    --Returns true if one or more aguments are equal to val
    for _,arg in pairs({...}) do
        if arg == val then return true end
    end
    return false
end


function map(fn, tbl)
    --[[
        Returns the result of applying function fn to every value in tbl without
        modifying tbl.
    --]]
    local rtbl = T()
    for k,v in pairs(tbl) do
        rtbl[k] = fn(v)
    end
    return rtbl
end


function kmap(fn, tbl)
    --[[
        Returns the result of applying function fn to every key in tbl without
        modifying tbl.
    --]]
    local rtbl = T()
    for k,v in pairs(tbl) do
        rtbl[fn(k)] = v
    end
    return rtbl
end


function dmap(fn, tbl)
    --[[
        Returns the result of applying function fn to every key and value in tbl
        without modifying tbl.  Useful for applying tostring() to both.
    --]]
    local rtbl = T()
    for k,v in pairs(tbl) do
        rtbl[fn(k)] = fn(v)
    end
    return rtbl
end


