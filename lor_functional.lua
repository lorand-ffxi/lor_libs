--[[
    Some functional programming functions
    Author: Ragnarok.Lorand
--]]

local lor_func = {}
lor_func._author = 'Ragnarok.Lorand'
lor_func._version = '2016.06.26'

require('lor/lor_utils')
_libs.req('functions')
_libs.lor.functional = lor_func


max = math.max
min = math.min

lor = lor or {}
lor.fn_and = function(a,b) return a and b end
lor.fn_or = function(a,b) return a or b end
lor.fn_add = function(a,b) return a + b end
lor.fn_sub = function(a,b) return a - b end
lor.fn_mul = function(a,b) return a * b end
lor.fn_div = function(a,b) return a / b end
lor.fn_eq = function(a,b) return a == b end
lor.fn_neq = function(a,b) return a ~= b end
lor.fn_lt = function(a,b) return a < b end
lor.fn_gt = function(a,b) return a > b end
lor.fn_lte = function(a,b) return a <= b end
lor.fn_gte = function(a,b) return a >= b end
lor.fn_get = function(t,k) return t[k] end
lor.fn_in = function(d, k) return d[k] ~= nil end


local trace = {}

--[[
    Returns a customized copy of the given function fn, such that future calls
    of the returned function will always pass the given value val to fn in
    position pos, along with any additional arguments provided.
    Written based on the desire to emulate the 'if' portion of list/dict
    comprehension in Python, such as in the following:
    list = [val for key,val in dict.items() if key in equip_bags]
    Example usage:
    local equip_bags = map(customized(lor.fn_get, player), equip_bag_names)
--]]
function customized(fn, val, pos)
    local p = pos or 1
    return function(...)
        local args = {...}
        table.insert(args, p, val)
        return fn(unpack(args))
    end
end


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


function trace.reduce(fn, ...)
    local args = {...}
    local res = args[1]
    local i = 2
    while i <= #args do
        res = fn(res, args[i])
        i = i + 1
    end
    return res
end

--[[
    Returns the first truthy (possibly non-nil) value.  Unpack tables before
    passing them to this function.
--]]
function lazy_or(...)
    local args = {...}
    local res = args[1]
    local i = 2
    while (i <= #args) and (not res) do
        res = res or args[i]
        i = i + 1
    end
    return res
end


--[[
    Unpack tables before passing them to this function.
--]]
function lazy_and(...)
    local args = {...}
    local res = args[1]
    local i = 2
    while (i <= #args) and res do
        res = res and args[i]
        i = i + 1
    end
    return res
end


--[[
    Returns the result of applying function fnc to every value in tbl
    without modifying tbl.
--]]
function trace.map(fn, tbl)
    local rtbl = {}
    for k,v in pairs(tbl) do
        rtbl[k] = fn(v)
    end
    return rtbl
end


--[[
    Returns the result of applying function fnc to every key in tbl without
    modifying tbl.
--]]
function trace.kmap(fn, tbl)
    local rtbl = {}
    for k,v in pairs(tbl) do
        rtbl[fn(k)] = v
    end
    return rtbl
end


--[[
    Returns the result of applying function fnc to every key and value in
    tbl without modifying tbl.  Useful for applying tostring() to both.
--]]
function trace.dmap(fn, tbl)
    local rtbl = {}
    for k,v in pairs(tbl) do
        rtbl[fn(k)] = fn(v)
    end
    return rtbl
end


--Add the traceable versions of the functions marked to be so to the environment
for fname,fn in pairs(trace) do
    _G[fname] = traceable(fn)
end


return lor_func

-----------------------------------------------------------------------------------------------------------
--[[
Copyright © 2016, Ragnarok.Lorand
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of libs/lor nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Lorand BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]
-----------------------------------------------------------------------------------------------------------
