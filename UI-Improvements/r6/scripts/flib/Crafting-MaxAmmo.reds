/// Calculates the number of ammo cases to craft for max ammo of a given type
/// Now with no magic numbers!
@addMethod(CraftingSystem)
protected func flibGetAmmoCraftingMaximum(itemRecord: wref<Item_Record>) -> Int32 {
  let trans: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
  let player: ref<GameObject> = this.m_playerCraftBook.m_owner;
  let itemRecipe: ref<RecipeData> = this.GetRecipeData(itemRecord);  
  let reqStatModifiers: array<wref<StatModifier_Record>>;
  let ammoStatModifiers: array<wref<StatModifier_Record>>;
  let target: StatsObjectID; // Unused but required by CalculateStatModifiers()
  let maxAmmo: Int32 = 0;
  // Each ammo ItemRecord has a StatModifier that contains the ammo limit relative to 999999
  itemRecord.StatModifiers(ammoStatModifiers);
  // Items.RequiredItemStats contains a stat modifier with the value 999999
  // I can't find any records that reference it, so I assume it's referenced in native code somewhere
  TweakDBInterface.GetStatModifierGroupRecord(t"Items.RequiredItemStats").StatModifiers(reqStatModifiers);
  // Now kiss
  for statMod in reqStatModifiers {
    ArrayPush(ammoStatModifiers, statMod);
  }
  // This effectively just adds all the StatMod quantities together, but maintains existing scripting logic
  maxAmmo = Cast(RPGManager.CalculateStatModifiers(ammoStatModifiers, player.GetGame(), player, target));
  // Subtract the qty the player already has
  maxAmmo -= trans.GetItemQuantity(player, ItemID.FromTDBID(itemRecord.GetID()));
  // Return the number of ammo cases needed (math is integer ceil())
  return Max(0, (maxAmmo + itemRecipe.amount - 1) / itemRecipe.amount);
}

/// Overloaded method that takes a gameItemData reference instead of an Item_Record
/// To support the overloaded versions of CanItemBeCrafted
@addMethod(CraftingSystem)
protected func flibGetAmmoCraftingMaximum(itemData: wref<gameItemData>) -> Int32 {
  return this.flibGetAmmoCraftingMaximum(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.GetID())));
}

/// Added ammo max check
@wrapMethod(CraftingSystem)
public final const func GetMaxCraftingAmount(itemData: wref<gameItemData>) -> Int32 {
  let result: Int32 = wrappedMethod(itemData);

  if (itemData.HasTag(n"Ammo")) {
    return Min(result, this.flibGetAmmoCraftingMaximum(itemData));
  }
  return result;
}

/// Added ammo max check and restructured as a switch block
@replaceMethod(CraftingSystem)
public final const func CanItemBeCrafted(itemData: wref<gameItemData>) -> Bool {
  let quality: gamedataQuality;
  let result: Bool;
  let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemData);
  switch itemData.GetItemType() {
    case gamedataItemType.Con_Ammo:
      result = this.HasIngredients(requiredIngredients) && this.flibGetAmmoCraftingMaximum(itemData) > 0;
      break;
    case gamedataItemType.Prt_Program:
      result = this.HasIngredients(requiredIngredients);
      break;
    default:
      result = this.HasIngredients(requiredIngredients) && this.CanCraftGivenQuality(itemData, quality);
      break;
  }
  return result;
}

/// Added ammo max check and restructured as a switch block
@replaceMethod(CraftingSystem)
public final const func CanItemBeCrafted(itemRecord: wref<Item_Record>) -> Bool {
  let quality: gamedataQuality;
  let result: Bool;
  let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemRecord);
  switch itemRecord.ItemType().Type() {
    case gamedataItemType.Con_Ammo:
      result = this.HasIngredients(requiredIngredients) && this.flibGetAmmoCraftingMaximum(itemRecord) > 0;
      break;
    case gamedataItemType.Prt_Program:
      result = this.HasIngredients(requiredIngredients);
      break;
    default:
      result = this.HasIngredients(requiredIngredients) && this.CanCraftGivenQuality(itemRecord, quality);
      break;
  }
  return result;
}
