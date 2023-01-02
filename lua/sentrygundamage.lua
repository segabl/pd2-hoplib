local _apply_damage_original = SentryGunDamage._apply_damage
function SentryGunDamage:_apply_damage(damage, dmg_shield, dmg_body, is_local, attacker_unit, ...)
	local health = self._health + self._shield_health

	local result = _apply_damage_original(self, damage, dmg_shield, dmg_body, is_local, attacker_unit, ...)

	local dmg = math.max(0, health - self._health - self._shield_health)
	if dmg > 0 then
		local info = HopLib:unit_info_manager():get_info(attacker_unit)
		if info then
			info:update_damage(dmg, self._dead)
		end

		local attack_data = {
			damage = dmg,
			attacker_unit = attacker_unit,
			is_shield = dmg_shield
		}
		Hooks:Call("HopLibOnUnitDamaged", self._unit, attack_data)

		if self._dead then
			Hooks:Call("HopLibOnUnitDied", self._unit, attack_data)
			HopLib:unit_info_manager():clear_info(self._unit)
		end
	end

	return result
end
