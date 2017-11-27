NameProvider = NameProvider or class()

function NameProvider:init()
  self.names = {
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
  self.names.ceiling_turret_module_no_idle = self.names.ceiling_turret_module
  self.names.hector_boss_no_armor = self.names.hector_boss
  self.names.drug_lord_boss_stealth = self.names.drug_lord_boss
  
  self.current_level_id = managers.job and managers.job:current_level_id() or "default"
end

function NameProvider:_create_name_entry_from_tweak_data_id(tweak)
  if not tweak then
    return
  end
  local name = tweak:pretty(true):gsub("Swat", "SWAT"):gsub("Fbi", "FBI")
  self.names[tweak] = { [self.current_level_id] = name }
  return name
end

function NameProvider:name_by_id(tweak)
  if not tweak then
    return
  end
  return not self.names[tweak] and self:_create_name_entry_from_tweak_data_id(tweak) or self.names[tweak][self.current_level_id] or self.names[tweak].default
end