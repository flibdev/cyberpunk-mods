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
    compareBuilder.StringAsc(GetLocalizedText(leftShard.m_title), GetLocalizedText(rightShard.m_title));
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

@wrapMethod(ShardsMenuGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"flibOnPostOnRelease");
}


@wrapMethod(ShardsMenuGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();

  this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"flibOnPostOnRelease");
}

@wrapMethod(ShardsMenuGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  this.f_uiScriptableSystem = UIScriptableSystem.GetInstance(playerPuppet.GetGame());
  this.f_sortOrder = IntEnum(this.f_uiScriptableSystem.flibGetShardsSorting());
  this.m_listController.flibSetSortOrder(this.f_sortOrder);
  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );

  wrappedMethod(playerPuppet);
}

@wrapMethod(ShardsMenuGameController)
private final func RefreshButtonHints() -> Void {
  wrappedMethod();

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

@replaceMethod(ShardsMenuGameController)
private final func PopulateData() -> Void {
  let groupData: ref<ShardEntryData>;
  let groupVirtualListData: ref<VirutalNestedListData>;
  let newEntries: array<Int32>;
  let items: array<InventoryItemData>;
  let data: array<ref<VirutalNestedListData>>;
  let level: Int32 = 0;
  let counter: Int32 = 0;
  let i: Int32 = 0;

  items = this.m_InventoryManager.GetPlayerItemsByType(gamedataItemType.Gen_Misc, false, [n"HideInBackpackUI"]);
  data  = CodexUtils.GetShardsDataArray(this.m_journalManager, this.m_activeData);
  level = ArraySize(data);
  this.m_hasNewCryptedEntries = false;

  i = 0;
  while i < ArraySize(items) {
    if this.ProcessItem(items[i], data, level, newEntries) {
      counter += 1;
    }
    i += 1;
  }

  if counter > 0 {
    groupData = new ShardEntryData();
    groupData.m_title = "[" + GetLocalizedTextByKey(n"Story-base-journal-codex-tutorials-Endryptedshards_title") + "]";
    groupData.m_activeDataSync = this.m_activeData;
    groupData.m_counter = counter;
    groupData.m_isNew = this.m_hasNewCryptedEntries;
    groupData.f_group = null;
    groupData.m_newEntries = newEntries;
    groupVirtualListData = new VirutalNestedListData();
    groupVirtualListData.m_level = level;
    groupVirtualListData.m_widgetType = 1u;
    groupVirtualListData.m_isHeader = true;
    groupVirtualListData.m_data = groupData;

    for shardListData in data {
      if !shardListData.m_isHeader {
        let shard = shardListData.m_data as ShardEntryData;
        if IsDefined(shard) && shard.m_isCrypted {
          shard.f_group = groupData;
        }
      }
    }

    ArrayPush(data, groupVirtualListData);
  }

  if ArraySize(data) > 0 {
    this.HideNodataWarning();
    this.m_listController.SetData(data, true, true);
  }
  else {
    this.ShowNodataWarning();
  }

  this.RefreshButtonHints();
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
