/** @file Quests - Custom Sorting

Implementation of custom sorting at runtime for the Quests screen

@see file:shared/VirtualNestedList.reds
*/

/** @section QuestListVirtualNestedDataView

Quests are the only VirtualNestedDataView that doesn't need its group sorting fixed
*/

/// Sort the quests by the enum stored in f_itemSortMode
@replaceMethod(QuestListVirtualNestedDataView)
protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
  let leftData = (left.m_data as QuestListItemData);
  let rightData = (right.m_data as QuestListItemData);

  if IsDefined(leftData) && IsDefined(rightData) {
    switch this.f_sortOrder {
      case flibSortOrder.Timestamp:
        compareBuilder.GameTimeDesc(leftData.m_timestamp, rightData.m_timestamp);
        break;
      case flibSortOrder.Name:
        compareBuilder.StringAsc(
          GetLocalizedText(leftData.m_questData.GetTitle(leftData.m_journalManager)),
          GetLocalizedText(rightData.m_questData.GetTitle(rightData.m_journalManager))
        );
        break;
      case flibSortOrder.Difficulty:
        compareBuilder.IntAsc(leftData.m_recommendedLevel, rightData.m_recommendedLevel);
        break;
      default:
        break;
    }
  }
}

//--------------------------------------------------------------------------------------------------
/// @section QuestListVirtualNestedListController

/// A simple pass-through method to transfer the sort order
@addMethod(QuestListVirtualNestedListController)
public final func flibSetSortOrder(order: flibSortOrder) -> Void {
  (this.m_dataView as QuestListVirtualNestedDataView).flibSetSortOrder(order);
}

//--------------------------------------------------------------------------------------------------
/// @section questLogGameController

@addField(questLogGameController)
private let f_sortOrder: flibSortOrder;

@addField(questLogGameController)
private let f_uiScriptableSystem: wref<UIScriptableSystem>;

@wrapMethod(questLogGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"flibOnPostOnRelease");
  this.f_uiScriptableSystem = UIScriptableSystem.GetInstance(this.m_game);
  this.f_sortOrder = IntEnum(this.f_uiScriptableSystem.flibGetQuestSorting());

  (inkWidgetRef.GetController(this.m_virtualList) as QuestListVirtualNestedListController).flibSetSortOrder(this.f_sortOrder);
  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );
}

@wrapMethod(questLogGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();

  this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"flibOnPostOnRelease");
}


@addMethod(questLogGameController)
protected cb func flibOnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(flibSortingUtils.GetButtonEventName()) {
    // Cycle to next valid sort order
    // Weird redscript bug: Can't do this with an if statement without casting
    switch this.f_sortOrder {
      case flibSortOrder.Timestamp:
        this.f_sortOrder = flibSortOrder.Name;
        break;
      case flibSortOrder.Name:
        this.f_sortOrder = flibSortOrder.Difficulty;
        break;
      case flibSortOrder.Difficulty:
        this.f_sortOrder = flibSortOrder.Timestamp;
        break;
      default:
        this.f_sortOrder = flibSortOrder.Timestamp;
        break;
    }
    // "Update" button hint
    this.m_buttonHintsController.AddButtonHint(
      flibSortingUtils.GetButtonEventName(),
      flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
    );
    // Update UIScriptableSystem
    this.f_uiScriptableSystem.flibSetQuestSorting(EnumInt(this.f_sortOrder));
    (inkWidgetRef.GetController(this.m_virtualList) as QuestListVirtualNestedListController).flibSetSortOrder(this.f_sortOrder);
    // Force UI refresh
    this.OnJournalReady(0u, n"", JournalNotifyOption.Notify, JournalChangeType.Undefined);
  }
}

@wrapMethod(questLogGameController)
protected cb func OnQuestListItemHoverOver(e: ref<QuestListItemHoverOverEvent>) -> Bool {
  wrappedMethod(e);

  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );
}

@wrapMethod(questLogGameController)
protected cb func OnQuestObjectiveHoverOver(e: ref<QuestObjectiveHoverOverEvent>) -> Bool {
  wrappedMethod(e);

  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );
}

@wrapMethod(questLogGameController)
protected cb func OnQuestListItemHoverOut(e: ref<QuestListItemHoverOutEvent>) -> Bool {
  wrappedMethod(e);

  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );
}

@wrapMethod(questLogGameController)
protected cb func OnQuestObjectiveHoverOut(e: ref<QuestObjectiveHoverOutEvent>) -> Bool {
  wrappedMethod(e);

  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );
}


//--------------------------------------------------------------------------------------------------
/// @section UIScriptableSystem

@addField(UIScriptableSystem)
private let f_questSorting: Int32;

@addMethod(UIScriptableSystem)
public final func flibSetQuestSorting(mode: Int32) -> Void {
  this.f_questSorting = mode;
}

@addMethod(UIScriptableSystem)
public final const func flibGetQuestSorting() -> Int32 {
  return (this.f_questSorting == 0)
    ? EnumInt(flibSortOrder.Timestamp)
    : this.f_questSorting;
}
