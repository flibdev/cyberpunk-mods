@replaceMethod(RipperDocGameController)
private final func GetAmountOfAvailableItems(equipArea: gamedataEquipmentArea) -> Int32 {
  // Removed old logic that included player owned items in total
  let ripperdocInventory = this.GetRipperdocItemsForEquipmentArea(equipArea);
  return ArraySize(ripperdocInventory);
}
