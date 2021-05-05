
@replaceMethod(InventoryItemData)
public final static func SetItemType(out self: InventoryItemData, itemType: gamedataItemType) -> Void {
  self.ItemType = itemType;

  if Equals(itemType, gamedataItemType.Prt_Scope) || Equals(itemType, gamedataItemType.Prt_ScopeRail) {
    let gid: ref<gameItemData> = InventoryItemData.GetGameItemData(self);

    if IsDefined(gid) {
      let name: String = UIItemsHelper.GetItemName(self);
      let type: String = UIItemsHelper.GetItemTypeKey(itemType);

      Log("\n--------------------------------------------------------------------------------");
      Log(" GetItemName    = " + name);
      Log(" GetItemTypeKey = " + type);
      Log("   -> Localized = " + GetLocalizedText(type));
      Log("--------------------------------------------------------------------------------\n");
    }
  }
}

// @replaceMethod(ItemTooltipHeaderController)
// public func Update(data: ref<MinimalItemTooltipData>) -> Void {
//   inkTextRef.SetText(this.m_itemTypeText, UIItemsHelper.GetItemTypeKey(data.itemType, data.itemEvolution));
//   if this.UseCraftingLayout(data) {
//     inkWidgetRef.SetVisible(this.m_itemNameText, false);
//     inkWidgetRef.SetVisible(this.m_itemRarityText, false);
//   } else {
//     this.UpdateName(data);
//     this.UpdateRarity(data);
//   };

//   if Equals(data.itemType, gamedataItemType.Prt_Scope) {
    
//   }
// }
