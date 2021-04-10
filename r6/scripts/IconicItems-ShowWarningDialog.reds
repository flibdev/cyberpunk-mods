
@addField(InventoryItemModeLogicController)
private let m_confirmationPopupToken: ref<inkGameNotificationToken>;

@replaceMethod(InventoryItemModeLogicController)
private final func HandleItemHold(itemData: InventoryItemData, actionName: ref<inkActionName>) -> Void {
  if actionName.IsAction(n"disassemble_item") && !this.m_isE3Demo && RPGManager.CanItemBeDisassembled(this.m_player.GetGame(), InventoryItemData.GetGameItemData(itemData)) {
    if InventoryItemData.GetQuantity(itemData) > 1 {
      this.OpenQuantityPicker(itemData, QuantityPickerActionType.Disassembly);
    } else {
      if RPGManager.IsItemIconic(InventoryItemData.GetGameItemData(itemData)) {
        this.ShowIconicConfirmationPopup(itemData);
      } else {
        ItemActionsHelper.DisassembleItem(this.m_player, InventoryItemData.GetID(itemData));
        this.PlaySound(n"Item", n"OnDisassemble");
      }
    };
  } else {
    if actionName.IsAction(n"use_item") {
      if !InventoryGPRestrictionHelper.CanUse(itemData, this.m_player) {
        this.ShowNotification(this.m_player.GetGame(), this.DetermineUIMenuNotificationType());
        return ;
      };
      ItemActionsHelper.PerformItemAction(this.m_player, InventoryItemData.GetID(itemData));
      this.m_InventoryManager.MarkToRebuild();
    };
  };
}

@addMethod(InventoryItemModeLogicController)
private final func ShowIconicConfirmationPopup(itemData: InventoryItemData) -> Void {
  let data = new VendorConfirmationPopupData();
  data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\vendor_confirmation.inkwidget";
  data.isBlocking = true;
  data.useCursor = true;
  data.queueName = n"modal_popup";
  data.itemData = itemData;
  data.quantity = InventoryItemData.GetQuantity(itemData);
  data.type = VendorConfirmationPopupType.DisassembeIconic;
  this.m_confirmationPopupToken = this.m_inventoryController.ShowGameNotification(data);
  this.m_confirmationPopupToken.RegisterListener(this, n"OnIconicConfirmationClosed");
}


@addMethod(InventoryItemModeLogicController)
protected cb func OnIconicConfirmationClosed(data: ref<inkGameNotificationData>) -> Bool {
  this.m_confirmationPopupToken = null;
  let resultData = (data as VendorConfirmationPopupCloseData);
  if resultData.confirm {
    ItemActionsHelper.DisassembleItem(this.m_player, InventoryItemData.GetID(resultData.itemData));
    this.PlaySound(n"Item", n"OnDisassemble");
  };
}
