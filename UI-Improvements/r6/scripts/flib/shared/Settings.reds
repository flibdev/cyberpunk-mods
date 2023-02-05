
enum ActionSetting {
    Allow = 0,
    ShowDialog = 1,
    Prevent = 2
}

@if(ModuleExists("ModSettingsModule")) 
public func flibRegisterListener(listener: ref<IScriptable>) {
  ModSettings.RegisterListenerToClass(listener);
}

@if(!ModuleExists("ModSettingsModule")) 
public func flibRegisterListener(listener: ref<IScriptable>) { }

public class flibSettings extends ScriptableSystem {

    @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
    @runtimeProperty("ModSettings.category", "Iconic Items")
    @runtimeProperty("ModSettings.displayName", "Disassembly")
    @runtimeProperty("ModSettings.displayValues.Allow", "Allow")
    @runtimeProperty("ModSettings.displayValues.ShowDialog", "Show Confirmation Dialog")
    @runtimeProperty("ModSettings.displayValues.Prevent", "Prevent")
    public let IconicDisassembly: ActionSetting = ActionSetting.ShowDialog;

    @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
    @runtimeProperty("ModSettings.category", "Iconic Items")
    @runtimeProperty("ModSettings.displayName", "Sale")
    @runtimeProperty("ModSettings.displayValues.Allow", "Allow")
    @runtimeProperty("ModSettings.displayValues.ShowDialog", "Show Confirmation Dialog")
    @runtimeProperty("ModSettings.displayValues.Prevent", "Prevent")
    public let IconicSale: ActionSetting = ActionSetting.ShowDialog;

    // -------------------------------------------------------------------------

    @runtimeProperty("ModSettings.mod", "flib's UI Improvements")
    @runtimeProperty("ModSettings.category", "Custom Sorting")
    @runtimeProperty("ModSettings.displayName", "Use Input Loader Binding")
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

public exec func flibTest(gi: GameInstance) -> Void {
    LogChannel(n"DEBUG", "flibTest()");
    let settings = flibSettings.Get(gi);

    LogChannel(n"DEBUG", "UseInputLoader = " + (settings.UseInputLoader ? "True" : "False"));
    LogChannel(n"DEBUG", "GetSortingEventName() = " + NameToString(settings.GetSortingEventName()));
}
