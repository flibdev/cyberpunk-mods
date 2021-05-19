/* In the parent classes VirtualNestedListDataView.SortItem() method,
 * the following sort order happens:
 *   1. PreSortItems()
 *   2. Sort by ContactData.m_level (set as the contact's hash)
 *   3. Sort by ContactData.m_isHeader (is contact or messages)
 *   4. SortItems()
 *
 * PreSortItems() has to maintain m_level contiguousness or it breaks the nested widgets
 */

//------------------------------------------------------------------------------



@addMethod(MessengerContactsVirtualNestedListController)
public func EnableSorting() -> Void {
  this.m_dataView.EnableSorting();

  if IsDefined(this.m_currentDataView) {
    Log("IsDefined()");
    this.LogData("EnableSorting()");
  }
}

@addMethod(MessengerContactsVirtualNestedListController)
public func ToggleLevel(targetLevel: Int32) -> Void {
  if ArrayContains(this.m_toggledLevels, targetLevel) {
    ArrayRemove(this.m_toggledLevels, targetLevel);
  } else {
    ArrayPush(this.m_toggledLevels, targetLevel);
  };
  this.m_dataView.SetToggledLevels(this.m_toggledLevels, this.m_defaultCollapsed);

  if IsDefined(this.m_currentDataView) {
    this.LogData("ToggleLevel()");
  }
}

// Debug: print entire list
@addMethod(MessengerContactsVirtualNestedListController)
public func LogData(from: String) -> Void {
  Log("LogData() called from " + from);

  let dataView: wref<MessengerContactDataView> = this.m_currentDataView;

  if !IsDefined(dataView) {
    return;
  }

  let formatter: ref<TableFormatter> = TableFormatter.Make();
  formatter.AddColumn("Index", 5, ColumnAlignment.Right);
  formatter.AddColumn("Level", 12, ColumnAlignment.Right);
  formatter.AddColumn("Header", 1, ColumnAlignment.Center);
  formatter.AddColumn("Collapsable", 1, ColumnAlignment.Center);
  formatter.AddColumn("Timestamp", 10, ColumnAlignment.Right);
  formatter.AddColumn("Localized Name", 32, ColumnAlignment.Left);

  let size = dataView.Size();
  let i = 0u;
  let logRow: array<String>;

  Log("Size() = " + ToString(size));

  formatter.LogHeader();

  while i < size {
    ArrayClear(logRow);

    ArrayPush(logRow, ToString(i));
    
    let item = dataView.GetItem(i) as VirutalNestedListData;
    if IsDefined(item) {

      ArrayPush(logRow, ToString(item.m_level));
      ArrayPush(logRow, item.m_isHeader ? "Y" : "");
      ArrayPush(logRow, item.m_collapsable ? "Y" : "");

      let data = item.m_data as ContactData;

      if IsDefined(data) {
        ArrayPush(logRow, ToString(GameTime.GetSeconds(data.timeStamp)));
        ArrayPush(logRow, GetLocalizedText(data.localizedName));        
      }
    }

    formatter.LogRow(logRow);

    i += 1u;
  }
}

@addMethod(MessengerContactDataView)
protected func PreSortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
  let leftData = (left.m_data as ContactData);
  let rightData = (right.m_data as ContactData);
  
  if IsDefined(leftData) && IsDefined(rightData) {
    let leftContact: ref<ContactData> = left.m_isHeader ? leftData : leftData.parent;
    let rightContact: ref<ContactData> = right.m_isHeader ? rightData : rightData.parent;

    compareBuilder
      .GameTimeDesc(leftContact.timeStamp, rightContact.timeStamp);
      //.StringAsc(GetLocalizedText(leftContact.localizedName), GetLocalizedText(rightContact.localizedName));
      //.BoolTrue(left.m_isHeader, right.m_isHeader);
  };
}

@replaceMethod(MessengerContactDataView)
protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
  let leftData = (left.m_data as ContactData);
  let rightData = (right.m_data as ContactData);
  
  if IsDefined(leftData) && IsDefined(rightData) && !left.m_isHeader && !right.m_isHeader {
    compareBuilder
      .BoolTrue(ArraySize(leftData.unreadMessages) > 0, ArraySize(rightData.unreadMessages) > 0)
      .GameTimeDesc(leftData.timeStamp, rightData.timeStamp);
  };
}

