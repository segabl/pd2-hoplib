Hooks:PreHook(CopDamage, "_on_damage_received", "_on_damage_received_hoplib", function (self, damage_info)

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

end)