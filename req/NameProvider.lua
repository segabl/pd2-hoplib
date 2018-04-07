NameProvider = NameProvider or class()

NameProvider.TWEAK_REDIRECTS = {
  biker_escape = "biker",
  bolivian_indoors = "bolivian",
  ceiling_turret_module_no_idle = "ceiling_turret_module",
  cop_scared = "cop",
  drug_lord_boss_stealth = "drug_lord_boss",
  hector_boss_no_armor = "hector_boss",
  security_undominatable = "security",
  spa_vip_hurt = "spa_vip"
}

function NameProvider:init()
  self._level_suffix = "_" .. (managers.job and managers.job:current_level_id() or "")
end

function NameProvider:name_by_id(tweak)
  if not tweak then
    return
  end
  tweak = self.TWEAK_REDIRECTS[tweak] or tweak
  local level_name = "unit_name_" .. tweak .. self._level_suffix
  if managers.localization._custom_localizations[level_name] then
    return managers.localization:text(level_name)
  end
  local default_name = "unit_name_" .. tweak
  if not managers.localization._custom_localizations[default_name] then
    managers.localization:add_localized_strings({
      [level_name] = tweak:gsub("_female$", ""):pretty(true):gsub("Swat", "SWAT"):gsub("Fbi", "FBI")
    })
    return managers.localization:text(level_name)
  end
  return managers.localization:text(default_name)
end