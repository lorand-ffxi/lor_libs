--[[
    Chat log printing functions.
    Author: Ragnarok.Lorand
--]]

require('lor/lor_utils')
_libs.req('maths')
_libs.lor.req('strings', 'functional', 'tables')
_libs.lor.chat = true


function atc(c, msg)
    if (type(c) == 'string') and (msg == nil) then
        msg = c
        c = 0
    end
    windower.add_to_chat(c, windower.to_shift_jis(msg))
end


function pprint(obj, header)
    --[[
        Print all key, value pairs in the given table to the FFXI chat log,
        with an optional header line
    --]]
    if obj ~= nil then
        if header ~= nil then
            atc(2, header)
        end
        if type(obj) == 'table' then
            local c = 0
            local stbl = dmap(tostring, obj)
            local fmt = '%-'..tostring(longest_wstr(stbl:keys()))..'s  :  %s'
            
            for k,v in opairs(stbl) do
                atc(0, fmt:format(k, v))
                c = c + 1
                if ((c % 50) == 0) then
                    atc(160,'---------- ('..c..') ----------')
                end
            end
        else
            atc(0, tostring(obj))
        end
    end
end