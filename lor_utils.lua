--[[
    Loader for other libraries written by Lorand.
    As long as this is loaded first in other libraries, then the _libs table
    boilerplate prep is unnecessary in those libraries.
--]]

_libs = _libs or {}
_libs.lor = _libs.lor or {}

if not _libs.lor.utils then
    _libs.lor.utils = true
    _libs.lor.req = function(...)
        for _,libname in pairs({...}) do
            _libs.lor[libname] = _libs.lor[libname] or require('lor/lor_'..libname)
        end
    end
    _libs.req = function(...)
        for _,libname in pairs({...}) do
            _libs[libname] = _libs[libname] or require(libname)
        end
    end
end


