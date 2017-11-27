NameProvider = NameProvider or class()

function NameProvider:init()
  self._names = {
    spooc = { default = "Cloaker" },
    tank_green = { default = "Bulldozer" },
    tank_black = { default = "Blackdozer" },
    tank_skull = { default = "Skulldozer" },
    tank_medic = { default = "Medic Bulldozer" },
    tank_mini = { default = "Minigun Bulldozer" },
    tank_hw = { default = "Headless Titandozer" },
    swat_van_turret_module = { default = "SWAT Turret" },
    ceiling_turret_module = { default = "Ceiling Turret" },
    mobster_boss = { default = "The Commissar" },
    chavez_boss = { default = "Chavez" },
    hector_boss = { default = "Hector Morales" },
    drug_lord_boss = { default = "Ernesto Sosa" },
    old_hoxton_mission = { default = "Hoxton" },
    spa_vip = { default = "Charon" },
    phalanx_vip = { default = "Neville Winters" },
    phalanx_minion = { default = "Phalanx Shield" },
    bank_manager = { default = "Bank Manager", dah = "Ralph Garnet" }
  }
  self._names.ceiling_turret_module_no_idle = self._names.ceiling_turret_module
  self._names.hector_boss_no_armor = self._names.hector_boss
  self._names.drug_lord_boss_stealth = self._names.drug_lord_boss
  
  self._current_level_id = managers.job and managers.job:current_level_id() or "default"
end

function NameProvider:_create_name_entry_from_tweak_data_id(tweak)
  if not tweak then
    return
  end
  local name = tweak:pretty(true):gsub("Swat", "SWAT"):gsub("Fbi", "FBI")
  self._names[tweak] = { [self._current_level_id] = name }
  return name
end

function NameProvider:name_by_id(tweak)
  if not tweak then
    return
  end
  return not self._names[tweak] and self:_create_name_entry_from_tweak_data_id(tweak) or self._names[tweak][self._current_level_id] or self._names[tweak].default
end