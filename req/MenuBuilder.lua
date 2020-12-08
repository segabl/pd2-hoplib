MenuBuilder = class()

function MenuBuilder:init(identifier, settings_table)
  self._id = identifier
  self._table = settings_table
  self:load_settings()
end

function MenuBuilder:save_settings()
  local file = io.open(SavePath .. self._id .. ".txt", "w+")
  if file then
    file:write(json.encode(self._table))
    file:close()
  end
end

function MenuBuilder:load_settings()
  local file = io.open(SavePath .. self._id .. ".txt", "r")
  if file then
    local data = json.decode(file:read("*all"))
    file:close()
    table.replace(self._table, data or {}, true)
  end
end

function MenuBuilder:create_menu(menu_nodes, values, parent_menu)
  values = values or {}
  parent_menu = parent_menu or "blt_options"
  if not menu_nodes[parent_menu] then
    log("[MenuBuilder] ERROR: Parent menu node \"" .. parent_menu .. "\" does not exist (" .. self._id .. ")!")
    return
  end

  local loc_strings = {}
  local loc = managers.localization
  if not loc then
    log("[MenuBuilder] WARNING: Localization manager is not available yet (" .. self._id .. ")!")
  end

  local function set_value(item_name, item_value)
    local hierarchy = item_name:split("/")
    local tbl = self._table
    for i = 1, #hierarchy - 1 do
      tbl = tbl[hierarchy[i]]
    end
    local setting_name = hierarchy[#hierarchy]
    local callback = values[setting_name] and values[setting_name].callback
    tbl[setting_name] = item_value
    if callback then
      callback(item_value)
    end
  end

  MenuCallbackHandler[self._id .. "_toggle"] = function (_, item)
    set_value(item:name(), item:value() == "on")
  end

  MenuCallbackHandler[self._id .. "_value"] = function (_, item)
    set_value(item:name(), item:value())
  end

  MenuCallbackHandler[self._id .. "_save"] = function ()
    self:save_settings()
  end

  local order = {}
  local function order_tables(tbl)
    local keys = table.map_keys(tbl)
    local num_keys = #keys
    for i, v in ipairs(keys) do
      order[v] = values[v] and values[v].priority or num_keys - i
      if type(tbl[v]) == "table" then
        order_tables(tbl[v])
      end
    end
  end
  order_tables(self._table)

  local function loop_tables(tbl, menu_id, hierarchy, inherited_values)
    hierarchy = hierarchy and hierarchy .. "/" or ""
    MenuHelper:NewMenu(menu_id)
    for k, v in pairs(tbl) do
      local t = type(v)
      local name_id = "menu_" .. self._id .. "_" .. k
      local desc_id = name_id .. "_desc"
      local desc = loc and loc:exists(desc_id) and desc_id
      local vals = values[k] or inherited_values
      if loc and not loc:exists(name_id) then
        loc_strings[name_id] = k:pretty()
      end
      if t == "boolean" then
        MenuHelper:AddToggle({
          id = hierarchy .. k,
          title = name_id,
          desc = desc,
          callback = self._id .. "_toggle",
          value = v,
          menu_id = menu_id,
          priority = order[k]
        })
      elseif t == "number" then
        if vals and vals.items then
          MenuHelper:AddMultipleChoice({
            id = hierarchy .. k,
            title = name_id,
            desc = desc,
            callback = self._id .. "_value",
            value = v,
            items = vals.items,
            menu_id = menu_id,
            priority = order[k]
          })
        else
          MenuHelper:AddSlider({
            id = hierarchy .. k,
            title = name_id,
            desc = desc,
            callback = self._id .. "_value",
            value = v,
            min = vals and vals.min or 0,
            max = vals and vals.max or 1,
            step = vals and vals.step or 0.1,
            show_value = true,
            menu_id = menu_id,
            priority = order[k]
          })
        end
      elseif t == "string" then
        MenuHelper:AddInput({
          id = hierarchy .. k,
          title = name_id,
          desc = desc,
          callback = self._id .. "_value",
          value = v,
          menu_id = menu_id,
          priority = order[k]
        })
      elseif t == "table" then
        local node_id = menu_id .. "_" .. k
        MenuHelper:AddButton({
          id = hierarchy .. k,
          title = name_id,
          desc = desc,
          next_node = node_id,
          menu_id = menu_id,
          priority = order[k]
        })
        loop_tables(v, node_id, hierarchy .. k, vals)
      end
    end
    menu_nodes[menu_id] = MenuHelper:BuildMenu(menu_id, { back_callback = self._id .. "_save" })
  end
  loop_tables(self._table, self._id)

  local name_id = "menu_" .. self._id
  local desc_id = name_id .. "_desc"
  if loc then
    if not loc:exists(name_id) then
      loc_strings[name_id] = self._id:pretty(true)
    end
    loc:add_localized_strings(loc_strings)
  end

  MenuHelper:AddMenuItem(menu_nodes[parent_menu], self._id, name_id, loc and loc:exists(desc_id) and desc_id)
end
