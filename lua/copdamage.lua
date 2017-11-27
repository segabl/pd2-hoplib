local _call_listeners_original = CopDamage._call_listeners
function CopDamage:_call_listeners(damage_info, ...)

  local info = HopLib:unit_info(damage_info.attacker_unit)
  if info and type(damage_info.damage) == "number" then
    info:update_damage(damage_info.damage, self._dead)
  end
  if self._dead then
    -- TODO: maybe remove from unit info
  end
  
  return _call_listeners_original(self, damage_info, ...)
  
end