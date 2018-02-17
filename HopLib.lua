if not HopLib then

  _G.HopLib = {}
  
  dofile(ModPath .. "req/UnitInfoManager.lua")
  dofile(ModPath .. "req/NameProvider.lua")
  
  Hooks:Register("HopLibOnUnitDamaged")
  Hooks:Register("HopLibOnUnitDied")
  Hooks:Register("HopLibOnEnemyConverted")
  
  HopLib.mod_path = ModPath
  HopLib.save_path = SavePath
  
  HopLib.name_providers = {
    default = NameProvider
  }
  
  HopLib.settings = {
    name_provider = "default"
  }
  
  -- Returns the current NameProvider instance
  function HopLib:name_provider()
    if not self._name_provider then
      local provider = self.name_providers[self.settings.name_provider] or self.name_providers.default
      self._name_provider = provider:new()
    end
    return self._name_provider
  end
  
  -- Registers a custom name provider that can be selected by the user
  function HopLib:register_name_provider(name, provider_class)
    if (self:is_object_of_class(provider_class, NameProvider)) then
      if not self.name_providers[name] then
        self.name_providers[name] = provider
      else
        log("[HopLib] ERROR: name provider with name \"" .. name .. "\" already exists!")
      end
    else
      log("[HopLib] ERROR: Trying to register a name provider that isn't inherited from NameProvider!")
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
  
  -- Internal functions from here on
  function HopLib:load()
    local file = io.open(self.save_path .. "HopLib.txt", "r")
    if file then
      local data = json.decode(file:read("*all")) or {}
      file:close()
      for k, v in pairs(data) do
        self.settings[k] = v
      end
    end
  end
  
  function HopLib:save()
    local file = io.open(self.save_path .. "HopLib.txt", "w+")
    if file then
      file:write(json.encode(self.settings))
      file:close()
    end
  end
  
  -- Load settings
  HopLib:load()

end

if RequiredScript then

  local fname = HopLib.mod_path .. "lua/" .. RequiredScript:gsub(".+/(.+)", "%1.lua")
  if io.file_is_readable(fname) then
    dofile(fname)
  end

end