local mark_minion_original = UnitNetworkHandler.mark_minion
function UnitNetworkHandler:mark_minion(unit, minion_owner_peer_id, convert_enemies_health_multiplier_level, passive_convert_enemies_health_multiplier_level, sender, ...)
  if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character_and_sender(unit, sender) then
    return
  end
  
  local peer = managers.network:session():peer(minion_owner_peer_id)
  local player_unit = peer and peer:unit()
  if alive(player_unit) then
    unit:base()._minion_owner = player_unit
    HopLib:unit_info_manager():clear_info(unit)
  end
  
  mark_minion_original(self, unit, minion_owner_peer_id, convert_enemies_health_multiplier_level, passive_convert_enemies_health_multiplier_level, sender, ...)
  
  Hooks:Call("HopLibOnMinionAdded", unit, player_unit)
  
end