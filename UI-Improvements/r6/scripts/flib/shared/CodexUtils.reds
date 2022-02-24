
/// Added field to track the group each shard belongs to
@addField(ShardEntryData)
public let f_group: ref<ShardEntryData>;

/// Added logic to fill the ShardEntryData.m_timeStamp field with the latest message timestamp
@replaceMethod(CodexUtils)
public final static func GetShardsDataArray(journal: ref<JournalManager>, activeDataSync: wref<CodexListSyncData>) -> array<ref<VirutalNestedListData>> {
  let context: JournalRequestContext;
  let curGroup: wref<JournalOnscreensStructuredGroup>;
  let curShard: wref<JournalOnscreen>;
  let groupData: ref<ShardEntryData>;
  let groupVirtualListData: ref<VirutalNestedListData>;
  let groups: array<ref<JournalOnscreensStructuredGroup>>;
  let hasNewEntries: Bool;
  let i: Int32;
  let j: Int32;
  let newEntries: array<Int32>;
  let shardData: ref<ShardEntryData>;
  let shardVirtualListData: ref<VirutalNestedListData>;
  let shards: array<wref<JournalOnscreen>>;
  let virtualDataList: array<ref<VirutalNestedListData>>;
  let latestTimestamp: GameTime;
  context.stateFilter.active = true;
  journal.GetOnscreens(context, groups);

  i = 0;
  while i < ArraySize(groups) {
    curGroup = groups[i];
    shards = curGroup.GetEntries();
    hasNewEntries = false;
    ArrayClear(newEntries);

    groupData = new ShardEntryData();
    groupData.m_title = CodexUtils.GetLocalizedTag(curGroup.GetTag());
    groupData.m_activeDataSync = activeDataSync;
    groupData.m_counter = ArraySize(shards);
    groupData.f_group = null;

    j = 0;
    while j < ArraySize(shards) {
      curShard = shards[j];
      shardData = new ShardEntryData();
      shardData.m_title = curShard.GetTitle();
      shardData.m_description = curShard.GetDescription();
      shardData.m_imageId = curShard.GetIconID();
      shardData.m_hash = journal.GetEntryHash(curShard);
      shardData.m_timeStamp = journal.GetEntryTimestamp(curShard);
      shardData.m_activeDataSync = activeDataSync;
      shardData.f_group = groupData;
      shardData.m_isNew = !journal.IsEntryVisited(curShard);
      if shardData.m_isNew {
        ArrayPush(newEntries, shardData.m_hash);
        ArrayPush(shardData.m_newEntries, shardData.m_hash);
      };
      shardVirtualListData = new VirutalNestedListData();
      shardVirtualListData.m_level = i;
      shardVirtualListData.m_widgetType = 0u;
      shardVirtualListData.m_isHeader = false;
      shardVirtualListData.m_data = shardData;
      ArrayPush(virtualDataList, shardVirtualListData);
      if shardData.m_isNew {
        hasNewEntries = true;
      };

      j += 1;
    };

    groupData.m_isNew = hasNewEntries;
    groupData.m_newEntries = newEntries;
    groupVirtualListData = new VirutalNestedListData();
    groupVirtualListData.m_level = i;
    groupVirtualListData.m_widgetType = 1u;
    groupVirtualListData.m_isHeader = true;
    groupVirtualListData.m_data = groupData;
    ArrayPush(virtualDataList, groupVirtualListData);
    i += 1;
  };
  return virtualDataList;
}
