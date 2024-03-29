// Adds an option to buy/sell whole stacks without a quantity popup by using right mouse button click

@addField(FullscreenVendorGameController)
protected let fFastButton: CName;

@wrapMethod(FullscreenVendorGameController)
private final func Init() -> Void {
  wrappedMethod();

  let fSettings = flibSettings.Get(this.m_player.GetGame());
  this.fFastButton = fSettings.GetFastBuyEventName();
}

@wrapMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  let wrapped: Bool = wrappedMethod(evt);
  let controller = inkWidgetRef.GetController(this.m_sortingDropdown) as DropdownListController;

  // Bugfix by CDPR: Ignore hover over event when the sorting dropdown is open
  if !controller.IsOpened() {
    // Shared logic from existing vendor
    if !IsDefined(this.m_storageUserData) && IsDefined(this.m_vendorUserData) {
      if Equals(evt.displayContextData.GetDisplayContext(), ItemDisplayContext.Vendor) {
        this.m_buttonHintsController.AddButtonHint(this.fFastButton, n"flib-Vendor-FastBuy");
      }
      else if this.m_VendorDataManager.CanPlayerSellItem(evt.uiInventoryItem.GetID()) && !evt.uiInventoryItem.IsIconic() {
        this.m_buttonHintsController.AddButtonHint(this.fFastButton, n"flib-Vendor-FastSell");
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
private final func HandleVendorSlotInput(evt: ref<ItemDisplayClickEvent>) -> Void {
  wrappedMethod(evt);

  let targetItem = evt.uiInventoryItem;

  if evt.actionName.IsAction(this.fFastButton) && IsDefined(targetItem) {
    let maxQty: Int32 = 0;

    switch evt.displayContextData.GetDisplayContext() {
      case ItemDisplayContext.Vendor:
        maxQty = this.flibGetMaxPurchasable(targetItem, QuantityPickerActionType.Buy);
        // CDPR new logic for ammo limits
        if (maxQty == 0) {
          let vendorNotification = new UIMenuNotificationEvent();
          vendorNotification.m_notificationType = UIMenuNotificationType.CraftingAmmoCap;
          GameInstance.GetUISystem(this.m_player.GetGame()).QueueEvent(vendorNotification);
          this.PlaySound(n"MapPin", n"OnDelete");
        }
        else {
          this.BuyItem(targetItem.GetItemData(), maxQty, evt.isBuybackStack);
          this.PlaySound(n"Item", n"OnBuy");
          this.m_TooltipsManager.HideTooltips();
        }
        break;
      case ItemDisplayContext.VendorPlayer:
        // Don't fast sell iconics
        if targetItem.IsIconic() {
          this.OpenConfirmationPopup(targetItem, targetItem.GetQuantity(), QuantityPickerActionType.Sell);
        }
        else {
          maxQty = this.flibGetMaxPurchasable(targetItem, QuantityPickerActionType.Sell);
          this.SellItem(targetItem.GetItemData(), maxQty);
          this.PlaySound(n"Item", n"OnSell");
        }
        break;
      default:
        break;
    }
  }
}

@addMethod(FullscreenVendorGameController)
private func flibGetMaxPurchasable(item: wref<UIInventoryItem>, actionType: QuantityPickerActionType) -> Int32 {
  let price: Int32 = this.GetPrice(item.GetItemData(), actionType, 1);
  let maxQty: Int32 = this.GetMaxQuantity(item, Equals(actionType, QuantityPickerActionType.Sell));
  let money: Int32 = 0;

  if (price <= 0) {
    return maxQty;
  }

  switch (actionType) {
    case QuantityPickerActionType.Sell:
      money = MarketSystem.GetVendorMoney(this.m_VendorDataManager.GetVendorInstance());
      break;
    case QuantityPickerActionType.Buy:
      money = this.m_VendorDataManager.GetLocalPlayerCurrencyAmount();
      break;
    default:
      return maxQty;
  }

  return Min(maxQty, money / price);
}
