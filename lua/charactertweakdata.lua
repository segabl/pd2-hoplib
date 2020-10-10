local character_map_original = CharacterTweakData.character_map
function CharacterTweakData:character_map(...)
  local char_map = character_map_original(self, ...)

  -- Add missing entries to the character map
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
  table.insert(char_map.bex.list, "ene_swat_policia_federale_fbi")
  table.insert(char_map.bex.list, "ene_swat_policia_federale_fbi_r870")

  Hooks:Call("HopLibOnCharacterMapCreated", char_map)

  return char_map
end