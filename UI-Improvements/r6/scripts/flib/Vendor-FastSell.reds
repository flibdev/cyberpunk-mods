// Adds an option to buy/sell whole stacks without a quantity popup by using right mouse button click

@addField(FullscreenVendorGameController)
protected let fFastBuyText: String;

@addField(FullscreenVendorGameController)
protected let fFastSellText: String;

@wrapMethod(FullscreenVendorGameController)
private final func Init() -> Void {
  wrappedMethod();
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
      this.m_buttonHintsController.AddButtonHint(n"activate_secondary", this.fFastBuyText);
    }
    else {
      if this.m_VendorDataManager.CanPlayerSellItem(InventoryItemData.GetID(targetItem)) {
        this.m_buttonHintsController.AddButtonHint(n"activate_secondary", this.fFastSellText);
      }
    }
  }

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

  if evt.actionName.IsAction(n"activate_secondary") {
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

// Method to limit quantities to player/vendor monetary limits
@addMethod(FullscreenVendorGameController)
private func flibGetMaxQuantity(itemData: InventoryItemData, actionType: QuantityPickerActionType) -> Int32 {
  let gameItemData: wref<gameItemData> = InventoryItemData.GetGameItemData(itemData);
  let price: Int32 = this.GetPrice(gameItemData, actionType, 1);
  let maxQty: Int32 = InventoryItemData.GetQuantity(itemData);
  let currencyTotal: Int32 = 0;

  if (price == 0) {
    return maxQty;
  }

  switch (actionType) {
    case QuantityPickerActionType.Sell:
      currencyTotal = MarketSystem.GetVendorMoney(this.m_VendorDataManager.GetVendorInstance());
      break;
    case QuantityPickerActionType.Buy:
      currencyTotal = this.m_VendorDataManager.GetLocalPlayerCurrencyAmount();
      break;
    default:
      return maxQty;
  }

  return Min(maxQty, currencyTotal / price);
}

// Adds limitation to regular quantity picker
@replaceMethod(FullscreenVendorGameController)
private final func OpenQuantityPicker(itemData: InventoryItemData, actionType: QuantityPickerActionType, opt isBuyback: Bool) -> Void {
  let data: ref<QuantityPickerPopupData> = new QuantityPickerPopupData();
  data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\item_quantity_picker.inkwidget";
  data.isBlocking = true;
  data.useCursor = true;
  data.queueName = n"modal_popup";
  data.maxValue = this.flibGetMaxQuantity(itemData, actionType);
  data.gameItemData = itemData;
  data.actionType = actionType;
  data.vendor = this.m_VendorDataManager.GetVendorInstance();
  data.isBuyback = isBuyback;
  this.m_quantityPickerPopupToken = this.ShowGameNotification(data);
  this.m_quantityPickerPopupToken.RegisterListener(this, n"OnQuantityPickerPopupClosed");
  this.m_buttonHintsController.Hide();
}