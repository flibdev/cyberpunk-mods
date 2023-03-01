
@addField(CraftingSystem)
private let f_settings: ref<flibSettings>;

@wrapMethod(CraftingSystem)
private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
  wrappedMethod(request);

  this.f_settings = flibSettings.Get(request.owner.GetGame());
}

@wrapMethod(CraftingSystem)
public final const func CanItemBeDisassembled(itemData: wref<gameItemData>) -> Bool {
  if IsDefined(itemData) && RPGManager.IsItemIconic(itemData) {
    switch this.f_settings.IconicDisassembly {
      case ActionSetting.Allow:
        return wrappedMethod(itemData);
        break;
      case ActionSetting.Confirm:
        // trigger dialog
        break;
      case ActionSetting.Prevent:
        return false;
        break;
      default:
        // Shouldn't be able to get here, but shrug
        return wrappedMethod(itemData);
        break;
    }
  }
  return false;
}
