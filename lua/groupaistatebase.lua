Hooks:PostHook(GroupAIStateBase, "convert_hostage_to_criminal", "convert_hostage_to_criminal_hoplib", function (self, unit, peer_unit)

	local player_unit = peer_unit or managers.player:player_unit()
	if alive(player_unit) and alive(unit) and unit:brain()._logic_data.is_converted then
		unit:base()._minion_owner = player_unit
		HopLib:unit_info_manager():clear_info(unit)

		Hooks:Call("HopLibOnMinionAdded", unit, player_unit)
	end

end)

Hooks:PostHook(GroupAIStateBase, "sync_converted_enemy", "sync_converted_enemy_hoplib", function (self, converted_enemy, owner_peer_id)

	local function minion_added(unit, peer_id)
		local peer = managers.network:session():peer(peer_id)
		local player_unit = peer and peer:unit()
		if not alive(player_unit) or not alive(unit) then
			return
		end

		unit:base()._minion_owner = player_unit
		HopLib:unit_info_manager():clear_info(unit)

		Hooks:Call("HopLibOnMinionAdded", unit, player_unit)

		return true
	end

	if minion_added(converted_enemy, owner_peer_id) then
		return
	end

	local local_peer = managers.network:session():local_peer()
	if local_peer:synched() then
		return
	end

	if not local_peer._queued_minions then
		local_peer._queued_minions = {}
		local_peer.set_synched = function (self, synched, ...)
			if synched then
				for _, v in pairs(self._queued_minions) do
					minion_added(unpack(v))
				end
				self._queued_minions = {}
			end

			return NetworkPeer.set_synched(self, synched, ...)
		end
	end

	table.insert(local_peer._queued_minions, { converted_enemy, owner_peer_id })

end)

Hooks:PreHook(GroupAIStateBase, "_set_converted_police", "_set_converted_police_hoplib", function (self, u_key, unit)

	local minion_unit = not unit and (self._converted_police[u_key] or self._police[u_key])
	if minion_unit then
		Hooks:Call("HopLibOnMinionRemoved", minion_unit)
	end

end)
