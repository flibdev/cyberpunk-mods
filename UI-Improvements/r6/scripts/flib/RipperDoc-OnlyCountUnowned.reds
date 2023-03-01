/// Add a local reference to the Settings instance
@addField(RipperDocGameController)
private let f_settings: ref<flibSettings>;

@wrapMethod(RipperDocGameController)
private final func Init() -> Void {
  this.f_settings = flibSettings.Get(this.m_player.GetGame());

  wrappedMethod();
}

@replaceMethod(RipperDocGameController)
private final func GetAmountOfAvailableItems(equipArea: gamedataEquipmentArea) -> Int32 {
  let ripperdocInventory = this.GetRipperdocItemsForEquipmentArea(equipArea);
  let size = ArraySize(ripperdocInventory);

  if !this.f_settings.ExcludeOwnedMods {
    let playerInventory = this.m_InventoryManager.GetPlayerInventoryData(equipArea);
    for item in playerInventory {
      if !InventoryItemData.IsEquipped(item) {
        size += 1;
      }
    }
  }

  return size;
}
