
require('lor/lor_utils')
_libs.req('maths')
_libs.lor.strings = true


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


function string.wlen(s)
    --[[
        Returns a weighted length for the given string given that FFXI's chat
        log font is not fixed-width.
    --]]
    local wl = 0
    for c in s:gmatch('.') do
        if c:match('[fijlrt|!*(){}:;\'"\.,\[\]]') then
            wl = wl + 1.75
        else
            wl = wl + 1.25
        end
    end
    return math.round(wl)
end