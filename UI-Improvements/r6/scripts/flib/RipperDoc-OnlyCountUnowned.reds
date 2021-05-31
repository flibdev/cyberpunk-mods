/// Removed old logic that included player owned items in total
@replaceMethod(RipperDocGameController)
private final func GetAmountOfAvailableItems(equipArea: gamedataEquipmentArea) -> Int32 {
  let ripperdocInventory = this.GetRipperdocItemsForEquipmentArea(equipArea);
  return ArraySize(ripperdocInventory);
}
