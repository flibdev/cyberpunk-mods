/** @file Messages - Custom Sorting

Implementation of custom sorting at runtime for the Messages screen

@see file:shared/VirtualNestedList.reds
*/

/// @section MessengerContactDataView

/// Sort contacts & conversations by the enum stored in f_itemSortMode
@addMethod(MessengerContactDataView)
protected func PreSortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
  let leftContact = MessengerContactDataView.flibGetContactFromListData(left);
  let rightContact = MessengerContactDataView.flibGetContactFromListData(right);

  if IsDefined(leftContact) && IsDefined(rightContact) {
    switch this.f_sortOrder {
      case flibSortOrder.Timestamp:
        compareBuilder.GameTimeDesc(leftContact.timeStamp, rightContact.timeStamp);
        break;
      case flibSortOrder.Name:
        compareBuilder.StringAsc(GetLocalizedText(leftContact.localizedName), GetLocalizedText(rightContact.localizedName));
        break;
      default:
        break;
    }
  };
}

/// Retrieve contact's actual `ContactData` for a given `VirutalNestedListData`.
@addMethod(MessengerContactDataView)
public static func flibGetContactFromListData(listData: ref<VirutalNestedListData>) -> ref<ContactData> {
  if !IsDefined(listData) {
    return null;
  }

  let contact: ref<ContactData> = listData.m_data as ContactData;

  if !listData.m_isHeader {
    contact = contact.f_parent;
  }

  return contact;
}

//--------------------------------------------------------------------------------------------------
/** @section MessengerGameController

Following the same logic that CDPR used to add their comparision tooltip to the other menus:
 - Adds a button hint for sorting
 - Adds an event listener to `n"OnPostOnRelease"` to respond to the events key release
 - On event:
   - Changes the internally stored state
   - Updates the `ButtonHint`
   - Fires a custom `ScriptableSystemRequest` with the `UIScriptableSystem` to store the value globally
   - Trigger a UI update

This code would be much nicer if I could append existing methods rather than replace them entirely.
*/

/// Sort order for messages
@addField(MessengerGameController)
private let f_sortOrder: flibSortOrder;

@addField(MessengerGameController)
private let f_uiScriptableSystem: wref<UIScriptableSystem>;

@wrapMethod(MessengerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );
  this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"flibOnPostOnRelease");
}

@wrapMethod(MessengerGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();

  this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"flibOnPostOnRelease");
}

@wrapMethod(MessengerGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  this.f_uiScriptableSystem = UIScriptableSystem.GetInstance(playerPuppet.GetGame());
  this.f_sortOrder = IntEnum(this.f_uiScriptableSystem.flibGetMessagesSorting());
  this.m_listController.flibSetSortOrder(this.f_sortOrder);
  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );
}

@addMethod(MessengerGameController)
protected cb func flibOnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
  if evt.IsAction(flibSortingUtils.GetButtonEventName()) {
    // Cycle to next valid sort order
    // Weird redscript bug: Can't do this with an if statement without casting
    switch this.f_sortOrder {
      case flibSortOrder.Timestamp:
        this.f_sortOrder = flibSortOrder.Name;
        break;
      case flibSortOrder.Name:
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
    this.f_uiScriptableSystem.flibSetMessagesSorting(EnumInt(this.f_sortOrder));
    this.m_listController.flibSetSortOrder(this.f_sortOrder);
    // Force UI refresh
    this.PopulateData();
  }
}

//--------------------------------------------------------------------------------------------------
/** @section UIScriptableSystem

`UIScriptableSystem` is a global singleton that stores state values for game menus.
It's what the backpack, inventory and vendor controllers use to store their sorting values.
I don't get to use their fancy request queue system though, goes through native code.
*/

/// Redscript compiler doesn't currently support the keyword `persistent`, not sure if needed
@addField(UIScriptableSystem)
private let f_messagesSorting: Int32;

/// Setter method for globally stored message sorting mode
@addMethod(UIScriptableSystem)
public final func flibSetMessagesSorting(mode: Int32) -> Void {
  this.f_messagesSorting = mode;
}

/// Getter method for globally stored message sorting mode
@addMethod(UIScriptableSystem)
public final const func flibGetMessagesSorting() -> Int32 {
  return (this.f_messagesSorting == 0)
    ? EnumInt(flibSortOrder.Timestamp)
    : this.f_messagesSorting;
}
