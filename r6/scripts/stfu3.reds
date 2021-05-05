@replaceMethod(EquipmentSystem)
public final const func GetPlayerData(owner: ref<GameObject>) -> ref<EquipmentSystemPlayerData> {
  let i: Int32;
  // LogAssert(owner != null, "[EquipmentSystem::GetPlayerData] Owner not defined!");
  i = 0;
  while i < ArraySize(this.m_ownerData) {
    if this.m_ownerData[i].GetOwner() == owner {
      return this.m_ownerData[i];
    };
    i += 1;
  };
  // DO NOT REMOVE THIS - BREAKS CET INITIALIZATION
  LogAssert(false, "[EquipmentSystem::GetPlayerData] Unable to find player data!");
  return null;
}

// DO NOT REPLACE THIS - BREAKS CET INITIALIZATION
// @replaceGlobal()
// public static func LogAssert(condition: Bool, text: String) -> Void {
//   if !condition {
//     // LogChannel(n"ASSERT", text);
//   };
// }

// Not sure about this one as it uses ItemID.undefined() which is not supported by compiler
@replaceMethod(EquipmentSystemPlayerData)
private final func UnequipItem(equipAreaIndex: Int32, opt slotIndex: Int32) -> Void {
  let transactionSystem: ref<TransactionSystem>;
  let placementSlot: TweakDBID;
  let unequipNotifyEvent: ref<AudioNotifyItemUnequippedEvent>;
  let paperdollEquipData: SPaperdollEquipData;
  let audioEventFoley: ref<AudioEvent>;
  let currentItem: ItemID;
  let i: Int32;
  let audioEventFootwear: ref<AudioEvent>;
  let equipArea: SEquipArea;
  let itemRecord: ref<Item_Record>;
  let currentItemRecord: ref<Item_Record>;
  let packages: array<wref<GameplayLogicPackage_Record>>;
  let itemData: ref<gameItemData>;
  let stubItemId: ItemID = new ItemID();
  // Log(" UnequipItem " + IntToString(equipAreaIndex) + " " + IntToString(slotIndex));
  currentItem = this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID;
  equipArea = this.GetEquipAreaFromItemID(currentItem);
  currentItemRecord = RPGManager.GetItemRecord(currentItem);
  transactionSystem = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
  itemData = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, currentItem);
  if IsDefined(itemData) && itemData.HasTag(n"UnequipBlocked") {
    return ;
  };
  if this.IsItemOfCategory(currentItem, gamedataItemCategory.Weapon) && equipArea.activeIndex == slotIndex {
    if currentItem != this.GetActiveHeavyWeapon() {
      this.CreateUnequipWeaponManipulationRequest();
    };
    placementSlot = this.GetPlacementSlot(equipAreaIndex, slotIndex);
    // this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID = ItemID.undefined();
    this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID = stubItemId;
  } else {
    if (this.IsItemOfCategory(currentItem, gamedataItemCategory.Gadget) || Equals(RPGManager.GetItemType(currentItem), gamedataItemType.Cyb_Launcher)) && equipArea.activeIndex == slotIndex {
      this.CreateUnequipGadgetWeaponManipulationRequest();
      this.AssignNextValidItemToHotkey(this.GetItemIDFromHotkey(EHotkey.RB));
    } else {
      if this.IsItemOfCategory(currentItem, gamedataItemCategory.Consumable) && equipArea.activeIndex == slotIndex {
        this.CreateUnequipConsumableWeaponManipulationRequest();
        this.AssignNextValidItemToHotkey(this.GetItemIDFromHotkey(EHotkey.DPAD_UP));
      } else {
        if ItemID.IsValid(currentItem) {
          placementSlot = this.GetPlacementSlot(equipAreaIndex, slotIndex);
          this.OnUnequipProcessVisualTags(currentItem, true);
          if transactionSystem.HasItemInSlot(this.m_owner, placementSlot, currentItem) {
            unequipNotifyEvent = new AudioNotifyItemUnequippedEvent();
            unequipNotifyEvent.itemName = currentItemRecord.EntityName();
            this.m_owner.QueueEvent(unequipNotifyEvent);
            transactionSystem.RemoveItemFromSlot(this.m_owner, placementSlot);
          };
          // this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID = ItemID.undefined();
          this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID = stubItemId;
          this.RemoveEquipGLPs(currentItem);
          audioEventFoley = new AudioEvent();
          audioEventFoley.eventName = n"unequipItem";
          audioEventFoley.nameData = currentItemRecord.AppearanceName();
          this.m_owner.QueueEvent(audioEventFoley);
          if Equals(currentItemRecord.ItemType().Type(), gamedataItemType.Clo_Feet) {
            audioEventFootwear = new AudioEvent();
            audioEventFootwear.eventName = n"equipFootwear";
            audioEventFootwear.nameData = n"";
            this.m_owner.QueueEvent(audioEventFootwear);
          };
          if this.IsItemOfCategory(currentItem, gamedataItemCategory.Cyberware) && this.IsItemConstructed(currentItem) {
            this.ManageCyberwareFragments(currentItem);
          };
        };
      };
    };
  };
  if ItemID.IsValid(currentItem) && Equals(RPGManager.GetItemRecord(currentItem).ItemType().Type(), gamedataItemType.Cyb_StrongArms) {
    this.HandleStrongArmsUnequip();
  };
  paperdollEquipData.equipArea = this.m_equipment.equipAreas[equipAreaIndex];
  paperdollEquipData.equipped = false;
  paperdollEquipData.placementSlot = placementSlot;
  paperdollEquipData.slotIndex = slotIndex;
  this.UpdateWeaponWheel();
  this.UpdateQuickWheel();
  this.UpdateEquipmentUIBB(paperdollEquipData);
  transactionSystem.OnItemRemovedFromEquipmentSlot(this.m_owner, currentItem);
}

