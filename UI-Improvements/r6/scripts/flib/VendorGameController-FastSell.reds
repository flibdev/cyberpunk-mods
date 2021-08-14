// Adds an option for stacked items to sell the whole stack without a quantity popup by using right mouse button click

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  let targetItem: InventoryItemData = evt.itemData;
  let wrapped: Bool = wrappedMethod(evt);
  let sellStackLocalizedText: String;

  if this.m_VendorDataManager.CanPlayerSellItem(InventoryItemData.GetID(targetItem)) && !InventoryItemData.IsVendorItem(targetItem) && !IsDefined(this.m_storageUserData) && IsDefined(this.m_vendorUserData) && InventoryItemData.GetQuantity(targetItem) > 1 {
    // LocKey#40340 = Fast Attack, LocKey#17848 = Sell
    sellStackLocalizedText = StrBeforeFirst(GetLocalizedText("LocKey#40340"), " ") + " " + GetLocalizedText("LocKey#17848") ;
    this.m_buttonHintsController.AddButtonHint(n"world_map_menu_rotate_mouse", sellStackLocalizedText);
  };

  return wrapped;
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
  this.m_buttonHintsController.RemoveButtonHint(n"world_map_menu_rotate_mouse");
  return wrappedMethod(evt);
}

@wrapMethod(FullscreenVendorGameController)
private final func HandleVendorSlotInput(evt: ref<ItemDisplayClickEvent>, itemData: InventoryItemData) -> Void {
  wrappedMethod(evt, itemData);

  if evt.actionName.IsAction(n"world_map_menu_rotate_mouse") && !InventoryItemData.IsVendorItem(itemData) && InventoryItemData.GetQuantity(itemData) > 1 {
    this.SellItem(InventoryItemData.GetGameItemData(itemData), InventoryItemData.GetQuantity(itemData));
  };
}
