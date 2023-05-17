
enum flibQuantityDefault {
  Min = 0,
  Mid = 1,
  Max = 2
}

enum flibIconicSetting {
  Allow = 0,
  Confirm = 1,
  Prevent = 2
}

enum flibGroupDefault {
  Expand = 0,
  Unread = 1,
  Collapse = 2
}

public class flibSettings extends ScriptableSystem {

  // -----------------------------------------------------------------------------------------------
  // Feature Enable

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Features")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Feat-FastBuySell")
  @runtimeProperty("ModSettings.description", "flib-Settings-Feat-FastBuySell-Desc")
  public let FastBuySell: Bool = true;

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Features")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Feat-QtyPickerDefault")
  @runtimeProperty("ModSettings.description", "flib-Settings-Feat-QtyPickerDefault-Desc")
  @runtimeProperty("ModSettings.displayValues.Min", "flib-Enum-QtyDefault-Min")
  @runtimeProperty("ModSettings.displayValues.Mid", "flib-Enum-QtyDefault-Mid")
  @runtimeProperty("ModSettings.displayValues.Max", "flib-Enum-QtyDefault-Max")
  public let QuantityPickerDefault: flibQuantityDefault = flibQuantityDefault.Max;

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Features")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Feat-ExcludeOwnedMods")
  @runtimeProperty("ModSettings.description", "flib-Settings-Feat-ExcludeOwnedMods-Desc")
  public let ExcludeOwnedMods: Bool = true;

  // -----------------------------------------------------------------------------------------------
  // Journal Group Defaults

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Groups")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Groups-Messages")
  @runtimeProperty("ModSettings.description", "flib-Settings-Groups-Messages-Desc")
  @runtimeProperty("ModSettings.displayValues.Expand", "flib-Enum-Group-Expand")
  @runtimeProperty("ModSettings.displayValues.Unread", "flib-Enum-Group-Unread")
  @runtimeProperty("ModSettings.displayValues.Collapse", "flib-Enum-Group-Collapse")
  public let MessagesDefault: flibGroupDefault = flibGroupDefault.Unread;

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Groups")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Groups-Shards")
  @runtimeProperty("ModSettings.description", "flib-Settings-Groups-Shards-Desc")
  @runtimeProperty("ModSettings.displayValues.Expand", "flib-Enum-Group-Expand")
  @runtimeProperty("ModSettings.displayValues.Unread", "flib-Enum-Group-Unread")
  @runtimeProperty("ModSettings.displayValues.Collapse", "flib-Enum-Group-Collapse")
  public let ShardsDefault: flibGroupDefault = flibGroupDefault.Unread;

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Groups")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Groups-Codex")
  @runtimeProperty("ModSettings.description", "flib-Settings-Groups-Codex-Desc")
  @runtimeProperty("ModSettings.displayValues.Expand", "flib-Enum-Group-Expand")
  @runtimeProperty("ModSettings.displayValues.Unread", "flib-Enum-Group-Unread")
  @runtimeProperty("ModSettings.displayValues.Collapse", "flib-Enum-Group-Collapse")
  public let CodexDefault: flibGroupDefault = flibGroupDefault.Unread;

  // -----------------------------------------------------------------------------------------------
  // Iconic Items

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Iconic")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Iconic-Disassembly")
  @runtimeProperty("ModSettings.description", "flib-Settings-Iconic-Disassembly-Desc")
  @runtimeProperty("ModSettings.displayValues.Allow", "flib-Enum-Iconic-Allow")
  @runtimeProperty("ModSettings.displayValues.Confirm", "flib-Enum-Iconic-Confirm")
  @runtimeProperty("ModSettings.displayValues.Prevent", "flib-Enum-Iconic-Prevent")
  public let IconicDisassembly: flibIconicSetting = flibIconicSetting.Confirm;

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Iconic")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Iconic-Sale")
  @runtimeProperty("ModSettings.description", "flib-Settings-Iconic-Sale-Desc")
  @runtimeProperty("ModSettings.displayValues.Allow", "flib-Enum-Iconic-Allow")
  @runtimeProperty("ModSettings.displayValues.Confirm", "flib-Enum-Iconic-Confirm")
  @runtimeProperty("ModSettings.displayValues.Prevent", "flib-Enum-Iconic-Prevent")
  public let IconicSale: flibIconicSetting = flibIconicSetting.Confirm;

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Iconic")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Iconic-FastSale")
  @runtimeProperty("ModSettings.description", "flib-Settings-Iconic-FastSale-Desc")
  @runtimeProperty("ModSettings.displayValues.Allow", "flib-Enum-Iconic-Allow")
  @runtimeProperty("ModSettings.displayValues.Confirm", "flib-Enum-Iconic-Confirm")
  @runtimeProperty("ModSettings.displayValues.Prevent", "flib-Enum-Iconic-Prevent")
  public let IconicFastSale: flibIconicSetting = flibIconicSetting.Confirm;

  // -----------------------------------------------------------------------------------------------
  // Mod Support

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Mods")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Mods-UseInputLoader")
  @runtimeProperty("ModSettings.description", "flib-Settings-Mods-UseInputLoader-Desc")
  public let UseInputLoader: Bool = false;
  
  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Mods")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Mods-VirtualAtelier")
  @runtimeProperty("ModSettings.description", "flib-Settings-Mods-VirtualAtelier-Desc")
  public let VirtualAtelier: Bool = false;

  @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
  @runtimeProperty("ModSettings.category", "flib-Settings-Category-Mods")
  @runtimeProperty("ModSettings.displayName", "flib-Settings-Mods-MissingPersons")
  @runtimeProperty("ModSettings.description", "flib-Settings-Mods-MissingPersons-Desc")
  public let MissingPersons: Bool = false;

  // -----------------------------------------------------------------------------------------------
  // ScriptableSystem

  // Get singleton instance from the Scriptable Systems Container
  public static func Get(gi: GameInstance) -> ref<flibSettings> {
    return GameInstance.GetScriptableSystemsContainer(gi).Get(n"flibSettings") as flibSettings;
  }
  
  private func OnAttach() -> Void { flibRegisterListener(this); }
  private func OnDetach() -> Void { flibUnregisterListener(this); }

  // -----------------------------------------------------------------------------------------------
  // Helper methods 

  public func GetSortingEventName() -> CName {
    return this.UseInputLoader ? n"ToggleSorting" : n"toggle_comparison_tooltip";
  }

  public func GetFastBuyEventName() -> CName {
    return this.UseInputLoader ? n"FastBuySell" : n"activate_secondary";
  }
}


// ModSettings helpers
@if(ModuleExists("ModSettingsModule")) 
public func flibRegisterListener(listener: ref<IScriptable>) {
  ModSettings.RegisterListenerToClass(listener);
}

@if(ModuleExists("ModSettingsModule")) 
public func flibUnregisterListener(listener: ref<IScriptable>) {
  ModSettings.UnregisterListenerToClass(listener);
}

@if(!ModuleExists("ModSettingsModule")) 
public func flibRegisterListener(listener: ref<IScriptable>) { }

@if(!ModuleExists("ModSettingsModule")) 
public func flibUnregisterListener(listener: ref<IScriptable>) { }