@replaceMethod(EquipmentSystem)
private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
  let data: ref<EquipmentSystemPlayerData>;
  // LogAssert(this.GetPlayerData(request.owner) == null, "[EquipmentSystem::OnPlayerAttach] Player already attached!");
  if !IsDefined(this.GetPlayerData(request.owner)) {
    data = new EquipmentSystemPlayerData();
    data.SetOwner(request.owner as ScriptedPuppet);
    ArrayPush(this.m_ownerData, data);
    data.OnInitialize();
  } else {
    data = this.GetPlayerData(request.owner);
  };
  data.OnAttach();
  this.Debug_SetupEquipmentSystemOverlay(request.owner);
}

@replaceMethod(EquipmentSystem)
private final func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
  let i: Int32 = 0;
  while i < ArraySize(this.m_ownerData) {
    if this.m_ownerData[i].GetOwner() == request.owner {
      this.m_ownerData[i].OnDetach();
      ArrayErase(this.m_ownerData, i);
      return ;
    };
    i += 1;
  };
  // LogAssert(false, "[EquipmentSystem::OnPlayerDetach] Can\'t find player!");
}

@replaceMethod(PlayerDevelopmentSystem)
private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
  let build: gamedataBuildType;
  let data: ref<PlayerDevelopmentData>;
  let updatePDS: ref<UpdatePlayerDevelopment>;
  // LogAssert(this.GetDevelopmentData(request.owner) == null, "[PlayerDevelopmentSystem::OnPlayerAttach] Player already attached!");
  if !IsDefined(this.GetDevelopmentData(request.owner)) {
    data = new PlayerDevelopmentData();
    data.SetOwner(request.owner);
    data.SetLifePath(GameInstance.GetCharacterCustomizationSystem(request.owner.GetGame()).GetState().GetLifePath());
    updatePDS = new UpdatePlayerDevelopment();
    updatePDS.Set(request.owner);
    GameInstance.GetScriptableSystemsContainer(request.owner.GetGame()).Get(n"PlayerDevelopmentSystem").QueueRequest(updatePDS);
    ArrayPush(this.m_playerData, data);
    data.OnNewGame();
  } else {
    data = this.GetDevelopmentData(request.owner);
  };
  data.OnAttach();
}

@replaceMethod(PlayerDevelopmentSystem)
private final func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
  let i: Int32 = 0;
  while i < ArraySize(this.m_playerData) {
    if this.m_playerData[i].GetOwner() == request.owner {
      this.m_playerData[i].OnDetach();
      return ;
    };
    i += 1;
  };
  i = 0;
  while i < ArraySize(this.m_ownerData) {
    if this.m_ownerData[i].GetOwner() == request.owner {
      this.m_ownerData[i].OnDetach();
      return ;
    };
    i += 1;
  };
  // LogAssert(false, "[PlayerDevelopmentSystem::OnPlayerDetach] Can\'t find player!");
}

@replaceMethod(PlayerDevelopmentSystem)
private final const func GetDevelopmentData(owner: ref<GameObject>) -> ref<PlayerDevelopmentData> {
  let i: Int32;
  // LogAssert(owner != null, "[PlayerDevelopmentSystem::GetDevelopmentData] Owner not defined!");
  i = 0;
  while i < ArraySize(this.m_playerData) {
    if this.m_playerData[i].GetOwner() == owner {
      return this.m_playerData[i];
    };
    i += 1;
  };
  i = 0;
  while i < ArraySize(this.m_ownerData) {
    if this.m_ownerData[i].GetOwner() == owner {
      return this.m_ownerData[i];
    };
    i += 1;
  };
  // LogAssert(false, "[PlayerDevelopmentSystem::GetDevelopmentData] Unable to find player data!");
  return null;
}

