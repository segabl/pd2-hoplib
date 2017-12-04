if not HopLib then

  _G.HopLib = {}
  
  dofile(ModPath .. "req/UnitInfoManager.lua")
  dofile(ModPath .. "req/NameProvider.lua")
  
  HopLib.mod_path = ModPath
  HopLib.hooks = table.list_to_set(BLT.Mods:GetMod("HopLib"):GetHooks())
  HopLib.name_provider = NameProvider:new()
  HopLib.unit_info_manager = UnitInfoManager:new(HopLib.name_provider)
  
  Hooks:Register("HopLibOnUnitDamaged")
  Hooks:Register("HopLibOnUnitDied")
  Hooks:Register("HopLibOnEnemyConverted")
  
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