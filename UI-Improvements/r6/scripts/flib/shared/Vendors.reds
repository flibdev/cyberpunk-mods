
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


// Adds max limitation to vendor quantity picker
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
