Hooks:PostHook(UnitNetworkHandler, "mark_minion", "mark_minion_hoplib", function(self, unit, peer_id)
	local peer = managers.network:session():peer(peer_id)
	if peer then
		peer:_register_minion(unit)
	end
end)
