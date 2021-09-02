
@wrapMethod(CraftingSystem)
public final const func CanItemBeDisassembled(itemData: wref<gameItemData>) -> Bool {
  if IsDefined(itemData) {
    return !RPGManager.IsItemIconic(itemData) && wrappedMethod(itemData);
  };
  return false;
}

@wrapMethod(Vendor)
public final const func PlayerCanSell(itemID: ItemID, allowQuestItems: Bool, excludeEquipped: Bool) -> Bool {
  let player: wref<GameObject> = GetPlayer(this.m_gameInstance);
  let itemData: wref<gameItemData> = GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemData(player, itemID);
  // Prevent any sale of iconic items
  if IsDefined(itemData) && RPGManager.IsItemIconic(itemData) {
    return false;
  }
  return wrappedMethod(itemID, allowQuestItems, excludeEquipped);
}
