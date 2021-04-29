Hooks:PreHook(CopDamage, "_call_listeners", "_call_listeners_hoplib", function (self, damage_info)

	if type(damage_info.damage) == "number" and not damage_info.hoplib_handled then
		local info = HopLib:unit_info_manager():get_info(damage_info.attacker_unit)
		if info then
			info:update_damage(damage_info.damage, self._dead)
		end
		Hooks:Call("HopLibOnUnitDamaged", self._unit, damage_info)
		if self._dead then
			Hooks:Call("HopLibOnUnitDied", self._unit, damage_info)
			HopLib:unit_info_manager():clear_info(self._unit)
		end
		damage_info.hoplib_handled = true
	end

end)