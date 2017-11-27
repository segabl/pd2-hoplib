local _set_converted_police_original = GroupAIStateBase._set_converted_police
function GroupAIStateBase:_set_converted_police(u_key, unit)

  _set_converted_police_original(self, u_key, unit)
  
  HopLib:_create_unit_info(unit, u_key)
  
end