@replaceMethod(EquipmentSystemPlayerData)
private final func UnequipItem(itemID: ItemID) -> Void {
  let audioEventFoley: ref<AudioEvent>;
  let equipAreaIndex: Int32;
  // Log(" UnequipItem " + TDBID.ToStringDEBUG(ItemID.GetTDBID(itemID)));
  if this.IsEquipped(itemID) {
    equipAreaIndex = this.GetEquipAreaIndex(EquipmentSystem.GetEquipAreaType(itemID));
    this.UnequipItem(equipAreaIndex, this.GetSlotIndex(itemID));
    audioEventFoley = new AudioEvent();
    audioEventFoley.eventName = n"unequipItem";
    audioEventFoley.nameData = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID)).AppearanceName();
    this.m_owner.QueueEvent(audioEventFoley);
  };
}

@replaceMethod(EquipmentSystemPlayerData)
public final const func GetSlotIndex(itemID: ItemID) -> Int32 {
  let equipAreaType: gamedataEquipmentArea;
  let equipSlots: array<SEquipSlot>;
  let i: Int32;
  let itemRecord: ref<Item_Record>;
  let j: Int32;
  if ItemID.IsValid(itemID) {
    equipAreaType = EquipmentSystem.GetEquipAreaType(itemID);
    i = this.GetEquipAreaIndex(equipAreaType);
    if i >= 0 {
      equipSlots = this.m_equipment.equipAreas[i].equipSlots;
      j = 0;
      while j < ArraySize(equipSlots) {
        if equipSlots[j].itemID == itemID {
          // Log(" GetSlotIndex " + TDBID.ToStringDEBUG(ItemID.GetTDBID(itemID)) + " result " + j);
          return j;
        };
        j += 1;
      };
    };
  };
  // Log(" GetSlotIndex " + TDBID.ToStringDEBUG(ItemID.GetTDBID(itemID)) + " result not found");
  return -1;
}

@replaceMethod(EquipmentSystemPlayerData)
public final const func GetSlotIndex(itemID: ItemID, equipAreaType: gamedataEquipmentArea) -> Int32 {
  let j: Int32;
  let itemRecord: ref<Item_Record>;
  let equipSlots: array<SEquipSlot>;
  let i: Int32;
  if ItemID.IsValid(itemID) {
    i = this.GetEquipAreaIndex(equipAreaType);
    if i >= 0 {
      equipSlots = this.m_equipment.equipAreas[i].equipSlots;
      j = 0;
      while j < ArraySize(equipSlots) {
        if equipSlots[j].itemID == itemID {
          // Log(" GetSlotIndex " + TDBID.ToStringDEBUG(ItemID.GetTDBID(itemID)) + " result " + j);
          return j;
        };
        j += 1;
      };
    };
  };
  // Log(" GetSlotIndex " + TDBID.ToStringDEBUG(ItemID.GetTDBID(itemID)) + " result not found");
  return -1;
}

@replaceMethod(EquipmentSystemPlayerData)
public final const func IsEquipped(item: ItemID) -> Bool {
  // Log(" IsEquipped " + TDBID.ToStringDEBUG(ItemID.GetTDBID(item)));
  return this.GetSlotIndex(item) >= 0;
}

@replaceMethod(EquipmentSystemPlayerData)
public final const func IsEquipped(item: ItemID, equipmentArea: gamedataEquipmentArea) -> Bool {
  // Log(" IsEquipped " + TDBID.ToStringDEBUG(ItemID.GetTDBID(item)));
  return this.GetSlotIndex(item, equipmentArea) >= 0;
}

@replaceMethod(WeaponPositionComponent)
private final func OnGameAttach() -> Void {
  // Log("WeaponPositionComponent: Attach");
  this.m_playerPuppet = this.GetOwner() as PlayerPuppet;
  this.GetOwner().RegisterInputListener(this);
  this.ResetData();
}

@replaceMethod(JournalManager)
protected final cb func OnQuestEntryTracked(entry: wref<JournalEntry>) -> Bool {
  // if entry == null {
  //   Log("No entry is being tracked");
  // } else {
  //   if IsDefined(entry as JournalQuest) {
  //     Log("Quest entry is being tracked");
  //   } else {
  //     if IsDefined(entry as JournalQuestObjective) {
  //       Log("Quest objective entry is being tracked");
  //     };
  //   };
  // };
}

