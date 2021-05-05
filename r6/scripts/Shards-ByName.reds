
@replaceMethod(ShardsNestedListDataView)
protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
  let leftData = (left.m_data as ShardEntryData);
  let rightData = (right.m_data as ShardEntryData);

  if leftData != null && rightData != null {
    compareBuilder
      .BoolTrue(leftData.m_isNew, rightData.m_isNew)
      .UnicodeStringAsc(GetLocalizedText(leftData.m_title), GetLocalizedText(rightData.m_title));
  };
}
