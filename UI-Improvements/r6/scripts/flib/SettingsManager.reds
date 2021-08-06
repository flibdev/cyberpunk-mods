
@replaceMethod(SingleplayerMenuGameController)
private func PopulateMenuItemList() -> Void {
  if this.m_savesCount > 0 {
    this.AddMenuItem(GetLocalizedText("UI-ScriptExports-Continue0"), PauseMenuAction.QuickLoad);
  };
  this.AddMenuItem(GetLocalizedText("UI-ScriptExports-NewGame0"), n"OnNewGame");
  this.AddMenuItem(GetLocalizedText("UI-ScriptExports-LoadGame0"), n"OnLoadGame");
  this.AddMenuItem(GetLocalizedText("UI-Labels-Settings"), n"OnSwitchToSettings");
  this.AddMenuItem(GetLocalizedText("UI-ResourceExports-ModsWidget"), n"OnSwitchToModSettings");
  this.AddMenuItem(GetLocalizedText("UI-Labels-Credits"), n"OnSwitchToCredits");
  if !IsFinal() || UseProfiler() {
    this.AddMenuItem("DEBUG NEW GAME", n"OnDebug");
  };
  this.m_menuListController.Refresh();
  this.SetCursorOverWidget(inkCompoundRef.GetWidgetByIndex(this.m_menuList, 0));
}

@addMethod(MenuScenario_SingleplayerMenu)
protected cb func OnSwitchToModSettings() -> Bool {
  this.CloseSubMenu();
  this.SwitchToScenario(n"MenuScenario_ModSettings");
}



public class MenuScenario_ModSettings extends MenuScenario_PreGameSubMenu {
  protected cb func OnEnterScenario(prevScenario: CName, userData: ref<IScriptable>) -> Bool {
    super.OnEnterScenario(prevScenario, userData);
    this.GetMenusState().OpenMenu(n"settings_main");
  }

  protected cb func OnLeaveScenario(nextScenario: CName) -> Bool {
    super.OnLeaveScenario(nextScenario);
    this.GetMenusState().CloseMenu(n"settings_main");
  }

  protected cb func OnMainMenuBack() -> Bool {
    this.SwitchToScenario(this.m_prevScenario);
  }
}
