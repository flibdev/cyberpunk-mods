  
@replaceMethod(EquipmentSystemPlayerData)
public final const func GetSlotIndex(itemID: ItemID) -> Int32 {
  let i: Int32;
  let j: Int32;
  let itemRecord: ref<Item_Record>;
  let equipAreaType: gamedataEquipmentArea;
  let equipSlots: array<SEquipSlot>;
  if ItemID.IsValid(itemID) {
    equipAreaType = EquipmentSystem.GetEquipAreaType(itemID);
    i = this.GetEquipAreaIndex(equipAreaType);
    if i >= 0 {
      equipSlots = this.m_equipment.equipAreas[i].equipSlots;
      j = 0;
      while j < ArraySize(equipSlots) {
        if equipSlots[j].itemID == itemID {
          //Log(" GetSlotIndex " + TDBID.ToStringDEBUG(ItemID.GetTDBID(itemID)) + " result " + j);
          return j;
        };
        j += 1;
      };
    };
  };
  //Log(" GetSlotIndex " + TDBID.ToStringDEBUG(ItemID.GetTDBID(itemID)) + " result not found");
  return -1;
}

@replaceMethod(EquipmentSystemPlayerData)
public final const func GetSlotIndex(itemID: ItemID, equipAreaType: gamedataEquipmentArea) -> Int32 {
  let i: Int32;
  let j: Int32;
  let itemRecord: ref<Item_Record>;
  let equipSlots: array<SEquipSlot>;
  if ItemID.IsValid(itemID) {
    i = this.GetEquipAreaIndex(equipAreaType);
    if i >= 0 {
      equipSlots = this.m_equipment.equipAreas[i].equipSlots;
      j = 0;
      while j < ArraySize(equipSlots) {
        if equipSlots[j].itemID == itemID {
          //Log(" GetSlotIndex " + TDBID.ToStringDEBUG(ItemID.GetTDBID(itemID)) + " result " + j);
          return j;
        };
        j += 1;
      };
    };
  };
  //Log(" GetSlotIndex " + TDBID.ToStringDEBUG(ItemID.GetTDBID(itemID)) + " result not found");
  return -1;
}
  
@replaceMethod(EquipmentSystemPlayerData)
public final const func IsEquipped(item: ItemID) -> Bool {
  //Log(" IsEquipped " + TDBID.ToStringDEBUG(ItemID.GetTDBID(item)));
  return this.GetSlotIndex(item) >= 0;
}

@replaceMethod(EquipmentSystemPlayerData)
public final const func IsEquipped(item: ItemID, equipmentArea: gamedataEquipmentArea) -> Bool {
  //Log(" IsEquipped " + TDBID.ToStringDEBUG(ItemID.GetTDBID(item)));
  return this.GetSlotIndex(item, equipmentArea) >= 0;
}  
  
