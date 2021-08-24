// Adds an option for stacked items to sell the whole stack without a quantity popup by using right mouse button click

@addField(FullscreenVendorGameController)
protected let fSellAllText: String;

@wrapMethod(FullscreenVendorGameController)
private final func Init() -> Void {
  wrappedMethod();
  // This word split works in English and Russian, unsure about other languages
  // LocKey#40340 = Fast Attack
  // LocKey#17848 = Sell
  this.fSellAllText = StrBeforeFirst(GetLocalizedText("LocKey#40340"), " ") + " " + GetLocalizedText("LocKey#11468");
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  let targetItem: InventoryItemData = evt.itemData;
  let wrapped: Bool = wrappedMethod(evt);
  let sellStackLocalizedText: String;

  if this.m_VendorDataManager.CanPlayerSellItem(InventoryItemData.GetID(targetItem)) && !InventoryItemData.IsVendorItem(targetItem) && !IsDefined(this.m_storageUserData) && IsDefined(this.m_vendorUserData) {
    this.m_buttonHintsController.AddButtonHint(n"activate_secondary", this.fSellAllText);
  };

  return wrapped;
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
  this.m_buttonHintsController.RemoveButtonHint(n"activate_secondary");
  return wrappedMethod(evt);
}

@wrapMethod(FullscreenVendorGameController)
private final func HandleVendorSlotInput(evt: ref<ItemDisplayClickEvent>, itemData: InventoryItemData) -> Void {
  wrappedMethod(evt, itemData);

  if evt.actionName.IsAction(n"activate_secondary") && !InventoryItemData.IsVendorItem(itemData) {
    this.SellItem(InventoryItemData.GetGameItemData(itemData), InventoryItemData.GetQuantity(itemData));
  };
}
