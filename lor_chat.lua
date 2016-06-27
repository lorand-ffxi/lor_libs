--[[
    Chat log printing / output functions
    Author: Ragnarok.Lorand
--]]

local lor_chat = {}
lor_chat._author = 'Ragnarok.Lorand'
lor_chat._version = '2016.06.26'


--[[
    If loaded from GearSwap, use the true windower methods instead of the ones
    overwritten by GearSwap.  Some issues and crashes were experienced while
    using the overwritten methods.
--]]
lor_chat._windower = gearswap and gearswap._G.windower or windower

require('lor/lor_utils')
_libs.req('maths', 'strings', 'tables')
_libs.lor.req('functional', 'strings', 'tables')
_libs.lor.chat = lor_chat


function atc(...)
    local args = T({...})
    local c = 0
    if type(args[1]) == 'number' then
        c = args[1]
        args = args:slice(2)
    end
    local msg = lor_chat._windower.to_shift_jis(" ":join(args))
    lor_chat._windower.add_to_chat(c, msg)
end


function atcc(...)
    local args = T({...})
    local c = 0
    if type(args[1]) == 'number' then
        c = args[1]
        args = args:slice(2)
    end
    local msg = lor_chat._windower.to_shift_jis(" ":join(args))
    lor_chat._windower.add_to_chat(0, msg:colorize(c))
end


function atcs(msg)
    lor_chat._windower.add_to_chat(0, windower.to_shift_jis(tostring(msg)))
end


function atcd(c, msg)
	if show_debug then
		atc(c, msg)
	end
end


--[[
    Formatted Add to Chat - The first arg is used as the color if it's numeric.
    The next argument is used as the format string, and remaining arguments
    are passed in to be formatted in the string.
--]]
function atcf(...)
    local args = T({...})
    local c = 0
    if type(args[1]) == 'number' then
        c = args[1]
        args = args:slice(2)
    end
    
    if #args < 2 then
        lor_chat._windower.add_to_chat(c, tostring(args[1]))
    else
        lor_chat._windower.add_to_chat(c, string.format(args[1], unpack(args:slice(2))))
    end
end


--[[
    String-Formatted Add to Chat - Works as atcf above, but all args are
    converted to strings before being passed in to string.format.
--]]
function atcfs(...)
    local args = T({...})
    local c = 0
    if type(args[1]) == 'number' then
        c = args[1]
        args = args:slice(2)
    end
    
    if #args < 2 then
        lor_chat._windower.add_to_chat(c, tostring(args[1]))
    else
        lor_chat._windower.add_to_chat(c, string.format(args[1], unpack(map(tostring, args:slice(2)))))
    end
end


function echo(msg)
	if (msg ~= nil) then
        local prefix = ''
        if _addon and _addon.name then
            prefix = '['.._addon.name..']'
        end
		windower.send_command('echo %s%s':format(prefix, msg))
	end
end


--[[
    Pretty Print the given object, optionally with a header line
--]]
function pprint(obj, header)
    if obj ~= nil then
        if header ~= nil then
            atc(2, header)
        end
        if type(obj) == 'table' then
            if sizeof(obj) < 1 then
                atc('{}')
                return
            end
            local c = 0
            local lwkl = max(unpack(map(string.wlen, table.keys(obj))))
            local fmt = '%-'..tostring(lwkl)..'s  :  %s'
            for k,v in opairs(obj) do
                if (c ~= 0) and ((c % 30) == 0) then
                    atc(160,'---------- ('..c..') ----------')
                end
                atcfs(fmt, k, v)
                c = c + 1
            end
        else
            atc(0, tostring(obj))
        end
    else
        atc(0, tostring(obj))
    end
end


return lor_chat

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
