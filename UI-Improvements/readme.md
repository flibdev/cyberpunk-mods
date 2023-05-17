# flib's UI Improvements

A collection of quality-of-life UI improvements to fix minor issues that annoyed me.

### Iconic Items
- Prevent the disassembly or sale of iconic items ()



---

### Inventory
- Iconic Items cannot be disassembled
- Light Machine Gun weapon mods now actually work

### Crafting
- Ammo crafting is limited to the maximum carryable per type

### Dialer Menu
- Sorting by either name or timestamp (install time choice)
- Always shows contacts that are Quest Related or have unread messages first

### Journal
- Vehicle quests now have a codex image link to the vehicle being purchased
- Sort Jobs dynamically by timestamp/name/difficulty
- Sort Messages dynamically by timestamp/name
- Sort Shards dynamically by timestamp/name

### Shards
- Added localized names for the 4 "Other" groups CDPR added
- Fixed the name of the Encrypted shards group

### Vendors:
- Fast Buy & Sell
  - Allows you to buy and sell entire items stacks without any additional dialogs
  - Uses the `activate_secondary` keybinding (defaults to Right Mouse Button)
- Quantity pickers are now limited to the players/vendors total money
- Iconic Items cannot be sold
- Ripperdoc vendor screen only shows number of unowned mods per body category

## Localization Support
- The button hint text used by the Journal sorting methods uses existing LocKeys and _should_ be fully localized
- The updated shard group names use existing LocKeys and _should_ be fully localized
- The Fast Buy/Sell button hints use a bit of a hack, but are confirmed to make sense in English and Russian

## TODO
- [X] Limit ammo crafting to type limit
  - [X] Retrieve limit dynamically instead of hardcoded magic numbers
- [X] Sort menus dynamically
- [ ] Show scope type in tooltip
- [ ] Add search filter to shards/messages
- [ ] Add stack total value to vendor screens
- [X] Change vendor quantity dialog to default to max

## Compatibility

- Now fully compatible with the [Missing Persons](https://www.nexusmods.com/cyberpunk2077/mods/5058) mod, when the option is selected in the Mod Settings screen

## Credits & Thanks
- jekky for the [redscript compiler](https://github.com/jac3km4/redscript)
- jackhumbert for [Mod Settings](https://github.com/jackhumbert/mod_settings) and [Input Loader](https://github.com/jackhumbert/cyberpunk2077-input-loader)
- psiberx for [ArchiveXL](https://github.com/psiberx/cp2077-archive-xl)
- djkovrik for the Fast Buy/Sell mechanic
- The [CP77 modding discord](https://discord.gg/Epkq79kd96)

-----

## For redscript devs

To prevent any possible future naming conflicts:
 - All added methods are `flib` prefixed
 - All added fields are `f_` prefixed

### Existing class modifications
```swift

class DialerContactDataView {
  // Replaced method
  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool
}

class FullscreenVendorGameController {
  // Added fields
  protected let fFastButton: CName;
  // Added method
  private func flibGetMaxPurchasable(item: wref<UIInventoryItem>, actionType: QuantityPickerActionType) -> Int32
  // Wrapped methods
  private func Init() -> Void
  protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool
  protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool
  private func HandleVendorSlotInput(evt: ref<ItemDisplayClickEvent>) -> Void
}

class ItemQuantityPickerController {
  // Wrapped method
  private final func SetData() -> Void
}

```
