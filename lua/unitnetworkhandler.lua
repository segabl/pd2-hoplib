local mark_minion_original = UnitNetworkHandler.mark_minion
function UnitNetworkHandler:mark_minion(unit, minion_owner_peer_id, ...)
  
  local peer = managers.network:session():peer(minion_owner_peer_id)
  local player_unit = peer and peer:unit()
  if alive(player_unit) and alive(unit) then
    unit:base()._minion_owner = player_unit
    HopLib.unit_info_manager:clear_info(unit)
  end
  
  return mark_minion_original(self, unit, minion_owner_peer_id, ...)
  
end