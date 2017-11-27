local _apply_damage_original = SentryGunDamage._apply_damage
function SentryGunDamage:_apply_damage(damage, dmg_shield, dmg_body, is_local, attacker_unit, ...)

  local result = _apply_damage_original(self, damage, dmg_shield, dmg_body, is_local, attacker_unit, ...)
  
  local info = HopLib.unit_info_manager:get_user_info(attacker_unit)
  local dmg = damage == "death" and (dmg_shield and self._SHIELD_HEALTH_INIT or dmg_body and self._HEALTH_INIT) or damage
  if info and type(dmg) == "number" then
    info:update_damage(dmg, self._dead)
  end
  if self._dead then
    HopLib.unit_info_manager:clear_info(self._unit)
  end
  
  return result
  
end