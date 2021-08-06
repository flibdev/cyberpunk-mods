/// The original method was missing the `gamedataItemType.Wea_LightMachineGun`
@replaceMethod(RPGManager)
public final static func GetModsSlotIDs(type: gamedataItemType) -> array<TweakDBID> {
  let arr: array<TweakDBID>;
  switch type {
    case gamedataItemType.Clo_Face:
      ArrayPush(arr, t"AttachmentSlots.FaceFabricEnhancer1");
      ArrayPush(arr, t"AttachmentSlots.FaceFabricEnhancer2");
      ArrayPush(arr, t"AttachmentSlots.FaceFabricEnhancer3");
      ArrayPush(arr, t"AttachmentSlots.FaceFabricEnhancer4");
      break;
    case gamedataItemType.Clo_Feet:
      ArrayPush(arr, t"AttachmentSlots.FootFabricEnhancer1");
      ArrayPush(arr, t"AttachmentSlots.FootFabricEnhancer2");
      ArrayPush(arr, t"AttachmentSlots.FootFabricEnhancer3");
      ArrayPush(arr, t"AttachmentSlots.FootFabricEnhancer4");
      break;
    case gamedataItemType.Clo_Head:
      ArrayPush(arr, t"AttachmentSlots.HeadFabricEnhancer1");
      ArrayPush(arr, t"AttachmentSlots.HeadFabricEnhancer2");
      ArrayPush(arr, t"AttachmentSlots.HeadFabricEnhancer3");
      ArrayPush(arr, t"AttachmentSlots.HeadFabricEnhancer4");
      break;
    case gamedataItemType.Clo_InnerChest:
      ArrayPush(arr, t"AttachmentSlots.InnerChestFabricEnhancer1");
      ArrayPush(arr, t"AttachmentSlots.InnerChestFabricEnhancer2");
      ArrayPush(arr, t"AttachmentSlots.InnerChestFabricEnhancer3");
      ArrayPush(arr, t"AttachmentSlots.InnerChestFabricEnhancer4");
      break;
    case gamedataItemType.Clo_Legs:
      ArrayPush(arr, t"AttachmentSlots.LegsFabricEnhancer1");
      ArrayPush(arr, t"AttachmentSlots.LegsFabricEnhancer2");
      ArrayPush(arr, t"AttachmentSlots.LegsFabricEnhancer3");
      ArrayPush(arr, t"AttachmentSlots.LegsFabricEnhancer4");
      break;
    case gamedataItemType.Clo_OuterChest:
      ArrayPush(arr, t"AttachmentSlots.OuterChestFabricEnhancer1");
      ArrayPush(arr, t"AttachmentSlots.OuterChestFabricEnhancer2");
      ArrayPush(arr, t"AttachmentSlots.OuterChestFabricEnhancer3");
      ArrayPush(arr, t"AttachmentSlots.OuterChestFabricEnhancer4");
      break;
    case gamedataItemType.Wea_AssaultRifle:
    case gamedataItemType.Wea_Handgun:
    case gamedataItemType.Wea_LightMachineGun:
    case gamedataItemType.Wea_PrecisionRifle:
    case gamedataItemType.Wea_Revolver:
    case gamedataItemType.Wea_Rifle:
    case gamedataItemType.Wea_Shotgun:
    case gamedataItemType.Wea_ShotgunDual:
    case gamedataItemType.Wea_SniperRifle:
    case gamedataItemType.Wea_SubmachineGun:
      ArrayPush(arr, t"AttachmentSlots.GenericWeaponMod1");
      ArrayPush(arr, t"AttachmentSlots.GenericWeaponMod2");
      ArrayPush(arr, t"AttachmentSlots.GenericWeaponMod3");
      ArrayPush(arr, t"AttachmentSlots.GenericWeaponMod4");
      break;
    case gamedataItemType.Wea_Hammer:
    case gamedataItemType.Wea_Katana:
    case gamedataItemType.Wea_Knife:
    case gamedataItemType.Wea_LongBlade:
    case gamedataItemType.Wea_OneHandedClub:
    case gamedataItemType.Wea_ShortBlade:
    case gamedataItemType.Wea_TwoHandedClub:
      ArrayPush(arr, t"AttachmentSlots.MeleeWeaponMod1");
      ArrayPush(arr, t"AttachmentSlots.MeleeWeaponMod2");
      ArrayPush(arr, t"AttachmentSlots.MeleeWeaponMod3");
      break;
  };
  return arr;
}
