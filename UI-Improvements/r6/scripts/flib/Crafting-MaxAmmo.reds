
@addMethod(CraftingSystem)
protected func GetAmmoCraftingMaximum(itemRecord: wref<Item_Record>) -> Int32 {
  let trans: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
  let player: ref<GameObject> = this.m_playerCraftBook.m_owner;
  let itemRecipe: ref<RecipeData> = this.GetRecipeData(itemRecord);  
  let invQty: Int32 = 0;
  let max: Int32 = 0;
  
  // TODO: Get max values programatically somehow?
  if itemRecord.TagsContains(n"HandgunAmmo") {
    invQty = trans.GetItemQuantityByTag(player, n"HandgunAmmo");
    max = 500;              
  }
  if itemRecord.TagsContains(n"RifleAmmo")   {
    invQty = trans.GetItemQuantityByTag(player, n"RifleAmmo");
    max = 700;
  }
  if itemRecord.TagsContains(n"ShotgunAmmo") {
    invQty = trans.GetItemQuantityByTag(player, n"ShotgunAmmo");
    max = 100;
  }
  if itemRecord.TagsContains(n"SniperAmmo")  {
    invQty = trans.GetItemQuantityByTag(player, n"SniperAmmo");
    max = 100;
  }

  return Max(0, (max - invQty + itemRecipe.amount - 1) / itemRecipe.amount);
}

/// Overloaded method that takes a gameItemData reference instead of an Item_Record
/// To support the overloaded versions of CanItemBeCrafted
@addMethod(CraftingSystem)
protected func GetAmmoCraftingMaximum(itemData: wref<gameItemData>) -> Int32 {
  return this.GetAmmoCraftingMaximum(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.GetID())));
}

@replaceMethod(CraftingSystem)
public final const func GetMaxCraftingAmount(itemData: wref<gameItemData>) -> Int32 {
  let currentQuantity: Int32;
  let currentResult: Int32;
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
  let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemData);
  let result: Int32 = 10000000;
  let i: Int32 = 0;
  let maxAmmo: Int32 = 0;
  while i < ArraySize(requiredIngredients) {
    currentQuantity = transactionSystem.GetItemQuantity(this.m_playerCraftBook.GetOwner(), ItemID.CreateQuery(requiredIngredients[i].id.GetID()));
    if currentQuantity > requiredIngredients[i].quantity {
      result = Min(result, currentQuantity / requiredIngredients[i].quantity);
    } else {
      return 0;
    };
    i += 1;
  };
  if (itemData.HasTag(n"Ammo")) {
    maxAmmo = this.GetAmmoCraftingMaximum(itemData);
    return Min(result, maxAmmo);
  }
  return result;
}

@replaceMethod(CraftingSystem)
public final const func CanItemBeCrafted(itemData: wref<gameItemData>) -> Bool {
  let quality: gamedataQuality;
  let result: Bool;
  let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemData);
  switch itemData.GetItemType() {
    case gamedataItemType.Con_Ammo:
      result = this.HasIngredients(requiredIngredients) && this.GetAmmoCraftingMaximum(itemData) > 0;
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

@replaceMethod(CraftingSystem)
public final const func CanItemBeCrafted(itemRecord: wref<Item_Record>) -> Bool {
  let quality: gamedataQuality;
  let result: Bool;
  let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemRecord);
  switch itemRecord.ItemType().Type() {
    case gamedataItemType.Con_Ammo:
      result = this.HasIngredients(requiredIngredients) && this.GetAmmoCraftingMaximum(itemRecord) > 0;
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
