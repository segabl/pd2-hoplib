---@class UnitInfo
---@field new fun(self, unit, u_key, manager):UnitInfo
UnitInfo = class()

function UnitInfo:init(unit, u_key, manager)
	self._unit = unit
	self._unit_key = u_key
	self._unit_id = unit:id()
	self._damage = 0
	self._kills = 0

	local u_base = unit:base() or {}
	local cm = managers.criminals

	if u_base.is_husk_player or u_base.is_local_player then
		self._type = u_base.is_local_player and "local_player" or "remote_player"
		self._peer = unit:network():peer()
		self._name = u_base.is_local_player and managers.network.account:username() or self._peer and self._peer:name()
		self._level = u_base.is_local_player and managers.experience:current_level() or self._peer and self._peer:level()
		self._rank = u_base.is_local_player and managers.experience:current_rank() or self._peer and self._peer:rank()
		self._damage = self._peer and self._peer._data_damage or 0
		self._kills = self._peer and self._peer._data_kills or 0
		self._color_id = cm:character_color_id_by_unit(unit)
	elseif HopLib:is_object_of_class(u_base, CopBase) then
		local name_mapping = HopLib:name_provider().UNIT_MAPPIGS[unit:name():key()] or ""
		self._type = "npc"
		self._owner = manager:get_info(u_base._minion_owner or u_base.kpr_minion_owner_peer_id and cm:character_unit_by_peer_id(u_base.kpr_minion_owner_peer_id))
		self._color_id = self._owner and self._owner._color_id or cm:character_color_id_by_unit(unit)
		self._female = (u_base._tweak_table:find("female") or name_mapping:find("female") or unit:movement()._machine:get_global("female") == 1) and true
		local gstate = managers.groupai:state()
		if gstate:is_unit_team_AI(unit) then
			self._type = "team_ai"
			self._name = u_base:nick_name()
		elseif self._owner or gstate._police[u_key] and gstate._police[u_key].is_converted or gstate:is_enemy_converted_to_criminal(unit) then
			self._type = "joker"
			self._name = HopLib:name_provider():name_by_unit(unit) or HopLib:name_provider():name_by_id(u_base._tweak_table)
			self._nickname = u_base.joker_name or u_base.kpr_minion_owner_peer_id and Keepers and Keepers.get_joker_name_by_peer(Keepers, u_base.kpr_minion_owner_peer_id)
			if not self._nickname or self._nickname == "" then
				self._nickname = self._owner and managers.localization:text("hoplib_owners_unit", { OWNER = self._owner:nickname(), UNIT = self._name })
			end
		elseif u_base.char_tweak then
			self._name = HopLib:name_provider():name_by_unit(unit) or HopLib:name_provider():name_by_id(u_base._tweak_table)
			self._is_civilian = HopLib:is_object_of_class(u_base,Network:is_server() and CivilianBase or HuskCivilianBase)
			self._is_special = u_base:char_tweak() and u_base:char_tweak().priority_shout and true
			self._is_boss = u_base._tweak_table:find("boss") and true
		end
	elseif u_base.sentry_gun then
		self._type = "sentry"
		self._owner = u_base.get_owner and manager:get_info(u_base:get_owner())
		self._name = HopLib:name_provider():name_by_id(u_base._tweak_table_id)
		self._nickname = self._owner and managers.localization:text("hoplib_owners_unit", { OWNER = self._owner:nickname(), UNIT = self._name })
		self._is_special = u_base._tweak_table_id:find("turret") and true
		self._color_id = self._owner and self._owner._color_id or cm:character_color_id_by_unit(unit)
		self._update_owner_stats = self._owner and true
	elseif unit:vehicle_driving() then
		local driving = unit:vehicle_driving()
		self._type = "vehicle"
		self._name = driving._tweak_data.name_id and managers.localization:text(driving._tweak_data.name_id) or tostring(driving.tweak_data):pretty(true)
	end

	self._type = self._type or "unknown"
	self._name = self._name or "Unknown"
