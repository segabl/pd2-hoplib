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

- ``HopLibOnMinionAdded`` with parameters ``(unit, player_unit)``
- ``HopLibOnMinionRemoved`` with parameters ``(unit)``
- ``HopLibOnUnitDamaged`` with parameters ``(unit, damage_info)``
- ``HopLibOnUnitDied`` with parameters ``(unit, damage_info)``

## Utility

HopLib also provides some utility functions:

- ``HopLib:get_game_language()`` Returns the language the game is set to as a string.
- ``HopLib:is_object_of_class(object, c)`` Returns ``true`` if ``object`` is of class ``c``, either directly or by inheritance.