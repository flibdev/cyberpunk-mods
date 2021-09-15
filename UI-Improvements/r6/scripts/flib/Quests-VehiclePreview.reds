/** @file Quests - Vehicle Previews

Quests have a type enum, vehicle quests can be filtered by `gameJournalQuestType.VehicleQuest`

DJ_Kovrik and I couldn't find any references between the quest and the journal messages from the
fixer with the car image, so the codex references are currently hardcoded by questID
*/

@wrapMethod(QuestDetailsPanelController)
private final func PopulateCodexLinks(trackedObjective: ref<JournalQuestObjective>) -> Void {
  wrappedMethod(trackedObjective);

  // Iterate up the journal hierarchy until we find the parent quest (or nothing?)
  let parentEntry: ref<JournalEntry> = trackedObjective;
  while (IsDefined(parentEntry) && !parentEntry.IsA(n"gameJournalQuest")) {
    parentEntry = this.m_journalManager.GetParentEntry(parentEntry);
  }

  if IsDefined(parentEntry) {
    let parentQuest = parentEntry as JournalQuest;
    if IsDefined(parentQuest) && Equals(parentQuest.GetType(), gameJournalQuestType.VehicleQuest) {
      let ent = this.flibGetVehicleCodexEntry(parentQuest.GetId());
      if IsDefined(ent) {
        this.SpawnCodexLink(ent);
      }
    }
  }
}

@addMethod(QuestDetailsPanelController)
private func flibGetVehicleCodexEntry(questId: String) -> ref<JournalEntry> {
  let codexPath: String = "codex/glossary/vehicles/";
  switch (questId) {
    // --- Bikes:
    // Kusanagi CT-3X
    case "yaiba_kusanagi":
      codexPath += "ow_v_sportbike1_yaiba_kusanagi_player";
      break;
    // ARCH Nazare Racer
    case "arch": 
      codexPath += "ow_v_sportbike2_arch_player";
      break;
    // Apollo
    case "brennan_apollo": 
      codexPath += "ow_v_sportbike3_brennan_apollo_player";
      break;
    // --- Sport 1:
    // Outlaw GTS
    case "herrera_outlaw": 
      codexPath += "ow_v_sport1_herrera_outlaw_player";
      break;
    // Turbo-R 740
    case "quadra_turbo": 
      codexPath += "ow_v_sport1_quadra_turbo_player";
      break;
    // Rayfield Aerondight "Guinevere"
    case "rayfield_aerondight": 
      codexPath += "ow_v_sport1_rayfield_aerondight_player";
      break;
    // Rayfield Caliburn
    case "rayfield_caliburn": 
      codexPath += "ow_v_sport1_rayfield_caliburn_player";
      break;
    // --- Sport 2:
    // Shion MZ2
    case "mizutani_shion": 
      codexPath += "ow_v_sport2_mizutani_shion_player";
      break;
    // Shion "Coyote"
    case "mizutani_shion_nomad": 
      codexPath += "ow_v_sport2_mizutani_shion_nomad_player";
      break;
    // Type-66 640 TS
    case "quadra_type66": 
      codexPath += "ow_v_sport2_quadra_type66_player";
      break;
    // Quadra Type-66 Avenger
    case "quadra_type66_avenger": 
      codexPath += "ow_v_sport2_quadra_type66_avenger_player";
      break;
    // Quadra Type-66 "Javelina"
    case "quadra_type66_nomad": 
      codexPath += "ow_v_sport2_quadra_type66_nomad_player";
      break;
    // Quadra Type-66 "Cthulhu"
    case "quadra_type66_nomad_ncu": 
      codexPath += "quadra_type_66_nc_deathrace";
      break;
    // Alvarado V4F 570 Delegate
    case "villefort_alvarado": 
      codexPath += "ow_v_sport2_villefort_alvarado_player";
      break;
    // --- Standard 2:
    // Quartz EC-L r275
    case "archer_quartz":
      codexPath += "ow_v_standard2_archer_quartz_player";
      break;
    // Thrax 388 Jefferson
    case "chevalier_thrax":
      codexPath += "ow_v_standard2_chevalier_thrax_player";
      break;
    // MaiMai P126
    case "makigai_maimai":
      codexPath += "ow_v_standard2_makigai_maimai_player";
      break;
    // Thorton Colby C240t
    case "thorton_colby":
      codexPath += "ow_v_standard2_thorton_colby_player";
      break;
    // Galena G240
    case "thorton_galena":
      codexPath += "ow_v_standard2_thorton_galena_player";
      break;
    // Thorton Galena "Gecko"
    case "thorton_galena_nomad":
      codexPath += "ow_v_standard2_thorton_galena_nomad_player";
      break;
    // Cortes V5000 Valor
    case "villefort_cortes":
      codexPath += "ow_v_standard2_villefort_cortes_player";
      break;
    // --- Standard 2.5:
    // Supron FS3
    case "mahir_supron":
      codexPath += "ow_v_standard25_mahir_supron_player";
      break;
    // Thorton Colby "Little Mule"
    case "thorton_colby_nomad":
      codexPath += "ow_v_standard25_thorton_colby_nomad_player";
      break;
    // Thorton Colby CX410 Butte
    case "thorton_colby_pickup":
      codexPath += "ow_v_standard25_thorton_colby_pickup_player";
      break;
    // Columbus V340-F Freight
    case "villefort_columbus":
      codexPath += "ow_v_standard25_villefort_columbus_player";
      break;
    // --- Standard 3:
    // Emperor 620 Ragnar
    case "chevalier_emperor":
      codexPath += "ow_v_standard3_chevalier_emperor_player";
      break;
    // Mackinaw MTL1
    case "thorton_mackinaw":
      codexPath += "ow_v_standard3_thorton_mackinaw_player";
      break;
    default:
      return null;
  };

  return this.m_journalManager.GetEntryByString(codexPath, "gameJournalCodexEntry");
}
