
enum ActionSetting {
    Allow = 0,
    Confirm = 1,
    Prevent = 2
}

public class flibSettings extends ScriptableSystem {

    @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
    @runtimeProperty("ModSettings.category", "flib-Settings-Category-Iconic")
    @runtimeProperty("ModSettings.displayName", "flib-Settings-Iconic-Disassembly")
    @runtimeProperty("ModSettings.displayValues.Allow", "flib-Settings-Action-Allow")
    @runtimeProperty("ModSettings.displayValues.Confirm", "flib-Settings-Action-Confirm")
    @runtimeProperty("ModSettings.displayValues.Prevent", "flib-Settings-Action-Prevent")
    public let IconicDisassembly: ActionSetting = ActionSetting.Confirm;

    @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
    @runtimeProperty("ModSettings.category", "flib-Settings-Category-Iconic")
    @runtimeProperty("ModSettings.displayName", "flib-Settings-Iconic-Sale")
    @runtimeProperty("ModSettings.displayValues.Allow", "flib-Settings-Action-Allow")
    @runtimeProperty("ModSettings.displayValues.Confirm", "flib-Settings-Action-Confirm")
    @runtimeProperty("ModSettings.displayValues.Prevent", "flib-Settings-Action-Prevent")
    public let IconicSale: ActionSetting = ActionSetting.Confirm;

    // -------------------------------------------------------------------------

    @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
    @runtimeProperty("ModSettings.category", "flib-Settings-Category-Sorting")
    @runtimeProperty("ModSettings.displayName", "flib-Settings-Sorting-UseInputLoader")
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
}

// ModSettings listener registration helper
@if(ModuleExists("ModSettingsModule")) 
public func flibRegisterListener(listener: ref<IScriptable>) {
  ModSettings.RegisterListenerToClass(listener);
}

@if(!ModuleExists("ModSettingsModule")) 
public func flibRegisterListener(listener: ref<IScriptable>) { }

public exec func flibTest(gi: GameInstance) -> Void {
    LogChannel(n"DEBUG", "flibTest()");
    let settings = flibSettings.Get(gi);

    LogChannel(n"DEBUG", "UseInputLoader = " + (settings.UseInputLoader ? "True" : "False"));
    LogChannel(n"DEBUG", "GetSortingEventName() = " + NameToString(settings.GetSortingEventName()));
}
