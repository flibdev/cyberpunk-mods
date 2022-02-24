// Adds an option to buy/sell whole stacks without a quantity popup by using right mouse button click

@addField(FullscreenVendorGameController)
protected let fFastButton: CName;

@addField(FullscreenVendorGameController)
protected let fFastBuyText: String;

@addField(FullscreenVendorGameController)
protected let fFastSellText: String;

@wrapMethod(FullscreenVendorGameController)
private final func Init() -> Void {
  wrappedMethod();

  this.fFastButton = n"activate_secondary";

  // This word split works in English and Russian, unsure about other languages
  // LocKey#40340 = Fast Attack
  let fastText = StrBeforeFirst(GetLocalizedText("LocKey#40340"), " ");
  // LocKey#17847 = Buy
  this.fFastBuyText = fastText + " " + GetLocalizedText("LocKey#17847");
  // LocKey#17848 = Sell
  this.fFastSellText = fastText + " " + GetLocalizedText("LocKey#17848");
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  let targetItem: InventoryItemData = evt.itemData;
  let wrapped: Bool = wrappedMethod(evt);
  let sellStackLocalizedText: String;

  if !IsDefined(this.m_storageUserData) && IsDefined(this.m_vendorUserData) {
    if InventoryItemData.IsVendorItem(targetItem) {
      this.m_buttonHintsController.AddButtonHint(this.fFastButton, this.fFastBuyText);
    }
    else {
      if this.m_VendorDataManager.CanPlayerSellItem(InventoryItemData.GetID(targetItem)) {
        this.m_buttonHintsController.AddButtonHint(this.fFastButton, this.fFastSellText);
      }
    }
  }

  return wrapped;
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
  this.m_buttonHintsController.RemoveButtonHint(this.fFastButton);
  return wrappedMethod(evt);
}

@wrapMethod(FullscreenVendorGameController)
private final func HandleVendorSlotInput(evt: ref<ItemDisplayClickEvent>, itemData: InventoryItemData) -> Void {
  wrappedMethod(evt, itemData);

  if evt.actionName.IsAction(this.fFastButton) {
    let maxQty: Int32;

    if (InventoryItemData.IsVendorItem(itemData)) {
      maxQty = this.flibGetMaxQuantity(itemData, QuantityPickerActionType.Buy);
      this.BuyItem(InventoryItemData.GetGameItemData(itemData), maxQty);
      this.PlaySound(n"Item", n"OnBuy");
    }
    else {
      maxQty = this.flibGetMaxQuantity(itemData, QuantityPickerActionType.Sell);
      this.SellItem(InventoryItemData.GetGameItemData(itemData), maxQty);
      this.PlaySound(n"Item", n"OnSell");
    }

    this.m_TooltipsManager.HideTooltips();
  }
}
