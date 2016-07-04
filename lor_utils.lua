--[[
    Loader for other libraries written by Lorand.
    As long as this is loaded first in other libraries, then the _libs table
    boilerplate prep is unnecessary in those libraries.
--]]

local lor_utils = {}
lor_utils._version = '2016.07.04'
lor_utils._author = 'Ragnarok.Lorand'
lor_utils.load_order = {'functional','math','strings','tables','chat','exec'}

_libs = _libs or {}
_libs.lor = _libs.lor or {}

if not _libs.lor.utils then
    _libs.lor.utils = lor_utils
    _libs.strings = _libs.strings or require('strings')
    
    lor = lor or {}
    lor.G = gearswap and gearswap._G or _G
    xpcall = lor.G.xpcall
    lor.watc = lor.G.windower.add_to_chat
    
    function _handler(err)
        --[[
            Error handler to print the stack trace of the error.
            Example use:
            local fmt = nil
            local status = xpcall(function() fmt = '%-'..tostring(longest_wstr(stbl:keys()))..'s  :  %s' end, _handler)
            if status then return nil end
        --]]
        local st_re = '([^/]+/[^/]+%.lua:.*)'
        local tb_str = debug.traceback()
        local tb = tb_str:split('\n')
        tb = tb:slice(2)
        tb = tb:reverse()
        tb = T({'stack traceback:'}):extend(tb)
        tb:append(err)
        for _,tl in pairs(tb) do
            if (type(tl) == 'string') and (not tl:match('%[C%]: in function \'xpcall\'')) then
                local trunc_line = tl:match(st_re)
                if trunc_line then
                    lor.watc(167, tostring(trunc_line))
                else
                    lor.watc(167, tostring(tl))
                end
            end
        end
    end
    
    --[[
        Wrapper for functions so that calls to them resulting in exceptions will
        generate stack traces.
    --]]
    function traceable(fn)
        return function(...)
            local args = {...}
            local res = nil
            local status = xpcall(function() res = fn(unpack(args)) end, _handler)
            return res
        end
    end
    
    local function t_contains(t, val)
        --Used for enforcing the load order without loading the tables library
        for _,v in pairs(t) do
            if v == val then return true end
        end
        return false
    end
    
    _libs.lor.req = function(...)
        local args = {...}
        if (#args == 1) and (args[1]:lower() == 'all') then
            for _,lname in pairs(lor_utils.load_order) do
                _libs.lor[lname] = _libs.lor[lname] or require('lor/lor_'..lname)
            end
        else
            for _,lname in pairs(lor_utils.load_order) do
                if t_contains(args, lname) then
                    _libs.lor[lname] = _libs.lor[lname] or require('lor/lor_'..lname)
                end
            end
        end
    end
    
    _libs.req = function(...)
        for _,lname in pairs({...}) do
            _libs[lname] = _libs[lname] or require(lname)
        end
    end
    
    lor.G.collectgarbage()
end


return lor_utils

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
