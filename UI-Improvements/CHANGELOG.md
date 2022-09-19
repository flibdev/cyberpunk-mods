# Changelog

## [1.6.0] - 2022-09-14

Support for Cyberpunk 2077 Patch 1.6

### Changed

Updated Vendor Fast Sell to work with the new vendor logic
 - Now supports buyback logic, no money loss going back and forth
 - No fast selling of iconic items

### Removed

Removed iconic item sale prevention, CDPR added confirmation dialog

Removed because they were fixed by CDPR:
 - Max ammo crafting
 - Vendor quantity picker limits

### Unchanged

 - Dialer Menu ordering *(CDPR impl still sorts by hash)*
 - Iconic Items - Disassembly prevented
 - Quantity Picker - Default to max
 - RipperDoc - Only show unowned in UI totals
 - Messages/Quests/Shards custom sorting *(CDPR impl still sorts by hash)*

---

## [1.5.0] - 2022-02-24

Support for Cyberpunk 2077 Patch 1.5

### Added

 - Item Quantity Pickers now default to their max value instead of 1

### Changed

 - Requires redscript 0.5 or newer
 - Moved shared vendor code up to **shared** folder

### Removed

Removed because they were fixed by CDPR in Patch 1.5
 - LMG mod slot fix
 - Missing shard group names
 - Vehicle quest preview images (albiet fixed poorly)

---

## [1.3.0] - 2021-09-02

Support for Cyberpunk 2077 Patch 1.3

### Added

 - Vendor - Fast Buy & Sell
   - Allows you to sell entire stacks or expensive items without any additional dialogs
   - Limits sales to vendor money total
   - Also limits all buy/sell actions to player/vendor money total
   - Fast Sell is bound to the "Activate Secondary" input event, right click by default
   - Button hint text works in English and Russian, currently unsure about other languages
 - RPGManager - Mod Slots
   - Fixes LMG mods slots


### Changed

 - Requires redscript 0.3 or newer
 - Changed all method replacements to wraps where possible
   - Reduces issues caused by patch changes
   - Should improve compatibility between mods
 - Added names to the multiple "Other" shard groups
 - Fixed minor issue with phone dialer menu sorting

### Removed

 - Quest - Vehicle Previews
   - Feature was added by CDPR in Patch 1.3
 - Dialer Menu - By Timestamp
   - Removed redundant version of phone menu sorting.
   - Plan is to reenable this variant when Mod Settings are available
