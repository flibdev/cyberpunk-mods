/** @file Quests - Vehicle Previews

Quests have a type enum, vehicle quests can be filtered by `gameJournalQuestType.VehicleQuest`

DJ_Kovrik and I couldn't find any references between the quest and the journal messages from the
fixer with the car image, so the image references are currently hardcoded by questID
*/

@replaceMethod(QuestDetailsPanelController)
private final func SpawnMappinLink(mappinEntry: ref<JournalQuestMapPinBase>, jumpTo: Vector3) -> Void {
  let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_codexLinksContainer), n"linkMappin");
  let controller: ref<QuestMappinLinkController> = widget.GetController() as QuestMappinLinkController;
  controller.Setup(mappinEntry, jumpTo);
  // Added below
  if Equals(this.m_currentQuestData.GetType(), gameJournalQuestType.VehicleQuest) {
    controller.flib_SetupVehicleIcon(this.m_currentQuestData.GetId());
  };
}

@addMethod(QuestMappinLinkController)
public func flib_SetupVehicleIcon(questId: String) -> Void {
  let iconRecord: ref<UIIcon_Record> = flib_GetVehicleIcon(questId);
  if IsDefined(iconRecord) {
    inkImageRef.SetAtlasResource(this.m_linkImage, iconRecord.AtlasResourcePath());
    inkImageRef.SetTexturePart(this.m_linkImage, iconRecord.AtlasPartName());
  }
}

/// Helper method to get the vehicle journal icon from a given QuestId string.
public static func flib_GetVehicleIcon(questId: String) -> ref<UIIcon_Record> {
  let iconID: TweakDBID;
  switch (questId) {
    // --- Bikes:
    // Kusanagi CT-3X
    case "yaiba_kusanagi":
      iconID = t"UIJournalIcons.v_sportbike1_yaiba_kusanagi_player";
      break;
    // Nazare Racer
    case "arch": 
      iconID = t"UIJournalIcons.v_sportbike2_arch_player";
      break;
    // Apollo
    case "brennan_apollo": 
      iconID = t"UIJournalIcons.v_sportbike3_brennan_apollo_player";
      break;

    // --- Sport 1:
    // Outlaw GTS
    case "herrera_outlaw": 
      iconID = t"UIJournalIcons.v_sport1_herrera_outlaw_player";
      break;
    // Rayfield Aerondight "Guinevere"
    case "rayfield_aerondight": 
      iconID = t"UIJournalIcons.v_sport1_rayfield_aerondight_player";
      break;
    // Rayfield Caliburn
    case "rayfield_caliburn": 
      iconID = t"UIJournalIcons.v_sport1_rayfield_caliburn_player";
      break;
    // Turbo-R 740
    case "quadra_turbo": 
      iconID = t"UIJournalIcons.v_sport1_quadra_turbo_player";
      break;

    // --- Sport 2:
    // Shion MZ2
    case "mizutani_shion": 
      iconID = t"UIJournalIcons.v_sport2_mizutani_shion_player";
      break;
    // Shion "Coyote"
    case "mizutani_shion_nomad": 
      iconID = t"UIJournalIcons.v_sport2_mizutani_shion_nomad_player";
      break;
    // Type-66 640 TS
    case "quadra_type66": 
      iconID = t"UIJournalIcons.v_sport2_quadra_type66_player";
      break;
    // Quadra Type-66 Avenger
    case "quadra_type66_avenger": 
      iconID = t"UIJournalIcons.v_sport2_quadra_type66_avenger_player";
      break;
    // Quadra Type-66 "Javelina"
    case "quadra_type66_nomad": 
      iconID = t"UIJournalIcons.v_sport2_quadra_type66_nomad_player";
      break;
    // Quadra Type-66 "Cthulhu"
    case "quadra_type66_nomad_ncu": 
      iconID = t"UIJournalIcons.v_sport2_quadra_type66_ncu_player";
      break;
    // Alvarado V4F 570 Delegate
    case "villefort_alvarado": 
      iconID = t"UIJournalIcons.v_sport2_villefort_alvarado_player";
      break;

    // --- Standard 2:
    // Quartz EC-L r275
    case "archer_quartz":
      iconID = t"UIJournalIcons.v_standard2_archer_quartz_player";
      break;
    // Thrax 388 Jefferson
    case "chevalier_thrax":
      iconID = t"UIJournalIcons.v_standard2_chevalier_thrax_player";
      break;
    // MaiMai P126
    case "makigai_maimai":
      iconID = t"UIJournalIcons.v_standard2_makigai_maimai_player";
      break;
    // Thorton Colby C240t
    case "thorton_colby":
      iconID = t"UIJournalIcons.v_standard2_thorton_colby_player";
      break;
    // Galena G240
    case "thorton_galena":
      iconID = t"UIJournalIcons.v_standard2_thorton_galena_player";
      break;
    // Thorton Galena "Gecko"
    case "thorton_galena_nomad":
      iconID = t"UIJournalIcons.v_standard2_thorton_galena_nomad_player";
      break;
    // Cortes V5000 Valor
    case "villefort_cortes":
      iconID = t"UIJournalIcons.v_standard2_villefort_cortes_player";
      break;

    // --- Standard 2.5:
    // Supron FS3
    case "mahir_supron":
      iconID = t"UIJournalIcons.v_standard25_mahir_supron_player";
      break;
    // Thorton Colby "Little Mule"
    case "thorton_colby_nomad":
      iconID = t"UIJournalIcons.v_standard25_thorton_colby_nomad_player";
      break;
    // Thorton Colby CX410 Butte
    case "thorton_colby_pickup":
      iconID = t"UIJournalIcons.v_standard25_thorton_colby_pickup_player";
      break;
    // Columbus V340-F Freight
    case "villefort_columbus":
      iconID = t"UIJournalIcons.v_standard25_villefort_columbus_player";
      break;

    // --- Standard 3:
    // Emperor 620 Ragnar
    case "chevalier_emperor":
      iconID = t"UIJournalIcons.v_standard3_chevalier_emperor_player";
      break;
    // Mackinaw MTL1
    case "thorton_mackinaw":
      iconID = t"UIJournalIcons.v_standard3_thorton_mackinaw_player";
      break;

    default:
      return null;
  };

  return TweakDBInterface.GetUIIconRecord(iconID);
}
