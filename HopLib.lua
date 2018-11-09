if not HopLib then

  _G.HopLib = {}
  
  dofile(ModPath .. "req/UnitInfoManager.lua")
  dofile(ModPath .. "req/NameProvider.lua")
  
  Hooks:Register("HopLibOnUnitDamaged")
  Hooks:Register("HopLibOnUnitDied")
  Hooks:Register("HopLibOnMinionAdded")
  Hooks:Register("HopLibOnMinionRemoved")
  
  HopLib.mod_path = ModPath
  HopLib.save_path = SavePath
  
  HopLib.language_keys = {
    [Idstring("english"):key()] = "english",
    [Idstring("german"):key()] = "german",
    [Idstring("french"):key()] = "french",
    [Idstring("italian"):key()] = "italian",
    [Idstring("spanish"):key()] = "spanish",
    [Idstring("russian"):key()] = "russian",
    [Idstring("dutch"):key()] = "dutch",
    [Idstring("swedish"):key()] = "swedish"
  }
  
  -- Returns the current NameProvider instance
  function HopLib:name_provider()
    if not self._name_provider then
      self._name_provider = NameProvider:new()
    end
    return self._name_provider
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
    if object == c then
      return true
    end
    local m = getmetatable(object)
    while m do
       if m == c then
         return true
       end
       m = m.super
    end
    return false
  end
  
  -- Returns the language of the game
  function HopLib:get_game_language()
    return self.language_keys[SystemInfo:language():key()] or "english"
  end

end

if RequiredScript then

  local fname = HopLib.mod_path .. "lua/" .. RequiredScript:gsub(".+/(.+)", "%1.lua")
  if io.file_is_readable(fname) then
    dofile(fname)
  end

end