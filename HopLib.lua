if not HopLib then

  _G.HopLib = {}
  
  dofile(ModPath .. "req/UnitInfoManager.lua")
  dofile(ModPath .. "req/NameProvider.lua")
  
  Hooks:Register("HopLibOnUnitDamaged")
  Hooks:Register("HopLibOnUnitDied")
  Hooks:Register("HopLibOnEnemyConverted")
  
  HopLib.mod_path = ModPath
  HopLib.save_path = SavePath
  
  -- Returns the current NameProvider instance
  function HopLib:name_provider()
    if not self._name_provider then
      self._name_provider = NameProvider:new()
    end
    return self._name_provider
  end
  
  -- Replaces the default NameProvider with a custom one
  function HopLib:set_name_provider(provider)
    if (self:is_object_of_class(provider, NameProvider)) then
      self._name_provider = provider
    else
      log("[HopLib] ERROR: Trying to use an object as name provider that isn't inherited from NameProvider!")
    end
  end
  
  -- Returns the current UnitInfoManager instance
  function HopLib:unit_info_manager()
    if not self._unit_info_manager then
      self._unit_info_manager = UnitInfoManager:new()
    end
    return self._unit_info_manager
  end
  
  -- Checks if an object is of a certain class, either directly or by inheritance
  function HopLib:is_object_of_class(object, c)
    local m = getmetatable(object)
    while m do
       if m == c then
         return true
       end
       m = m.super
    end
    return false
  end

end

if RequiredScript then

  local fname = HopLib.mod_path .. "lua/" .. RequiredScript:gsub(".+/(.+)", "%1.lua")
  if io.file_is_readable(fname) then
    dofile(fname)
  end

end