@addField(QuestDetailsPanelController)
let m_selectedVehicleQuestId: String;

@replaceMethod(QuestDetailsPanelController)
public final func Setup(questData: wref<JournalQuest>, journalManager: wref<JournalManager>, phoneSystem: wref<PhoneSystem>, mappinSystem: wref<MappinSystem>, game: GameInstance, opt skipAnimation: Bool) -> Void {
  let playerLevel: Float = GameInstance.GetStatsSystem(game).GetStatValue(Cast(GameInstance.GetPlayerSystem(game).GetLocalPlayerMainGameObject().GetEntityID()), gamedataStatType.Level);
  let recommendedLevel: Int32 = GameInstance.GetLevelAssignmentSystem(game).GetLevelAssignment(questData.GetRecommendedLevelID());
  this.m_currentQuestData = questData;
  this.m_journalManager = journalManager;
  this.m_phoneSystem = phoneSystem;
  this.m_mappinSystem = mappinSystem;
  inkWidgetRef.SetVisible(this.m_noSelectedQuestContainer, false);
  inkWidgetRef.SetVisible(this.m_contentContainer, true);
  inkTextRef.SetText(this.m_questTitle, questData.GetTitle(journalManager));
  inkWidgetRef.SetState(this.m_questLevel, QuestLogUtils.GetLevelState(RoundMath(playerLevel), recommendedLevel));
  inkTextRef.SetText(this.m_questLevel, QuestLogUtils.GetThreatText(RoundMath(playerLevel), recommendedLevel));
  inkTextRef.SetText(this.m_questDescription, "");
  this.m_trackedObjective = journalManager.GetTrackedEntry() as JournalQuestObjective;
  inkCompoundRef.RemoveAllChildren(this.m_codexLinksContainer);
  // Save id for VehicleQuest type
  if Equals(questData.GetType(), gameJournalQuestType.VehicleQuest) {
    this.m_selectedVehicleQuestId = questData.GetId();
  } else {
    this.m_selectedVehicleQuestId = "";
  };
  this.PopulateObjectives();
}

@addMethod(QuestMappinLinkController)
public func SetupVehicleIcon(questId: String) -> Void {
  let iconRecord: ref<UIIcon_Record> = GetVehicleIcon_UI(questId);
  inkImageRef.SetAtlasResource(this.m_linkImage, iconRecord.AtlasResourcePath());
  inkImageRef.SetTexturePart(this.m_linkImage, iconRecord.AtlasPartName());
}

@replaceMethod(QuestDetailsPanelController)
private final func SpawnMappinLink(mappinEntry: ref<JournalQuestMapPinBase>, jumpTo: Vector3) -> Void {
  let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_codexLinksContainer), n"linkMappin");
  let controller: ref<QuestMappinLinkController> = widget.GetController() as QuestMappinLinkController;
  controller.Setup(mappinEntry, jumpTo);
  if NotEquals(this.m_selectedVehicleQuestId, "") {
    controller.SetupVehicleIcon(this.m_selectedVehicleQuestId);
  };
}

// Helper method to get the vehicle journal icon
public static func GetVehicleIcon_UI(questId: String) -> ref<UIIcon_Record> {
  let iconRecord: ref<UIIcon_Record>;
  switch (questId) {
    // --- Bikes:
    // Kusanagi CT-3X
    case "yaiba_kusanagi": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sportbike1_yaiba_kusanagi_player"));
    // Nazare Racer
    case "arch": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sportbike2_arch_player"));
    // Apollo
    case "brennan_apollo": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sportbike3_brennan_apollo_player"));
    
    // --- Sport 1:
    // Outlaw GTS
    case "herrera_outlaw": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport1_herrera_outlaw_player"));
    // Rayfield Aerondight "Guinevere"
    case "rayfield_aerondight": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport1_rayfield_aerondight_player"));
    // Rayfield Caliburn
    case "rayfield_caliburn": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport1_rayfield_caliburn_player"));
    // Turbo-R 740
    case "quadra_turbo": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport1_quadra_turbo_player"));
    
    // --- Sport 2:
    // Shion MZ2
    case "mizutani_shion": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_mizutani_shion_player"));
    // Shion "Coyote"
    case "mizutani_shion_nomad": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_mizutani_shion_nomad_player"));
    // Type-66 640 TS
    case "quadra_type66": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_quadra_type66_player"));
    // Quadra Type-66 Avenger
    case "quadra_type66_avenger": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_quadra_type66_avenger_player"));
    // Quadra Type-66 "Javelina"
    case "quadra_type66_nomad": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_quadra_type66_nomad_player"));
    // Quadra Type-66 "Cthulhu"
    case "quadra_type66_nomad_ncu": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_quadra_type66_ncu_player"));
    // Alvarado V4F 570 Delegate
    case "villefort_alvarado": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_sport2_villefort_alvarado_player"));
    
    // --- Standard 2:
    // Quartz EC-L r275
    case "archer_quartz": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_archer_quartz_player"));
    // Thrax 388 Jefferson
    case "chevalier_thrax": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_chevalier_thrax_player"));
    // MaiMai P126
    case "makigai_maimai": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_makigai_maimai_player"));
    // Thorton Colby C240t
    case "thorton_colby": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_thorton_colby_player"));
    // Galena G240
    case "thorton_galena": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_thorton_galena_player"));
    // Thorton Galena "Gecko"
    case "thorton_galena_nomad": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_thorton_galena_nomad_player"));
    // Cortes V5000 Valor
    case "villefort_cortes": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard2_villefort_cortes_player"));
    
    // --- Standard 2.5:
    // Supron FS3
    case "mahir_supron": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard25_mahir_supron_player"));
    // Thorton Colby "Little Mule"
    case "thorton_colby_nomad": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard25_thorton_colby_nomad_player"));
    // Thorton Colby CX410 Butte
    case "thorton_colby_pickup": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard25_thorton_colby_pickup_player"));
    // Columbus V340-F Freight
    case "villefort_columbus": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard25_villefort_columbus_player"));
    
    // --- Standard 3:
    // Emperor 620 Ragnar
    case "chevalier_emperor": return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard3_chevalier_emperor_player"));
    // Mackinaw MTL1
    case "thorton_mackinaw":return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_standard3_thorton_mackinaw_player"));   
  };

  return TweakDBInterface.GetUIIconRecord(TDBID.Create("UIJournalIcons.v_" + questId));
}
