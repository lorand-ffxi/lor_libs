--[[
    String functions
    Author: Ragnarok.Lorand
--]]

local lor_str = {}
lor_str._author = 'Ragnarok.Lorand'
lor_str._version = '2016.06.26'

require('lor/lor_utils')
_libs.req('strings')
_libs.lor.req('functional')
_libs.lor.strings = lor_str


local function colorFor(col)
    local cstr = ''
    if not ((S{256,257}:contains(col)) or (col<1) or (col>511)) then
        if (col <= 255) then
            cstr = string.char(0x1F)..string.char(col)
        else
            cstr = string.char(0x1E)..string.char(col - 256)
        end
    end
    return cstr
end


function string.colorize(str, new_col, reset_col)
    return colorFor(new_col or 1)..str..colorFor(reset_col or 1)
end


--[[
    Returns a weighted length for the given string given that FFXI's chat
    log font is not fixed-width.
--]]
function string.wlen(s)
    local wl = 0
    for c in tostring(s):gmatch('.') do
        if tostring(c):match('[fijlrt|!*(){}:;\'"\.,\[\]]') then
            wl = wl + 1.75
        else
            wl = wl + 1.25
        end
    end
    return math.floor(wl + 0.5)
end


function string.fmts(fmt, ...)
    local args = {...}
    return string.format(fmt, unpack(map(tostring, {...})))
end


function string.join(jstr, ...)
    --Somewhat equivalent to Python's str.join(iterable)
    local tbl = {...}
    local building = ''
    local i = 1
    while i <= #tbl do
        local ele = tbl[i]
        if type(ele) == 'table' then
            ele = string.join(jstr, unpack(ele))
        end
        building = building..((i == 1) and '' or jstr)..tostring(ele)
        i = i + 1
    end
    return building
end


return lor_str

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
