# flib's UI Improvements

A collection of quality-of-life UI improvements to fix minor issues that annoyed me.

### Inventory
- Iconic Items cannot be disassembled

### Crafting
- Ammo crafting is limited to the maximum carryable per type

### Journal
- Sort Jobs dynamically by timestamp/name/difficulty
- Sort Messages dynamically by timestamp/name
- Sort Shards dynamically by timestamp/name

### Dialer Menu
- Sorting by either name or timestamp (install time choice)
- Always shows contacts that are Quest Related or have unread messages first

### Vendors:
- Iconic Items cannot be sold
- Ripperdoc vendor screen only shows number of unowned mods per body category

## TODO
- [X] Limit ammo crafting to type limit
- [X] Sort menus dynamically
  - [X] Steal sorting widget from other controllers
- [ ] Show scope type in tooltip
  - Looks like that information is stored in the TweakDB
- [ ] Add search filter to shards/messages


## Compatability

- Incompatible with my previous mod [Stop Accidentally Disassembling Iconics](https://www.nexusmods.com/cyberpunk2077/mods/2252) as it implements the same features
- Incompatible with [Sorted Menus](https://www.nexusmods.com/cyberpunk2077/mods/1439) as it implements the same functionality

## Credits
- jekky for the [redscript compiler](https://github.com/jac3km4/redscript)
- djkovrik for releasing mods implementing the same features but faster
- The [CP77 modding discord](https://discord.gg/Epkq79kd96)


## For redscript devs
```swift
// class CraftingSystem
// addMethods
protected func GetAmmoCraftingMaximum(itemRecord: wref<Item_Record>) -> Int32
protected func GetAmmoCraftingMaximum(itemData: wref<gameItemData>) -> Int32
// replaceMethods
public final const func GetMaxCraftingAmount(itemData: wref<gameItemData>) -> Int32
public final const func CanItemBeCrafted(itemData: wref<gameItemData>) -> Bool
public final const func CanItemBeCrafted(itemRecord: wref<Item_Record>) -> Bool

// class DialerContactDataView
// replaceMethod
public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool

// Still filling this out
```
