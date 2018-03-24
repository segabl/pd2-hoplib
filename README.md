# HopLib
Collection of functions and useful tools used in multiple of my mods

## Classes
----------
### NameProvider
Provides names based on a tweak_data id

**Translating unit names**
The English localization file does not contain every existing unit name, as the NameProvider constructs most of the names from the unit's tweak_table id. If you want to translate a unit name that is not part of the English localization, you can simply add it to your localization file by constructing the key like ``unit_name_TWEAKTABLEID`` (or ``unit_name_TWEAKTABLEID_LEVELID`` if the unit should have a different name depending on the heist played).

### UnitInfoManager
Collects and provides some information about units

## Hooks
--------
HopLib provides the following hooks:
- ``HopLibOnUnitDamaged`` with parameters ``(unit, damage_info)``
- ``HopLibOnUnitDied`` with parameters ``(unit, damage_info)``
- ``HopLibOnEnemyConverted`` with parameters ``(unit, player_unit)``