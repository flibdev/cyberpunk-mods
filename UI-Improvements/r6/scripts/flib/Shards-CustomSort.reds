/** @file Shards - Custom Sorting

Implementation of custom sorting at runtime for the Shards screen

@see file:shared/VirtualNestedList.reds
*/

/// @section ShardsNestedListDataView

/// Sort shard groups by the enum stored in f_itemSortMode
@addMethod(ShardsNestedListDataView)
protected func PreSortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
  let leftShard = ShardsNestedListDataView.flibGetShardGroupFromListData(left);
  let rightShard = ShardsNestedListDataView.flibGetShardGroupFromListData(right);

  if IsDefined(leftShard) && IsDefined(leftShard) {
    switch this.f_sortOrder {
      case flibSortOrder.Timestamp:
        compareBuilder
          .BoolTrue(leftShard.m_isNew, rightShard.m_isNew)
          .GameTimeDesc(leftShard.m_timeStamp, rightShard.m_timeStamp);
        break;
      case flibSortOrder.Name:
        compareBuilder.StringAsc(GetLocalizedText(leftShard.m_title), GetLocalizedText(rightShard.m_title));
        break;
      default:
        break;
    }
  }
}

/// Sort the shards themselves by the enum stored in f_itemSortMode
@replaceMethod(ShardsNestedListDataView)
protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
  let leftData = (left.m_data as ShardEntryData);
  let rightData = (right.m_data as ShardEntryData);

  if IsDefined(leftData) && IsDefined(rightData) {
    switch this.f_sortOrder {
      case flibSortOrder.Timestamp:
        compareBuilder
          .BoolTrue(leftData.m_isNew, rightData.m_isNew)
          .GameTimeDesc(leftData.m_timeStamp, leftData.m_timeStamp);
        break;
      case flibSortOrder.Name:
        compareBuilder
          .BoolTrue(leftData.m_isNew, rightData.m_isNew)
          .StringAsc(GetLocalizedText(leftData.m_title), GetLocalizedText(rightData.m_title));
        break;
      default:
        break;
    }
  }
}

/// Retrieve shards group for a given `VirutalNestedListData`.
@addMethod(ShardsNestedListDataView)
public static func flibGetShardGroupFromListData(listData: ref<VirutalNestedListData>) -> ref<ShardEntryData> {
  if !IsDefined(listData) {
    return null;
  }

  let shard: ref<ShardEntryData> = listData.m_data as ShardEntryData;

  if !listData.m_isHeader {
    shard = shard.f_group;
  }

  return shard;
}

//--------------------------------------------------------------------------------------------------
/// @section ShardsMenuGameController

@addField(ShardsMenuGameController)
private let f_sortOrder: flibSortOrder;

@addField(ShardsMenuGameController)
private let f_uiScriptableSystem: wref<UIScriptableSystem>;

@replaceMethod(ShardsMenuGameController)
protected cb func OnInitialize() -> Bool {
  let hintsWidget: ref<inkWidget> = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsManagerRef), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root");
  this.m_buttonHintsController = hintsWidget.GetController() as ButtonHints;
  this.RefreshButtonHints();
  this.m_entryViewController = inkWidgetRef.GetController(this.m_entryViewRef) as CodexEntryViewController;
  this.m_listController = inkWidgetRef.GetController(this.m_virtualList) as ShardsVirtualNestedListController;
  this.m_activeData = new CodexListSyncData();
  inkWidgetRef.SetVisible(this.m_entryViewRef, false);
  this.PlayLibraryAnimation(n"shards_intro");
  // Added below
  this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"flibOnPostOnRelease");
}


@replaceMethod(ShardsMenuGameController)
protected cb func OnUninitialize() -> Bool {
  this.m_menuEventDispatcher.UnregisterFromEvent(n"OnBack", this, n"OnBack");
  // Added below
  this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"flibOnPostOnRelease");
}

@replaceMethod(ShardsMenuGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_journalManager = GameInstance.GetJournalManager(playerPuppet.GetGame());
  this.m_journalManager.RegisterScriptCallback(this, n"OnEntryVisitedUpdate", gameJournalListenerType.Visited);
  this.m_InventoryManager = new InventoryDataManagerV2();
  this.m_player = playerPuppet as PlayerPuppet;
  this.m_InventoryManager.Initialize(this.m_player);
  this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnButtonRelease");
  // Inserted below
  this.f_uiScriptableSystem = UIScriptableSystem.GetInstance(playerPuppet.GetGame());
  this.f_sortOrder = IntEnum(this.f_uiScriptableSystem.flibGetShardsSorting());
  this.m_listController.flibSetSortOrder(this.f_sortOrder);
  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );
  // Inserted above
  this.PopulateData();
  this.SelectEntry();
}

@replaceMethod(ShardsMenuGameController)
private final func RefreshButtonHints() -> Void {
  this.m_buttonHintsController.ClearButtonHints();
  this.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
  if this.m_isEncryptedEntrySelected {
    this.PlaySound(n"MapPin", n"OnDisable");
    inkWidgetRef.SetVisible(this.m_crackHint, true);
    this.PlayAnim(n"hint_show");
  } else {
    inkWidgetRef.SetVisible(this.m_crackHint, false);
    this.PlayAnim(n"hint_hide");
  };
  // Added below
  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );
}

@addMethod(ShardsMenuGameController)
protected cb func flibOnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(flibSortingUtils.GetButtonEventName()) {
    // Cycle to next valid sort order
    switch this.f_sortOrder {
      case flibSortOrder.Timestamp:
        this.f_sortOrder = flibSortOrder.Name;
        break;
      case flibSortOrder.Name:
        this.f_sortOrder = flibSortOrder.Timestamp;
        break;
      default:
        this.f_sortOrder = flibSortOrder.Name;
        break;
    }
    this.RefreshButtonHints();
    // Update UIScriptableSystem
    this.f_uiScriptableSystem.flibSetShardsSorting(EnumInt(this.f_sortOrder));
    this.m_listController.flibSetSortOrder(this.f_sortOrder);
    // Force UI refresh
    this.PopulateData();
  }
}

//--------------------------------------------------------------------------------------------------
/// @section UIScriptableSystem

@addField(UIScriptableSystem)
private let f_shardsSorting: Int32;

@addMethod(UIScriptableSystem)
public final func flibSetShardsSorting(mode: Int32) -> Void {
  this.f_shardsSorting = mode;
}

@addMethod(UIScriptableSystem)
public final const func flibGetShardsSorting() -> Int32 {
  return (this.f_shardsSorting == 0)
    ? EnumInt(flibSortOrder.Name)
    : this.f_shardsSorting;
}
