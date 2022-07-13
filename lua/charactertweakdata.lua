-- Custom maps often break the character_map, need to be safe when adding to it
local logged_error
local function safe_add(char_map_table, element)
	if not char_map_table or not char_map_table.list then
		if not logged_error then
			logged_error = true
			log("[HopLib] WARNING: CharacterTweakData:character_map has missing data! One of your mods uses outdated code, check for mods overriding this function!")
		end
		return
	end
	table.insert(char_map_table.list, element)
end

local character_map_original = CharacterTweakData.character_map
function CharacterTweakData:character_map(...)
	local char_map = character_map_original(self, ...)

	-- Add missing entries to the character map
	safe_add(char_map.basic, "ene_city_swat_r870")
	safe_add(char_map.basic, "ene_city_shield")
	safe_add(char_map.basic, "ene_fbi_heavy_r870")
	safe_add(char_map.basic, "ene_swat_heavy_r870")
	safe_add(char_map.mad, "ene_akan_fbi_heavy_r870")
	safe_add(char_map.mad, "ene_akan_fbi_shield_dw_sr2_smg")
	safe_add(char_map.mad, "ene_akan_cs_heavy_r870")
	safe_add(char_map.friend, "ene_drug_lord_boss_stealth")
	safe_add(char_map.friend, "ene_thug_indoor_03")
	safe_add(char_map.friend, "ene_thug_indoor_04")
	safe_add(char_map.rvd, "npc_mr_brown_civ")
	safe_add(char_map.rvd, "npc_mr_pink_civ")
	safe_add(char_map.bex, "ene_swat_policia_federale_fbi")
	safe_add(char_map.bex, "ene_swat_policia_federale_fbi_r870")
	safe_add(char_map.chas, "ene_male_triad_01")

	Hooks:Call("HopLibOnCharacterMapCreated", char_map)

	return char_map
end
