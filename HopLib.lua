if not HopLib then

	_G.HopLib = {}

	dofile(ModPath .. "req/MenuBuilder.lua")
	dofile(ModPath .. "req/NameProvider.lua")
	dofile(ModPath .. "req/TableUtils.lua")
	dofile(ModPath .. "req/UnitInfoManager.lua")

	Hooks:Register("HopLibOnUnitDamaged")
	Hooks:Register("HopLibOnUnitDied")
	Hooks:Register("HopLibOnMinionAdded")
	Hooks:Register("HopLibOnMinionRemoved")
	Hooks:Register("HopLibOnCharacterMapCreated")

	HopLib.mod_path = ModPath
	HopLib.save_path = SavePath

	HopLib.language_keys = {
		[Idstring("dutch"):key()] = "dutch",
		[Idstring("english"):key()] = "english",
		[Idstring("french"):key()] = "french",
		[Idstring("german"):key()] = "german",
		[Idstring("italian"):key()] = "italian",
		[Idstring("japanese"):key()] = "japanese",
		[Idstring("korean"):key()] = "korean",
		[Idstring("russian"):key()] = "russian",
		[Idstring("schinese"):key()] = "schinese",
		[Idstring("spanish"):key()] = "spanish",
		[Idstring("swedish"):key()] = "swedish"
	}

	-- Returns the current NameProvider instance
	function HopLib:name_provider()
		if not self._name_provider then
			self._name_provider = NameProvider:new()
		end
		return self._name_provider
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

	-- Returns the language of the game
	function HopLib:get_game_language()
		return self.language_keys[SystemInfo:language():key()] or "english"
	end

	-- Returns the modded language
	function HopLib:get_modded_language()
		local mod_language = PD2KR and "korean" or PD2PTBR and "portuguese"
		if mod_language then
			return mod_language
		end
		local mod_language_table = {
			["PAYDAY 2 THAI LANGUAGE Mod"] = "thai"
		}
		for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
			if mod:IsEnabled() and mod_language_table[mod:GetName()] then
				return mod_language_table[mod:GetName()]
			end
		end
	end

	-- Loads localization file and returns loaded language
	function HopLib:load_localization(path, localization_manager)
		localization_manager = localization_manager or managers.localization
		if not localization_manager then
			log("[HopLib] ERROR: No localization manager available to load localization for " .. path .. "!")
			return
		end

		local language
		local system_language = self:get_game_language()
		local blt_language = BLT.Localization:get_language().language
		local mod_language = self:get_modded_language()

		if io.file_is_readable(path .. system_language .. ".txt") then
			language = system_language
		end
		if io.file_is_readable(path .. blt_language .. ".txt") then
			language = blt_language
		end
		if mod_language and io.file_is_readable(path .. mod_language .. ".txt") then
			language = mod_language
		end

		if io.file_is_readable(path .. "english.txt") then
			localization_manager:load_localization_file(path .. "english.txt")
		end
		if language and language ~= "english" then
			localization_manager:load_localization_file(path .. language .. ".txt")
		end
		return language or "english"
	end

	-- Loads game assets from files
	function HopLib:load_assets(assets)
		local load_func
		if BLT.AssetManager then
			load_func = function (ext, path, file) BLT.AssetManager:CreateEntry(path, ext, file) end
		else
			load_func = function (ext, path, file) DB:create_entry(ext, path, file) end
		end
		for _, v in pairs(assets) do
			if v.override or not DB:has(v.ext, v.path) then
				load_func(v.ext, v.path, v.file)
			end
		end
	end

	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitHopLib", function (loc)

		HopLib:load_localization(HopLib.mod_path .. "loc/", loc)

	end)

end

if RequiredScript then

	local fname = HopLib.mod_path .. "lua/" .. RequiredScript:gsub(".+/(.+)", "%1.lua")
	if io.file_is_readable(fname) then
		dofile(fname)
	end

end