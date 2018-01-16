local _apply_damage_original = SentryGunDamage._apply_damage
function SentryGunDamage:_apply_damage(damage, dmg_shield, dmg_body, is_local, attacker_unit, ...)

  local result = _apply_damage_original(self, damage, dmg_shield, dmg_body, is_local, attacker_unit, ...)
  
  local dmg = damage == "death" and (dmg_shield and self._SHIELD_HEALTH_INIT or dmg_body and self._HEALTH_INIT) or damage
  if type(dmg) == "number" then
    local info = HopLib:unit_info_manager():get_user_info(attacker_unit)
    if info then
      info:update_damage(dmg, self._dead)
    end
    Hooks:Call("HopLibOnUnitDamaged", self._unit, { damage = dmg, attacker_unit = attacker_unit })
    if self._dead then
      Hooks:Call("HopLibOnUnitDied", self._unit, { damage = dmg, attacker_unit = attacker_unit })
      HopLib:unit_info_manager():clear_info(self._unit)
    end
  end
  
  return result
  
end