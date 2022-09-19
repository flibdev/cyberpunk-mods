
@wrapMethod(CraftingSystem)
public final const func CanItemBeDisassembled(itemData: wref<gameItemData>) -> Bool {
  if IsDefined(itemData) {
    return !RPGManager.IsItemIconic(itemData) && wrappedMethod(itemData);
  }
  return false;
}
