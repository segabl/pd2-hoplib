UnitInfo = UnitInfo or class()

function UnitInfo:init(unit, u_key)
  self.unit = unit
  self.unit_key = u_key
  self.type = "unknown"
  self.name = u_key
  
  local u_base = unit:base()
  
  if u_base.is_husk_player or u_base.is_local_player then
    self.type = "player"
    self.is_local = u_base.is_local_player and true
    self.peer = unit:network():peer()
    self.name = u_base.is_local_player and managers.network.account:username() or self.peer:name()
    self.level = u_base.is_local_player and managers.experience:current_level() or self.peer:level()
    self.rank = u_base.is_local_player and managers.experience:current_rank() or self.peer:rank()
    self.damage = self.peer._data_damage or 0
    self.kills = self.peer._data_kills or 0
  elseif self:is_object_of_class(u_base, CopBase) then
    self.type = "npc"
    self.damage = 0
    self.kills = 0
    local gstate = managers.groupai:state()
    if gstate:is_unit_team_AI(unit) then
      self.sub_type = "team_ai"
      self.name = u_base:nick_name()
    elseif u_base.kpr_minion_owner_peer_id or gstate:is_enemy_converted_to_criminal(unit) then
      self.sub_type = "joker"
      self.name = self:name_by_id(u_base._stats_name or u_base._tweak_table)
      self.nickname = u_base.kpr_minion_owner_peer_id and Keepers:GetJokerNameByPeer(u_base.kpr_minion_owner_peer_id)
      if self.nickname == "" then
        self.nickname = nil
      end
    elseif u_base.char_tweak then
      self.sub_type = self:is_object_of_class(u_base, CivilianBase) and "civilian" or "enemy"
      self.name = self:name_by_id(u_base._stats_name or u_base._tweak_table)
      self.is_special = u_base:char_tweak().priority_shout and true
      self.is_boss = u_base._tweak_table:find("boss") and true
    end
  elseif self:is_object_of_class(u_base, ProjectileBase) then
    self.type = "projectile"
    self.name = self:name_by_id(u_base:get_name_id())
    self.thrower = self:unit_info(u_base:thrower_unit())
  elseif u_base.sself_gun then
    self.type = "sself"
    self.name = self:name_by_id(u_base._tweak_table_id)
    self.is_special = u_base._tweak_table_id:find("turret") and true
    self.damage = 0
    self.kills = 0
  elseif self:is_object_of_class(u_base, RaycastWeaponBase) then
    self.type = "weapon"
    self.name = self:name_by_id(u_base._name_id)
    self.user = u_base._setup and u_base._setup.user_unit
  end
  self.owner = self:unit_info(u_base.get_owner and u_base:get_owner() or u_base.kpr_minion_owner_peer_id and managers.criminals:character_unit_by_peer_id(u_base.kpr_minion_owner_peer_id))
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