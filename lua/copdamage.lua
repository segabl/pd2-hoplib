Hooks:PreHook(CopDamage, "_call_listeners", "_call_listeners_hoplib", function(self, damage_info)
	if type(damage_info.damage) ~= "number" then
		return
	end

	local info = HopLib:unit_info_manager():get_info(damage_info.attacker_unit)
	if info then
		info:update_damage(damage_info.damage, self._dead)
	end

	Hooks:Call("HopLibOnUnitDamaged", self._unit, damage_info)

	if self._dead then
		Hooks:Call("HopLibOnUnitDied", self._unit, damage_info)

		if self._converted then
			Hooks:Call("HopLibOnMinionRemoved", self._unit)
			self._converted = nil
		end

		HopLib:unit_info_manager():clear_info(self._unit)
	end
end)

Hooks:PostHook(CopDamage, "load", "load_hoplib", function(self, data)
	local peer = data.char_dmg and data.char_dmg.is_converted and managers.network:session():peer(data.char_dmg.converted_owner_peer_id)
	if peer then
		peer:_register_minion(self._unit)
	end
end)

Hooks:PreHook(CopDamage, "destroy", "destroy_hoplib", function(self)
	if self._converted then
		Hooks:Call("HopLibOnMinionRemoved", self._unit)
		self._converted = nil
	end
end)
