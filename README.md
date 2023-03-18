# HopLib

Collection of functions and useful tools, currently mostly about retrieving information about units.

## Classes

### NameProvider

Provides names based on a unit name or tweak_data id. The active `NameProvider` instance can be retrieved by calling `HopLib:name_provider()`. There are two functions that can be called on the `NameProvider` instance:

- `NameProvider:name_by_id(tweak)` Returns the name based on the tweak_data id.
- `NameProvider:name_by_unit(unit, [u_key])` Returns the name based on the unit or `u_key` if you provided it, which is useful if the unit doesn't actually exist currently. This is done through a lookup table, so it is not guaranteed to return a name (Only works for units defined in `CharacterTweakData:character_map()` which should contain all human enemies).

The names are taken from the localization file if available, otherwise the modified string id (Capitalized words, removed underscores, etc) will be used as the name.

### UnitInfoManager

Can be used to return information about a unit. Unit infos are created upon request (i.e. a call to `get_info`) or by HopLib in certain cases. The following functions can be called on the active `UnitInfoManager` instance, which can be retrieved by calling `HopLib:unit_info_manager()`:

- `UnitInfoManager:all_infos()` Returns a table (indexed by unit key) containing all unit infos.
- `UnitInfoManager:clear_info(unit, [u_key])` Clears the information about `unit`.
- `UnitInfoManager:get_info(unit, [u_key], [temp])` Returns the information about `unit` (creates it if it doesn't have it yet). Setting the `temp` argument to true will retrieve the unit information but not save it.

Providing the optional `u_key` skips the function's internal `unit:key()` which might be useful if the unit has already been deleted but you have its key.

#### UnitInfo

The `UnitInfoManager` creates and returns `UnitInfo` instances, which contain information about the unit. The following functions can be called on a `UnitInfo` retrieved from the `UnitInfoManager`:

- `UnitInfo:unit()` Returns the unit.
- `UnitInfo:key()` Returns the unit key.
- `UnitInfo:id()` Returns the unit id.
- `UnitInfo:type()` Returns the type of the unit. Possible values are `"local_player"`, `"remote_player"`, `"npc"`, `"team_ai"`, `"joker"`, `"sentry"` and `"vehicle"`.
- `UnitInfo:name()` Returns the name of the unit.
- `UnitInfo:nickname()` Returns the nickname of the unit (used for jokers and sentries). If it doesn't have one, returns the same as `UnitInfo:name()`.
- `UnitInfo:owner()` Returns the `UnitInfo` of the unit owner if it has one (used for jokers and sentries).
- `UnitInfo:damage()` Returns the amount of damage the unit has dealt.
- `UnitInfo:kills()` Returns the number of kills the unit made.
- `UnitInfo:peer()` Returns the peer object if the unit is of type `"player"`.
- `UnitInfo:level()` Returns the level if the unit is of type `"player"`.
- `UnitInfo:rank()` Returns the infamy rank if the unit is of type `"player"`.
- `UnitInfo:color_id()` Returns the color id of the unit.
- `UnitInfo:is_civilian()` Returns `true` if the unit is a civilian.
- `UnitInfo:is_special()` Returns `true` if the unit is a special enemy.
- `UnitInfo:is_boss()` Returns `true` if the unit is a boss type enemy.
- `UnitInfo:is_female()` Returns `true` if the unit is female.

## Hooks

HopLib provides the following hooks:

- `HopLibOnMinionAdded` with parameters `(unit, player_unit)` Called when an enemy is converted by a player.
- `HopLibOnMinionRemoved` with parameters `(unit)` Called when a converted enemy is removed (died, released, etc).
- `HopLibOnUnitDamaged` with parameters `(unit, damage_info)` Called whenever a unit takes damage.
- `HopLibOnUnitDied` with parameters `(unit, damage_info)` Called when a unit dies.
- `HopLibOnCharacterMapCreated` with parameters `(char_map)` Called before `CharacterTweakData:character_map` returns.

## Utility

HopLib also provides some utility functions:

- `HopLib:get_game_language()` Returns the language the game is set to as a string.
- `HopLib:get_modded_language()` Returns the language the game is set to through mods.
- `HopLib:load_localization(path, [localization_manager])` Automatically chooses the correct language file in the `path` directory and loads it in `localization_manager`. Tries to use the registered `LocalizationManager` if `localization_manager` is not specified. Returns the language loaded.
- `HopLib:is_object_of_class(object, c)` Returns `true` if `object` is of class `c`, either directly or by inheritance.
- `HopLib:load_assets(assets)` Loads all files in the `assets` table. Entries must be tables containing `ext`, `path` and `file` keys and may contain an optional `override` key.
- `HopLib:run_required(path)` Runs the file matching the current `RequiredScript` if it exists in `path`.

### Color Utility

Additional utility functions that operate on color values:

- `Color:grayscale()` Returns a grayscale version of the color by taking the average of all color channels.
- `Color:invert([invert_alpha])` Returns the inverse of the color, inverting the alpha channel if `invert_alpha` is set.

All color utility functions operate on the game's color objects (e.g. `Color.black:invert()`) and return a new Color rather than changing the existing one.

### Table Utility

Additional utility functions that operate on tables:

- `table.union(tbl1, tbl2, [match_type])` Merges all values from `tbl2` into `tbl1`, replacing existing values in tbl1. If `match_type` is set, the value types in both tables must match to be replaced.
- `table.replace(tbl1, tbl2, [match_type])` Replaces only existing values in `tbl1` with values from `tbl2`. If `match_type` is set, the value types in both tables must match to be replaced.
- `table.recurse(tbl, func)` Calls `func(value, key)` for each non-table value in `tbl`. If the value is a table itself, calls itself on that table.

### Menu Builder

Automatically creates a options menu from an identifier and a settings table. The following functions exist:

- `MenuBuilder:new(id, settings_table, [settings_params])` Creates a new menu builder with the mod identifier `id` using the table `settings_table`. The optional parameter `settings_params` allows to specify custom ranges, items and priorities for specific settings.
- `MenuBuilder:save_settings()` Saves the current settings. Called automatically when settings are changed via the options menu.
- `MenuBuilder:load_settings()` Loads previously saved settings. Called automatically when the menu builder is created.
- `MenuBuilder:create_menu(menu_nodes, [parent_menu])` Creates the menu. `menu_nodes` are the existing menu nodes obtained in the `MenuManagerBuildCustomMenus` hook.  The optional parameter `parent_menu` determines where the menu is added, defaults to the BLT mod options menu.