end

function UnitInfo:update_damage(damage, is_kill)
	self._damage = self._damage + damage
	if is_kill then
		self._kills = self._kills + 1
	end
	if self._peer then
		self._peer._data_damage = self._damage
		self._peer._data_kills = self._kills
	end
	if self._update_owner_stats and self._owner then
		self._owner:update_damage(damage, is_kill)
	end
end

---Returns the unit
---@return userdata
function UnitInfo:unit()
	return self._unit
end

---Returns the `unit:name():key()`
---@return string
function UnitInfo:key()
	return self._unit_key
end

---Returns the unit's id
---@return integer
function UnitInfo:id()
	return self._unit_id
end

---Returns the unit type
---@return '"local_player"'|'"remote_player"'|'"npc"'|'"team_ai"'|'"joker"'|'"sentry"'|'"vehicle"'
function UnitInfo:type()
	return self._type
end

---Returns the unit's name
---@return string
function UnitInfo:name()
	return self._name
end

---Returns the unit's nickname, or name if it doesnt have a nickname
---@return string
function UnitInfo:nickname()
	return self._nickname or self._name
end

---Returns the unit owner's UnitInfo
---@return UnitInfo?
function UnitInfo:owner()
	return self._owner
end

---Returns the amount of damage dealt by the unit
---@return integer
function UnitInfo:damage()
	return self._damage
end

---Returns the unit's number of kills
---@return integer
function UnitInfo:kills()
	return self._kills
end

---Returns the peer object of the unit
---@return table?
function UnitInfo:peer()
	return self._peer
end

---Returns the level of the unit
---@return integer?
function UnitInfo:level()
	return self._level
end

---Returns the infamy rank of the unit
---@return integer?
function UnitInfo:rank()
	return self._rank
end

---Returns the chat color id of the unit
---@return integer
function UnitInfo:color_id()
	return self._color_id
end

---Returns wether the unit is a civilian
---@return boolean
function UnitInfo:is_civilian()
	return self._is_civilian
end

---Returns wether the unit is a special enemy
---@return boolean
function UnitInfo:is_special()
	return self._is_special
end

---Returns wether the unit is a boss type enemy
---@return boolean
function UnitInfo:is_boss()
	return self._is_boss
end

---Returns wether the unit is female
---@return boolean
function UnitInfo:is_female()
	return self._female
end


---@class UnitInfoManager
---@field new fun(self):UnitInfoManager
UnitInfoManager = class()

function UnitInfoManager:init()
	self._infos = {}
end

---Returns all existing UnitInfo instances
---@return table<string, UnitInfo>
function UnitInfoManager:all_infos()
	return self._infos
end

function UnitInfoManager:_create_info(unit, u_key, temp)
	if not alive(unit) or not u_key then
		return
	end
	local entry = UnitInfo:new(unit, u_key, self)
	if not temp then
		self._infos[u_key] = entry
	end
	return entry
end

---Returns the UnitInfo instance of the unit (or unit key if provided)
---@param unit? userdata @unit to get the UnitInfo instance of
---@param u_key? string @`unit:name():key()` of the unit to get the UnitInfo instance of
---@param temp? boolean @wether the UnitInfo should not be saved to the list
---@return UnitInfo?
function UnitInfoManager:get_info(unit, u_key, temp)
	u_key = u_key or alive(unit) and unit:key()
	if not u_key then
		return
	end
	return self._infos[u_key] or self:_create_info(unit, u_key, temp)
end

---Removes the UnitInfo instance of the unit (or unit key if provided)
---@param unit? userdata @unit to clear the UnitInfo of
---@param u_key? string @`unit:name():key()` of the unit to clear the UnitInfo of
function UnitInfoManager:clear_info(unit, u_key)
	u_key = u_key or alive(unit) and unit:key()
	self._infos[u_key] = nil
end
