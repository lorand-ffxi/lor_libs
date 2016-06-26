--[[
    Some functional programming functions
    Author: Ragnarok.Lorand
--]]

local lor_func = {}
lor_func._author = 'Ragnarok.Lorand'
lor_func._version = '2016.06.26'

require('lor/lor_utils')
_libs.req('tables', 'functions')
_libs.lor.functional = lor_func


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
