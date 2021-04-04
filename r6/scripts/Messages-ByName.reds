@replaceMethod(MessengerContactDataView)
protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
  let leftData = (left.m_data as ContactData);
  let rightData = (right.m_data as ContactData);
  
  if (leftData != null) && (rightData != null) {
    compareBuilder
      .BoolTrue(leftData.questRelated, rightData.questRelated)
      .BoolTrue(ArraySize(leftData.unreadMessages) > 0, ArraySize(rightData.unreadMessages) > 0)
      .UnicodeStringAsc(GetLocalizedText(leftData.localizedName), GetLocalizedText(rightData.localizedName));
  }
}
