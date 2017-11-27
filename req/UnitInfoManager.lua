UnitInfo = UnitInfo or class()

function UnitInfo:init(unit, u_key, manager)
  self.unit = unit
  self.unit_key = u_key
  self.type = "unknown"
  self.name = u_key
  
  local u_base = unit:base()
  
  self.owner = manager:get_info(u_base.get_owner and u_base:get_owner() or u_base.kpr_minion_owner_peer_id and managers.criminals:character_unit_by_peer_id(u_base.kpr_minion_owner_peer_id))
  if u_base.is_husk_player or u_base.is_local_player then
    self.type = "player"
    self.is_local = u_base.is_local_player and true
    self.peer = unit:network():peer()
    self.name = u_base.is_local_player and managers.network.account:username() or self.peer:name()
    self.level = u_base.is_local_player and managers.experience:current_level() or self.peer:level()
    self.rank = u_base.is_local_player and managers.experience:current_rank() or self.peer:rank()
    self.damage = self.peer._data_damage or 0
    self.kills = self.peer._data_kills or 0
  elseif HopLib:is_object_of_class(u_base, CopBase) then
    self.type = "npc"
    self.damage = 0
    self.kills = 0
    local gstate = managers.groupai:state()
    if gstate:is_unit_team_AI(unit) then
      self.sub_type = "team_ai"
      self.name = u_base:nick_name()
    elseif u_base.kpr_minion_owner_peer_id or gstate:is_enemy_converted_to_criminal(unit) then
      self.sub_type = "joker"
      self.name = manager.name_provider:name_by_id(u_base._stats_name or u_base._tweak_table)
      self.nickname = u_base.kpr_minion_owner_peer_id and Keepers:GetJokerNameByPeer(u_base.kpr_minion_owner_peer_id)
      if not self.nickname or self.nickname == "" then
        self.nickname = self.owner and self.owner.name .. "'s " .. self.name
      end
    elseif u_base.char_tweak then
      self.sub_type = HopLib:is_object_of_class(u_base, CivilianBase) and "civilian" or "enemy"
      self.name = manager.name_provider:name_by_id(u_base._stats_name or u_base._tweak_table)
      self.is_special = u_base:char_tweak().priority_shout and true
      self.is_boss = u_base._tweak_table:find("boss") and true
    end
  elseif self:is_object_of_class(u_base, ProjectileBase) then
    self.type = "projectile"
    self.name = manager.name_provider:name_by_id(u_base:get_name_id())
    self.thrower = manager:get_info(u_base:thrower_unit())
  elseif u_base.sentry_gun then
    self.type = "sentry"
    self.name = manager.name_provider:name_by_id(u_base._tweak_table_id)
    self.nickname = self.owner and self.owner.name .. "'s " .. self.name
    self.is_special = u_base._tweak_table_id:find("turret") and true
    self.damage = 0
    self.kills = 0
  end
end

function UnitInfo:update_damage(damage, is_kill)
  if self.thrower then
    return self.thrower:update_damage(damage, is_kill)
  end
  self.damage = self.damage + damage
  if is_kill then
    self.kills = self.kills + 1
  end
  if self.peer then
    self.peer._data_damage = self.damage
    self.peer._data_kills = self.kills
  end
end

UnitInfoManager = UnitInfoManager or class()

function UnitInfoManager:init(name_provider)
  self.infos = {}
  self.name_provider = name_provider
end

function UnitInfoManager:_create_info(unit, u_key)
  if not alive(unit) or not u_key then
    return
  end
  local entry = UnitInfo:new(unit, u_key, self)
  self.infos[u_key] = entry
  return entry
end

function UnitInfoManager:get_info(unit)
  local u_key = alive(unit) and unit:key()
  if not u_key then
    return
  end
  return self.infos[u_key] or self:_create_info(unit, u_key)
end

function UnitInfoManager:clear_info(unit, u_key)
  u_key = u_key or alive(unit) and unit:key()
  self.infos[u_key] = nil
end