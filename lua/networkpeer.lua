function NetworkPeer:_register_minion(unit)
	if not alive(unit) then
		return
	end

	if alive(self:unit()) then
		unit:base()._minion_owner = self:unit()
		HopLib:unit_info_manager():clear_info(unit)
		Hooks:Call("HopLibOnMinionAdded", unit, self:unit())
	else
		self._queued_minions = self._queued_minions or {}
		table.insert(self._queued_minions, unit)
	end
end

Hooks:PostHook(NetworkPeer, "set_unit", "set_unit_hoplib", function(self)
	if not self._queued_minions then
		return
	end

	for _, unit in pairs(self._queued_minions) do
		self:_register_minion(unit)
	end

	self._queued_minions = nil
end)
