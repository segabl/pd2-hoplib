local convert_hostage_to_criminal_original = GroupAIStateBase.convert_hostage_to_criminal
function GroupAIStateBase:convert_hostage_to_criminal(unit, peer_unit)

  if not alive(unit) then
    return
  end

  local player_unit = peer_unit or managers.player:player_unit()
  if alive(player_unit) then
    local max_minions = peer_unit and (peer_unit:base():upgrade_value("player", "convert_enemies_max_minions") or 0) or managers.player:upgrade_value("player", "convert_enemies_max_minions", 0)
    local criminal_data = self._criminals[player_unit:key()]
    if table.size(criminal_data and criminal_data.minions or {}) < max_minions then
      unit:base()._minion_owner = player_unit
      HopLib:unit_info_manager():clear_info(unit)
    end
  end
  
  convert_hostage_to_criminal_original(self, unit, peer_unit)
  
  if unit:brain()._logic_data.is_converted then
    Hooks:Call("HopLibOnMinionAdded", unit, player_unit)
  end

end

local _set_converted_police_original = GroupAIStateBase._set_converted_police
function GroupAIStateBase:_set_converted_police(u_key, unit, ...)
  
  if not unit then
    local minion_unit = self._converted_police[u_key]
    if minion_unit then
      Hooks:Call("HopLibOnMinionRemoved", minion_unit)
    end
  end

  return _set_converted_police_original(self, u_key, unit, ...)
end