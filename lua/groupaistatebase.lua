Hooks:PostHook(GroupAIStateBase, "convert_hostage_to_criminal", "convert_hostage_to_criminal_hoplib", function(self, unit, peer_unit)
	local peer = managers.network:session():peer_by_unit(peer_unit or managers.player:player_unit())
	if peer and unit:brain()._logic_data.is_converted then
		peer:_register_minion(unit)
	end
end)

Hooks:PreHook(GroupAIStateBase, "_set_converted_police", "_set_converted_police_hoplib", function(self, u_key, unit)
	unit = not unit and self._converted_police[u_key]
	if alive(unit) and unit:character_damage().is_converted then
		Hooks:Call("HopLibOnMinionRemoved", unit)
		unit:character_damage().is_converted = nil
	end
end)