@replaceMethod(DamageSystem)
public final func ProcessEffectiveRange(hitEvent: ref<gameHitEvent>) -> Void {
  let attackData: ref<AttackData> = hitEvent.attackData;
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(hitEvent.attackData.GetSource().GetGame());
  let attackDistance: Float = Vector4.Length(attackData.GetAttackPosition() - hitEvent.hitPosition);
  let itemRecord: ref<WeaponItem_Record>;
  let attackSource: ref<ItemObject>;
  let percentOfRange: Float;
  let effectiveRange: Float;
  let attackWeapon: ref<WeaponObject>;
  let grenadeRecord: ref<Grenade_Record>;
  let damageMod: Float;
  if AttackData.IsExplosion(attackData.GetAttackType()) {
    attackSource = attackData.GetSource() as ItemObject;
    if IsDefined(attackSource) {
      grenadeRecord = TweakDBInterface.GetGrenadeRecord(ItemID.GetTDBID(attackSource.GetItemID()));
    };
    if IsDefined(grenadeRecord) {
      effectiveRange = grenadeRecord.AttackRadius();
    } else {
      effectiveRange = attackData.GetAttackDefinition().GetRecord().Range();
    };
    percentOfRange = ClampF(attackDistance / effectiveRange, 0.00, 1.00);
    damageMod = GameInstance.GetStatsDataSystem(hitEvent.target.GetGame()).GetValueFromCurve(n"explosions", percentOfRange, n"distance_to_damage_reduction");
    hitEvent.attackComputed.MultAttackValue(damageMod);
    return ;
  };
  attackWeapon = attackData.GetWeapon();
  if !IsDefined(attackWeapon) {
    // LogError("[DamageSystem] Attack with no weapon!");
    return ;
  };
  damageMod = DamageSystem.GetEffectiveRangeModifierForWeapon(attackData, hitEvent.hitPosition);
  if damageMod != 1.00 {
    hitEvent.attackComputed.MultAttackValue(damageMod);
  };
}


// ------ GLOBALS

@replaceGlobal()
public static func LogDM(str: String) -> Void {
  // LogChannel(n"DevelopmentManager", str);
}

@replaceGlobal()
public static func LogAI(str: String) -> Void {
  // LogChannel(n"AI", str);
}

@replaceGlobal()
public static func LogDamage(str: String) -> Void {
  // LogChannel(n"Damage", str);
}

@replaceGlobal()
public static func LogPuppet(str: String) -> Void {
  // LogChannel(n"Puppet", str);
}

@replaceGlobal()
public static func LogUI(str: String) -> Void {
  // LogChannel(n"UI", str);
}

@replaceGlobal()
public static func LogStrike(str: String) -> Void {
  // LogChannel(n"Strike", str);
}

@replaceGlobal()
public static func LogStats(str: String) -> Void {
  // LogChannel(n"Stats", str);
}

@replaceGlobal()
public static func LogStatPools(str: String) -> Void {
  // LogChannel(n"StatPools", str);
}

@replaceGlobal()
public static func LogItems(str: String) -> Void {
  // LogChannel(n"Items", str);
}

@replaceGlobal()
public static func LogItemManager(str: String) -> Void {
  // LogChannel(n"ItemManager", str);
}

@replaceGlobal()
public static func LogScanner(str: String) -> Void {
  // LogChannel(n"Scanner", str);
}

@replaceGlobal()
public static func LogAICover(str: String) -> Void {
  // LogChannel(n"AICover", str);
}

@replaceGlobal()
public static func LogVehicles(str: String) -> Void {
  // LogChannel(n"Vehicles", str);
}

@replaceGlobal()
public static func LogAIError(str: String) -> Void {
  // LogChannelError(n"AI", str);
  ReportFailure(str);
}

@replaceGlobal()
public static func LogUIError(str: String) -> Void {
  // LogChannelError(n"UI", str);
}

@replaceGlobal()
public static func LogAICoverWarning(str: String) -> Void {
  // LogChannelError(n"AICover", str);
}

@replaceGlobal()
public static func SetFactValue(game: GameInstance, factName: CName, factCount: Int32) -> Bool {
  if !GameInstance.IsValid(game) {
    // Log("SetFactValue / Invalid Game Instance");
    return false;
  };
  if !IsNameValid(factName) {
    // Log(NameToString(factName) + " is not valid, fact not added");
    return false;
  };
  GameInstance.GetQuestsSystem(game).SetFact(factName, factCount);
  return true;
}
