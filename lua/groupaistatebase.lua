local convert_hostage_to_criminal_original = GroupAIStateBase.convert_hostage_to_criminal
function GroupAIStateBase:convert_hostage_to_criminal(unit, peer_unit)

  local player_unit = peer_unit or managers.player:player_unit()
  if alive(player_unit) and alive(unit) then
    unit:base()._minion_owner = player_unit
    HopLib.unit_info_manager:clear_info(unit)
  end
  
  return convert_hostage_to_criminal_original(self, unit, peer_unit)

end