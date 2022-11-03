local is_client = Network:is_client()

---@class NameProvider
---@field new fun(self):NameProvider
NameProvider = class()

NameProvider.TWEAK_REDIRECTS = {
	ceiling_turret_module_no_idle = "ceiling_turret_module",
	ceiling_turret_module_longer_range = "ceiling_turret_module"
}
NameProvider.UNIT_MAPPIGS = {}
NameProvider.UNIT_REDIRECTS = {}
NameProvider.CLIENT_TO_SERVER_MAPPING = {}

function NameProvider:init()
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
	local client_key, server_key
	for _, cat in pairs(tweak_data.character:character_map()) do
		for _, name in pairs(cat.list) do
			server_key = Idstring(cat.path .. name .. "/" .. name):key()
			client_key = Idstring(cat.path .. name .. "/" .. name .. "_husk"):key()
			NameProvider.UNIT_MAPPIGS[server_key] = name
			NameProvider.CLIENT_TO_SERVER_MAPPING[client_key] = server_key
			NameProvider.UNIT_REDIRECTS[name] = strip_weapon_name(name:gsub("_[0-9]+$", "")):gsub("_hvh", ""):gsub("^(civ_f?e?male).+", "%1")
		end
	end
end

---Returns a localized name based on the tweak data id
---@param tweak string @tweak data id to get the name for
---@return string?
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

---Returns a localized name based on the unit (or unit key if provided)
---@param unit? userdata @unit to get the name for
---@param u_key? string @`unit:name():key()` to get the name for
---@return string?
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
		[name] = redir_name:gsub("^[a-z]+_", ""):gsub("^f?e?male_", ""):gsub("_?[0-9]+$", ""):pretty(true)
	})
	return managers.localization:text(name)
end
