
@replaceMethod(CraftingSystem)
public final const func CanItemBeDisassembled(itemData: wref<gameItemData>) -> Bool {
  if NotEquals(itemData, null) {
    return !itemData.HasTag(n"Quest")
        && !itemData.HasTag(n"UnequipBlocked")
        && !RPGManager.IsItemIconic(itemData)
        && NotEquals(ItemActionsHelper.GetDisassembleAction(itemData.GetID()), null);
  };
  return false;
}
