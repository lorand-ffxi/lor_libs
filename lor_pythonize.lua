--[[
    Make Lua a bit more like Python to be a bit less annoying!

    Author: Ragnarok.Lorand
--]]

local global = gearswap and gearswap._G or _G
local lor_pythonize = {}
lor_pythonize._author = 'Ragnarok.Lorand'
lor_pythonize._version = '2018.05.26.0'

require('lor/lor_utils')
_libs.lor.pythonize = lor_pythonize


local function isinstance(obj, ...)
    local obj_type = type(obj)
    for _, val in pairs({...}) do
        if obj_type == val then return true end
    end
    if obj_type == 'nil' then return false end  -- nil would have been caught above if it was specified

    local meta = getmetatable(obj)
    local obj_class = (obj.__class__ or obj.__class) or meta and (meta.__class__ or meta.__class)
    if obj_class then
        for _, val in pairs({...}) do
            if obj_class == val then return true end
        end
    end

    if meta then
        local mro = meta.__mro__
        if mro then
            for _, cls in pairs(mro) do
                for _, val in pairs({...}) do
                    if cls.__class__ == val then return true end
                end
            end
        end
    end

    return false
end
lor_pythonize.isinstance = isinstance


local function mro(obj)
    local order = {}
    local order_set = {}
    local i = 1

    local meta = getmetatable(obj)
    if meta and meta.__cls__ then obj = meta.__cls__ end

    if obj.__mro__ then
        for _,cls in pairs(obj.__mro__) do
            if not order_set[cls] then
                order_set[cls] = true
                order[i] = cls
                i = i + 1
                if cls ~= obj then
                    for _,bcls in pairs(mro(cls)) do
                        if not order_set[bcls] then
                            order_set[bcls] = true
                            order[i] = bcls
                            i = i + 1
                        end
                    end
                end
            end
        end
    else
        meta = getmetatable(obj)
        if meta.__mro__ then
            for _,cls in pairs(meta.__mro__) do
                if not order_set[cls] then
                    order_set[cls] = true
                    order[i] = cls
                    i = i + 1
                    if cls ~= obj then
                        for _,bcls in pairs(mro(cls)) do
                            if not order_set[bcls] then
                                order_set[bcls] = true
                                order[i] = bcls
                                i = i + 1
                            end
                        end
                    end
                end
            end
        end
    end
    return order
end
lor_pythonize.mro = mro


local function Class(cls_tbl, ...)
    local bases = {...}
    table.insert(bases, 1, cls_tbl)

    local function index(obj, key)
        local val = rawget(obj, key)
        if val ~= nil then return val end
        for _, cls in pairs(mro(obj)) do
            local val = cls[key]
            if val ~= nil then
                --if key ~= '__class__' then plog('%s.%s => %s.%s', obj.__class__, key, cls.__class__, key) end
                return val
            end
        end
    end
    local meta = {__index = index, __cls__ = cls_tbl}

    local init = function(...)
        local args = {...}
        local self = cls_tbl.__init__ and cls_tbl.__init__(unpack(args)) or args
        return setmetatable(self, meta)
    end
    setmetatable(cls_tbl, {__call = init, __mro__ = bases})

    local _mro = mro(cls_tbl)
    for i=#_mro,1,-1 do
        local cls = _mro[i]
        for func_name, func in pairs(cls) do
            if func_name:startswith('__') then
                meta[func_name] = func
            end
        end
    end

    return cls_tbl
end
lor_pythonize.Class = Class


local function dir(cls)
    local attrs = {}
    local c = 1
    local _mro = mro(cls)
    for i=#_mro,1,-1 do
        local cls = _mro[i]
        for func_name, func in pairs(cls) do
            attrs[c] = func_name
            c = c + 1
        end
    end
end
lor_pythonize.dir = dir


