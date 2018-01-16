local _call_listeners_original = CopDamage._call_listeners
function CopDamage:_call_listeners(damage_info, ...)

  if type(damage_info.damage) == "number" then
    local info = HopLib:unit_info_manager():get_user_info(damage_info.attacker_unit)
    if info then
      info:update_damage(damage_info.damage, self._dead)
    end
    Hooks:Call("HopLibOnUnitDamaged", self._unit, damage_info)
    if self._dead then
      Hooks:Call("HopLibOnUnitDied", self._unit, damage_info)
      HopLib:unit_info_manager():clear_info(self._unit)
    end
  end
  
  return _call_listeners_original(self, damage_info, ...)
  
end