
enum ActionSetting {
    Confirm = 0,
    Prevent = 1
}

public class flibSettings extends ScriptableSystem {

    // -------------------------------------------------------------------------
    // Iconic Items

    @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
    @runtimeProperty("ModSettings.category", "flib-Settings-Category-Iconic")
    @runtimeProperty("ModSettings.displayName", "flib-Settings-Iconic-Disassembly")
    @runtimeProperty("ModSettings.displayValues.Confirm", "flib-Settings-Action-Confirm")
    @runtimeProperty("ModSettings.displayValues.Prevent", "flib-Settings-Action-Prevent")
    public let IconicDisassembly: ActionSetting = ActionSetting.Confirm;

    @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
    @runtimeProperty("ModSettings.category", "flib-Settings-Category-Iconic")
    @runtimeProperty("ModSettings.displayName", "flib-Settings-Iconic-Sale")
    @runtimeProperty("ModSettings.displayValues.Confirm", "flib-Settings-Action-Confirm")
    @runtimeProperty("ModSettings.displayValues.Prevent", "flib-Settings-Action-Prevent")
    public let IconicSale: ActionSetting = ActionSetting.Confirm;

    // -------------------------------------------------------------------------
    // Minor Fixes

    @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
    @runtimeProperty("ModSettings.category", "flib-Settings-Category-Fixes")
    @runtimeProperty("ModSettings.displayName", "flib-Settings-Fixes-ExcludeOwnedMods")
    @runtimeProperty("ModSettings.description", "flib-Settings-Fixes-ExcludeOwnedMods-Desc")
    public let ExcludeOwnedMods: Bool = true;

    // -------------------------------------------------------------------------
    // Mod Support

    @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
    @runtimeProperty("ModSettings.category", "flib-Settings-Category-Mods")
    @runtimeProperty("ModSettings.displayName", "flib-Settings-Mods-UseInputLoader")
    public let UseInputLoader: Bool = false;



    // Get singleton instance from the Scriptable Systems Container
    public static func Get(gi: GameInstance) -> ref<flibSettings> {
        return GameInstance
            .GetScriptableSystemsContainer(gi)
            .Get(n"flibSettings") as flibSettings;
    }

    // Add an Attach listener so our values are updated in real time
    private func OnAttach() -> Void {
        flibRegisterListener(this);
    }

    public func GetSortingEventName() -> CName {
        return this.UseInputLoader ? n"ToggleSorting" : n"toggle_comparison_tooltip";
    }

    public func GetFastBuyEventname() -> CName {
        return this.UseInputLoader ? n"FastBuySell" : n"activate_secondary";
    }
}


// ModSettings listener helper
@if(ModuleExists("ModSettingsModule")) 
public func flibRegisterListener(listener: ref<IScriptable>) {
  ModSettings.RegisterListenerToClass(listener);
}

@if(!ModuleExists("ModSettingsModule")) 
public func flibRegisterListener(listener: ref<IScriptable>) { }
