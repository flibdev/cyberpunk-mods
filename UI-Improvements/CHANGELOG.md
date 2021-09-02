# Changelog

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
