Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitHopLib", function(loc)
  
  local language = "english"
  local system_language = HopLib:get_game_language()
  local blt_language = BLT.Localization:get_language().language
  local mod_language

  local loc_path = HopLib.mod_path .. "loc/"
  if io.file_is_readable(loc_path .. system_language .. ".txt") then
    language = system_language
  end
  if io.file_is_readable(loc_path .. blt_language .. ".txt") then
    language = blt_language
  end
  if mod_language and io.file_is_readable(loc_path .. mod_language .. ".txt") then
    language = mod_language
  end

  loc:load_localization_file(loc_path .. language .. ".txt")
  loc:load_localization_file(loc_path .. "english.txt", false)
  
end)