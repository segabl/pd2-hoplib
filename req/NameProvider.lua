NameProvider = NameProvider or class()

NameProvider.TWEAK_REDIRECTS = {
  ceiling_turret_module_no_idle = "ceiling_turret_module"
}

function NameProvider:init()
  self._unit_mappings = {}
  self._unit_redirects = {}
  local is_client = Network:is_client()
  local char_map = tweak_data.character:character_map()
  -- thanks for forgetting about these 3, Overkill!
  table.insert(char_map.mad.list, "ene_akan_fbi_heavy_r870")
  table.insert(char_map.mad.list, "ene_akan_fbi_shield_dw_sr2_smg")
  table.insert(char_map.mad.list, "ene_akan_cs_heavy_r870")
  for _, cat in pairs(char_map) do
    for _, name in pairs(cat.list) do
      self._unit_mappings[Idstring(is_client and cat.path .. name .. "/" .. name .. "_husk" or cat.path .. name .. "/" .. name):key()] = name
      self._unit_redirects[name] = name:gsub("_[0-9]+$", ""):gsub("_hvh", ""):gsub("^(civ_f?e?male).+", "%1")
    end
  end
end

function NameProvider:name_by_id(tweak)
  if not tweak then
    return
  end
  tweak = self.TWEAK_REDIRECTS[tweak] or tweak
  local name = "name_" .. tweak
  if not managers.localization._custom_localizations[name] then
    managers.localization:add_localized_strings({
      [name] = tweak:pretty(true):gsub("Swat", "SWAT"):gsub("Fbi", "FBI"):gsub("Zeal", "ZEAL")
    })
  end
  return managers.localization:text(name)
end

function NameProvider:name_by_unit(unit)
  if not alive(unit) then
    return
  end
  local unit_name_key = unit:name():key()
  local name = self._unit_mappings[unit_name_key]
  if not unit_name_key or not name then
    return
  end
  if managers.localization._custom_localizations[name] then
    return managers.localization:text(name)
  end
  name = self._unit_redirects[name] or name
  if not managers.localization._custom_localizations[name] then
    managers.localization:add_localized_strings({
      [name] = name:gsub("^[a-z]+_", ""):pretty(true):gsub("Swat", "SWAT"):gsub("Fbi", "FBI"):gsub("Zeal", "ZEAL")
    })
  end
  return managers.localization:text(name)
end