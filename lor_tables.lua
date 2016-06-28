--[[
    Table functions.
    Sorted table iteration based on: http://lua-users.org/wiki/SortedIteration
    Author: Ragnarok.Lorand
]]

local lor_tables = {}
lor_tables._author = 'Ragnarok.Lorand'
lor_tables._version = '2016.06.26'

require('lor/lor_utils')
_libs.req('tables')
_libs.lor.tables = lor_tables


function sizeof(tbl)
    local c = 0
    for _,_ in pairs(tbl) do c = c + 1 end
    return c
end


function table.first_value(tbl)
    if tbl == nil then return nil end
    if sizeof(tbl) == 0 then return nil end
    for k,v in pairs(tbl) do
        return v
    end
end


function table.keys(t)
    local ktbl = {}
    local i = 1
    for k,_ in pairs(t) do
        ktbl[i] = k
        i = i + 1
    end
    return ktbl
end


function table.values(t)
    local vals = {}
    local i = 1
    for _,v in pairs(t) do
        vals[i] = v
        i = i + 1
    end
    return vals
end


function table.invert(t)
    local i = {}
    for k,v in pairs(t) do 
        i[v] = k
    end
    return i
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


local function genOrderedIndex(t)
    local tbl = {}
    for k,_ in pairs(t) do
        table.insert(tbl, k)
    end
    table.sort(tbl, cmp)
    return tbl
end


local function orderedNext(t, state)
    -- Equivalent to the next function, but returns keys in order
    key = nil
    if state == nil then
        t.__orderedIndex = genOrderedIndex(t)
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


return lor_tables

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
