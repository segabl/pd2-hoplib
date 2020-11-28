# HopLib

Collection of functions and useful tools, currently mostly about retrieving information about units.

## Classes

### NameProvider

Provides names based on a unit name or tweak_data id. The active ``NameProvider`` instance can be retrieved by calling ``HopLib:name_provider()``. There are two functions that can be called on the ``NameProvider`` instance:

- ``NameProvider:name_by_id(tweak)`` Returns the name based on the tweak_data id.
- ``NameProvider:name_by_unit(unit, [u_key])`` Returns the name based on the unit or ``u_key`` if you provided it, which is useful if the unit doesn't actually exist currently. This is done through a lookup table, so it is not guaranteed to return a name (Only works for units defined in ``CharacterTweakData:character_map()`` which should contain all human enemies).

The names are taken from the localization file if available, otherwise the modified string id (Capitalized words, removed underscores, etc) will be used as the name.

### UnitInfoManager

Can be used to return information about a unit. Unit infos are created upon request (i.e. a call to ``get_info``) or by HopLib in certain cases. The following functions can be called on the active ``UnitInfoManager`` instance, which can be retrieved by calling ``HopLib:unit_info_manager()``:

- ``UnitInfoManager:all_infos()`` Returns a table (indexed by unit key) containing all unit infos.
- ``UnitInfoManager:clear_info(unit, [u_key])`` Clears the information about ``unit``.
- ``UnitInfoManager:get_info(unit, [u_key], [temp])`` Returns the information about ``unit`` (creates it if it doesn't have it yet).
- ``UnitInfoManager:get_user_info(unit, [u_key], [temp])`` Returns the user of ``unit`` (shortcut for ``UnitInfoManager:get_info(unit):user()``).

Providing the optional ``u_key`` skips the function's internal ``unit:key()`` which might be useful if the unit has already been deleted but you have its key. Setting the ``temp`` argument to true will retrieve the unit information but not save it to the ``UnitInfoManager`` which can be useful if you need the unit info after it has been cleared but don't want to recreate it yet.

#### UnitInfo

The ``UnitInfoManager`` creates and returns ``UnitInfo`` instances, which contain information about the unit. The following functions can be called on a ``UnitInfo`` retrieved from the ``UnitInfoManager``:

- ``UnitInfo:unit()`` Returns the unit.
- ``UnitInfo:key()`` Returns the unit key.
- ``UnitInfo:id()`` Returns the unit id.
- ``UnitInfo:type()`` Returns the type of the unit. Possible values are ``"player"``, ``"npc"``, ``"projectile"`` and ``"sentry"``.
- ``UnitInfo:sub_type()`` Returns the sub type type of the unit (if available), depending on the main type. Possible values are ``"local_player"`` or ``"remote_player"`` for type ``"player"`` and ``"team_ai"`` or ``"joker"`` for type ``"npc"``.
- ``UnitInfo:name()`` Returns the name of the unit.
- ``UnitInfo:nickname()`` Returns the nickname of the unit (used for jokers and sentries). If it doesn't have one, returns the same as ``UnitInfo:name()``.
- ``UnitInfo:owner()`` Returns the ``UnitInfo`` of the unit owner (used for jokers and sentries).
- ``UnitInfo:user()`` Returns the ``UnitInfo`` of the unit user (currently only used for projectiles). If it doesn't have one, returns itself.
- ``UnitInfo:damage()`` Returns the amount of damage the unit has dealt.
- ``UnitInfo:kills()`` Returns the number of kills the unit made.
- ``UnitInfo:peer()`` Returns the peer object if the unit is of type ``"player"``.
- ``UnitInfo:level()`` Returns the level if the unit is of type ``"player"``.
- ``UnitInfo:rank()`` Returns the infamy rank if the unit is of type ``"player"``.
- ``UnitInfo:color_id()`` Returns the color id of the unit.
- ``UnitInfo:is_civilian()`` Returns ``true`` if the unit is a civilian.
- ``UnitInfo:is_special()`` Returns ``true`` if the unit is a special enemy.
- ``UnitInfo:is_boss()`` Returns ``true`` if the unit is a boss type enemy.
- ``UnitInfo:is_female()`` Returns ``true`` if the unit is female.

## Hooks

HopLib provides the following hooks:

- ``HopLibOnMinionAdded`` with parameters ``(unit, player_unit)`` Called when an enemy is converted by a player.
- ``HopLibOnMinionRemoved`` with parameters ``(unit)`` Called when a converted enemy is removed (died, released, etc).
- ``HopLibOnUnitDamaged`` with parameters ``(unit, damage_info)`` Called whenever a unit takes damage.
- ``HopLibOnUnitDied`` with parameters ``(unit, damage_info)`` Called when a unit dies.
- ``HopLibOnCharacterMapCreated`` with parameters ``(char_map)`` Called before ``CharacterTweakData:character_map`` returns.

## Utility

HopLib also provides some utility functions:

- ``HopLib:get_game_language()`` Returns the language the game is set to as a string.
- ``HopLib:get_modded_language()`` Returns the language the game is set to through mods.
- ``HopLib:load_localization(path, [localization_manager])`` Automatically chooses the correct language file in the ``path`` directory and loads it in ``localization_manager``. Tries to use the registered ``LocalizationManager`` if ``localization_manager`` is not specified. Returns the language loaded.
- ``HopLib:is_object_of_class(object, c)`` Returns ``true`` if ``object`` is of class ``c``, either directly or by inheritance.
- ``HopLib:load_assets(assets)`` Loads all files in the ``assets`` table. Entries must be tables containing ``ext``, ``path`` and ``file`` keys and may contain an optional ``override`` key.

### Table Utility

Additional utility functions that operate on tables:

- ``table.union(tbl1, tbl2)`` Merges all values from ``tbl2`` into ``tbl1``, replacing existing values in tbl1.
- ``table.replace(tbl1, tbl2, [match_type])`` Replaces only existing values in ``tbl1`` with values from ``tbl2``. If ``match_type`` is set, the value types in both tables must match to be replaced.
- ``table.recurse(tbl, func)`` Calls ``func(value, key)`` for each non-table value in ``tbl``. If the value is a table itself, calls itself on that table.

### Menu Builder

Automatically creates a options menu from an identifier and a settings table. The following functions exist:

- ``MenuBuilder:new(id, settings_table)`` Creates a new menu builder with the mod identifier ``id`` using the table ``settings_table``.
- ``MenuBuilder:save_settings()`` Saves the current settings. Called automatically when settings are changed via the options menu.
- ``MenuBuilder:load_settings()`` Loads previously saved settings for its corresponding mod identifier.
- ``MenuBuilder:create_menu(menu_nodes, [parent_menu, values, order])`` Creates the menu. ``menu_nodes`` are the existing menu nodes obtained in the ``MenuManagerBuildCustomMenus`` hook. ``parent_menu`` determines where the menu is added, defaults to the BLT mod options menu. ``values`` allows to specify custom ranges/items, ``order`` allows to specify custom sorting order for elements.

For the optional ``values`` and ``order`` tables in ``MenuBuilder:create_menu`` supply keys with the same name as the keys in your main settings table. For ``values`` the values for those keys determine wether the element turns into a slider or a multi-select. Specifying a table with three number values like ``setting_name = { -1, 1, 0.01 }`` makes a slider with ``min=-1``, ``max=1`` and ``step=0.01``. Specifying a table containing string values makes a multi-select with those values as the available options. If no value is specified in the ``values`` table for a setting using a number value, it defaults to a slider with ``min=0``, ``max=1`` and ``step=0.1``. You can also specify values for a table value in settings, if you do so, those values will be passed down to any elements in that table and be used as default for them if no other values are specified.  
For ``order`` simply specify a number value for a setting, like ``setting_name = 99``. This number value is used as priority for the menu entry and by default entries are sorted alphabetically by their keys.  
When creating the ``MenuBuilder``, it looks for existing localization in the form of ``menu_ID_SETTING`` and ``menu_ID_SETTING_desc`` (without ``_SETTING`` for the main menu node) where ``ID`` is the id you specified when creating the ``MenuBuilder`` and ``SETTING`` is the name of the setting in the settings table. If these localization strings can't be found, the ``MenuBuilder`` automatically creates localization strings based on the settings names. Localization strings for menu items of multi-select elements always have to be created manually.  
A minimal example usage of the ``MenuBuilder`` could look like this:

```lua
Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusTestMod", function(menu_manager, nodes)
  local builder = MenuBuilder:new("test_mod", TestMod.settings)
  builder:load_settings()
  builder:create_menu(nodes)
end)
```
