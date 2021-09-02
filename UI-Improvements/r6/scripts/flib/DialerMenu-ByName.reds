
@replaceMethod(DialerContactDataView)
public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
  let leftData = (left as ContactData);
  let rightData = (right as ContactData);

  this.m_compareBuilder.Reset();

  return this.m_compareBuilder
    .BoolTrue(leftData.questRelated, rightData.questRelated)
    .BoolTrue(ArraySize(leftData.unreadMessages) > 0, ArraySize(rightData.unreadMessages) > 0)
    .StringAsc(GetLocalizedText(leftData.localizedName), GetLocalizedText(rightData.localizedName))
    .GetBool();
}
