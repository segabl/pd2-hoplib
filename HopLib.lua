if not HopLib then

  _G.HopLib = {}
  HopLib.mod_path = ModPath
  HopLib.hooks = table.list_to_set(BLT.Mods:GetMod("HopLib"):GetHooks())
  HopLib.unit_data = {}
  HopLib.name_data = {}
  
  dofile(HopLib.mod_path .. "req/UnitInfo.lua")

  function HopLib:_create_name_self(id)
    local name = id:pretty(true)
    self.name_data[id] = name
    return name
  end
  
  function HopLib:_create_unit_info(unit, u_key)
    local entry = UnitInfo:new(unit, u_key)
    self.unit_data[u_key] = entry
    return entry
  end
  
  -- Returns the name associated with a tweak_data ID
  function HopLib:name_by_id(id)
    return self.name_data[id] or self:_create_name_self(id)
  end
  
  -- Returns a table with information about the unit
  function HopLib:unit_info(unit, u_key)
    u_key = u_key or alive(unit) and unit:u_key()
    if not u_key then
      return
    end
    return self.unit_data[u_key] or self:_create_unit_info(unit, u_key)
  end
  
  -- Checks if an object is of a certain class, either directly or by inheritance
  function HopLib:is_object_of_class(object, class)
    local m = getmetatable(object)
    while m do
       if m == class then
         return true
       end
       m = m.super
    end
    return false
  end
  

end

if HopLib.hooks[RequiredScript] then
  local fname = HopLib.mod_path .. "lua/" .. RequiredScript:gsub(".+/(.+)", "%1.lua")
  if io.file_is_readable(fname) then
    dofile(fname)
  end
end