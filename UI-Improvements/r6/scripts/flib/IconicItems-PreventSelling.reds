
@replaceMethod(Vendor)
public final const func PlayerCanSell(itemID: ItemID, allowQuestItems: Bool, excludeEquipped: Bool) -> Bool {
  let hasInverseTag: Bool;
  let i: Int32;
  let inverseFilterTags: array<CName>;
  let itemData: wref<gameItemData>;
  let itemTags: array<CName>;
  let player: wref<GameObject>;
  let filterTags: array<CName> = this.m_vendorRecord.CustomerFilterTags();
  if allowQuestItems {
    ArrayRemove(filterTags, n"Quest");
  };
  inverseFilterTags = TDB.GetCNameArray(this.m_vendorRecord.GetID() + t".customerInverseFilterTags");
  itemTags = RPGManager.GetItemRecord(itemID).Tags();
  player = GetPlayer(this.m_gameInstance);
  itemData = GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemData(player, itemID);
  // Prevent any sale of iconic items
  if RPGManager.IsItemIconic(itemData) {
    return false;
  }
  if excludeEquipped && EquipmentSystem.GetInstance(player).IsEquipped(player, itemID) {
    return false;
  };
  if ArraySize(inverseFilterTags) > 0 {
    i = 0;
    while i < ArraySize(inverseFilterTags) {
      if itemData.HasTag(inverseFilterTags[i]) {
        hasInverseTag = true;
      } else {
        i += 1;
      };
    };
    if !hasInverseTag {
      return false;
    };
  };
  i = 0;
  while i < ArraySize(filterTags) {
    if itemData.HasTag(filterTags[i]) {
      return false;
    };
    i += 1;
  };
  return true;
}