local ABC = {}
ABC.Iterable = Class{
    __class__ = 'Iterable',
    iter = function(self)
        local key = nil
        return function()
            key = next(self, key)
            return self[key]
        end
    end
}
ABC.Sized = Class{
    __class__ = 'Sized',
    __len = function(self)
        local c = 0
        for k, v in pairs(self) do c = c + 1 end
        return c
    end
}
ABC.Container = Class{
    __class__ = 'Container',
    contains = function(self, item)
        for k, v in pairs(self) do
            if v == item then return true end
        end
        return false
    end,
    clear = function(self)
        --[[
        Implemented here because it is a common implementation, even though it makes some not-strictly mutable
        subclasses mutable...  It would have to be pasted in many places!
        --]]
        for i,_ in pairs(self) do self[i] = nil end
    end
}
ABC.Set = Class(
    {
        __class__ = 'Set',
        __eq = function(self, other)
            if other.__class__ ~= self.__class__ then return false end
            local own_len = 0
            for k,_ in pairs(self) do
                own_len = own_len + 1
                if not other[k] then return false end
            end
            return own_len == #other
        end,
        contains = function(self, item)
            return self[item] ~= nil
        end,
        iter = function(self, sorted)
            local key = nil
            return function()
                key = next(self, key)
                return key
            end
        end,
        isdisjoint = function(self, other)
            -- Return true if two sets have a null intersection (no common values).
            for value in other:iter() do
                if self:contains(value) then return false end
            end
            return true
        end
    },
    ABC.Iterable, ABC.Sized, ABC.Container
)
ABC.Mapping = Class(
    {
        __class__ = 'Mapping',
        __eq = function(self, other)
            if other.__class__ ~= self.__class__ then return false end
            local own_len = 0
            for k,v in pairs(self) do
                own_len = own_len + 1
                if other[k] ~= v then return False end
            end
            return own_len == #other
        end,
        contains = function(self, item)
            return self[item] ~= nil
        end,
        get = function(self, key, default)
            local val = self[key]
            if val == nil then return default else return val end
        end,
        iter = function(self)
            local key = nil
            return function()
                key = next(self, key)
                return key
            end
        end,
        keys = function(self)
            local key = nil
            return function()
                key = next(self, key)
                return key
            end
        end,
        items = function(self)
            local key = nil
            return function()
                key = next(self, key)
                return key, self[key]
            end
        end,
        values = function(self)
            local key = nil
            return function()
                key = next(self, key)
                return self[key]
            end
        end
    },
    ABC.Iterable, ABC.Sized, ABC.Container
)
ABC.MutableMapping = Class(
    {
        __class__ = 'MutableMapping',
        pop = function(self, key)
            local val = self[key]
            self[key] = nil
            return val
        end,
        popitem = function(self)
            for key in self:iter() do
                local val = self[key]
                self[key] = nil
                return key, val
            end
        end,
        setdefault = function(self, key, default)
            local val = self[key]
            if val == nil then
                self[key] = default
                return default
            end
            return val
        end
    },
    ABC.Mapping
)
ABC.Sequence = Class(
    {
        __class__ = 'Sequence',
        iter = function(self)
            local key = nil
            return function()
                key = next(self, key)
                return self[key]
            end
        end,
        __eq = function(self, other)
            if other.__class__ ~= self.__class__ then return false end
            local own_len = 0
            for i,v in ipairs(self) do
                own_len = own_len + 1
                if other[i] ~= v then return false end
            end
            return own_len == #other
        end,
        index = function(self, value)
            for i,v in pairs(self) do
                if v == value then
                    return i
                end
            end
        end,
        count = function(self, value)
            local c = 0
            for _,v in pairs(self) do
                if v == value then c = c + 1 end
            end
            return c
        end,
    },
    ABC.Iterable, ABC.Sized, ABC.Container
)
ABC.MutableSequence = Class(
    {
        __class__ = 'MutableSequence',
        insert = function(self, index, value)
            index = (index <= #self) and index or #self + 1
            table.insert(self, index, value)
        end,
        append = function(self, value)
            table.insert(self, value)
        end,
        extend = function(self, other)
            local i = #self + 1
            if isinstance(other, 'function') then
                for v in other do
                    self[i] = v
                    i = i + 1
                end
            else
                for _,v in pairs(other) do
                    self[i] = v
                    i = i + 1
                end
            end
        end,
        pop = function(self, index)
            index = (index ~= nil) and index or #self
            local val = self[index]
            self[index] = nil
            return val
        end,
        remove = function(self, value)
            for i,v in pairs(self) do
                if v == value then
                    table.remove(self, i)
                    return
                end
            end
        end,
    },
    ABC.Sequence
)
lor_pythonize.ABC = ABC


local list = Class({
    __class__ = 'list',
    __init__ = function(cls, t)
        local self = {}
        list.extend(self, t)
        return self
    end,
    __tostring = function(self)
        local t, i = {}, 1
        for _,v in pairs(self) do
            local fmt = (type(v) == "string") and '%q' or '%s'
            t[i] = fmt:format(v)
            i = i + 1
        end
        return 'list{' .. table.concat(t, ', ') .. '}'
    end,
    sort = function(self)
        table.sort(self)
    end,
    reverse = function(self)
        local i = 1
        for j=#self, #self/2 + 1, -1 do
            self[i], self[j] = self[j], self[i]
            i = i + 1
        end
    end,
}, ABC.MutableSequence)
lor_pythonize.list = list


local set = Class({
    __class__ = 'set',
    __init__ = function(cls, t)
        local self = {}
        set.update(self, t)
        return self
    end,
    __pairs = function(self)
        local key = nil
        return function()
            key = next(self, key)
            return key, key
        end
    end,
    __tostring = function(self)
        local t, i = {}, 1
        for k,_ in pairs(self) do
            local fmt = (type(k) == "string") and '%q' or '%s'
            t[i] = fmt:format(k)
            i = i + 1
        end
        return 'set{' .. table.concat(t, ', ') .. '}'
    end,
    to_table = function(self)
        local t, i = {}, 1
        for k,_ in pairs(self) do t[i] = k; i = i + 1 end
        return t
    end,
    iter = function(self, sorted)
        local key = nil
        if sorted then
            local tbl = self:to_table()
            table.sort(tbl)
            return function()
                key = next(tbl, key)
                return tbl[key]
            end
        else
            return function()
                key = next(self, key)
                return key
            end
        end
    end,
    add = function(self, value)
        self[value] = true
    end,
    remove = function(self, value)
        self[value] = nil
    end,
    update = function(self, iterable)
        iterable = iterable or {}
        if isinstance(iterable, 'function') then
            for v in iterable do self[v] = true end
        else
            for _,v in pairs(iterable) do self[v] = true end
        end
    end
}, ABC.Set)
lor_pythonize.set = set


local dict = Class({
    __class__ = 'dict',
    __init__ = function(_, t)
        local self = {}
        dict.update(self, t)
        return self
    end,
    __tostring = function(self)
        local t, i = {}, 1
        for k, v in pairs(self) do
            local kfmt = (type(k) == "string") and '%q' or '%s'
            local vfmt = (type(v) == "string") and '%q' or '%s'
            local fmt = ('[%s]=%s'):format(kfmt, vfmt)
            t[i] = fmt:format(k, v)
            i = i + 1
        end
        return 'dict{' .. table.concat(t, ', ') .. '}'
    end,
    update = function(self, iterable)
        iterable = iterable or {}
        if isinstance(iterable, 'function') then
            for k, v in iterable do self[k] = v end
        else
            for k, v in pairs(iterable) do self[k] = v end
        end
    end,
}, ABC.Mapping)
lor_pythonize.dict = dict


function lor_pythonize.make_global()
    for k, v in pairs(lor_pythonize) do
        if k ~= 'make_global' then
            global[k] = v
        end
    end
end


return lor_pythonize

-----------------------------------------------------------------------------------------------------------
--[[
Copyright © 2018, Ragnarok.Lorand
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of libs/lor nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Lorand BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]
-----------------------------------------------------------------------------------------------------------
