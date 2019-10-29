NameProvider = NameProvider or class()

NameProvider.TWEAK_REDIRECTS = {
  ceiling_turret_module_no_idle = "ceiling_turret_module",
  ceiling_turret_module_longer_range = "ceiling_turret_module"
}
NameProvider.UNIT_MAPPIGS = {}
NameProvider.UNIT_REDIRECTS = {}
NameProvider.CLIENT_TO_SERVER_MAPPING = {}

local is_client = Network:is_client()
local function strip_weapon_name(name)
  local oname = name
  for _, w in pairs(tweak_data.character.weap_ids) do
    name = name:gsub("_" .. w .. "$", "")
    if name ~= oname then
      break
    end
  end
  return name
end
local char_map = tweak_data.character:character_map()
-- thanks for not adding these, Overkill >.>
table.insert(char_map.basic.list, "ene_city_swat_r870")
table.insert(char_map.basic.list, "ene_city_shield")
table.insert(char_map.basic.list, "ene_fbi_heavy_r870")
table.insert(char_map.basic.list, "ene_swat_heavy_r870")
table.insert(char_map.mad.list, "ene_akan_fbi_heavy_r870")
table.insert(char_map.mad.list, "ene_akan_fbi_shield_dw_sr2_smg")
table.insert(char_map.mad.list, "ene_akan_cs_heavy_r870")
table.insert(char_map.friend.list, "ene_drug_lord_boss_stealth")
table.insert(char_map.friend.list, "ene_thug_indoor_03")
table.insert(char_map.friend.list, "ene_thug_indoor_04")
local client_key, server_key
for _, cat in pairs(char_map) do
  for _, name in pairs(cat.list) do
    server_key = Idstring(cat.path .. name .. "/" .. name):key()
    client_key = Idstring(cat.path .. name .. "/" .. name .. "_husk"):key()
    NameProvider.UNIT_MAPPIGS[server_key] = name
    NameProvider.CLIENT_TO_SERVER_MAPPING[client_key] = server_key
    NameProvider.UNIT_REDIRECTS[name] = strip_weapon_name(name:gsub("_[0-9]+$", "")):gsub("_hvh", ""):gsub("^(civ_f?e?male).+", "%1")
  end
end

function NameProvider:name_by_id(tweak)
  if not tweak then
    return
  end
  tweak = self.TWEAK_REDIRECTS[tweak] or tweak
  local name = "tweak_" .. tweak
  if not managers.localization._custom_localizations[name] then
    managers.localization:add_localized_strings({
      [name] = tweak:pretty(true)
    })
  end
  return managers.localization:text(name)
end

function NameProvider:name_by_unit(unit, u_key)
  u_key = u_key or alive(unit) and unit:name():key()
  if not u_key then
    return
  end
  local name = self.UNIT_MAPPIGS[is_client and self.CLIENT_TO_SERVER_MAPPING[u_key] or u_key]
  if not name then
    return
  end
  if managers.localization._custom_localizations[name] then
    return managers.localization:text(name)
  end
  local redir_name = self.UNIT_REDIRECTS[name]
  if managers.localization._custom_localizations[redir_name] then
    return managers.localization:text(redir_name)
  end
  managers.localization:add_localized_strings({
    [name] = redir_name:gsub("^[a-z]+_", ""):pretty(true)
  })
  return managers.localization:text(name)
end