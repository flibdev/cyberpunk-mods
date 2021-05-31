/** @file Messages - Custom Sorting

Implementation of custom sorting at runtime for the Messages screen
*/

/** @section MessengerContactDataView

The logic used in the parent class `VirtualNestedListDataView.SortItem()` method is as follows:
 1. `PreSortItems()`
 2. Sort by `ContactData.m_level` (set as the contact's hash)
 3. Sort by `ContactData.m_isHeader` (is contact or conversation)
 4. `SortItems()`

`PreSortItems()` has to maintain `m_level` contiguousness or it will break the ordering of nested
conversations, especially when opening and closing the parent contact widget. If `PreSortItems()`
is used correctly and keeps contacts and conversations grouped together, then `SortItems()` no
longer needs to be overridden to sort conversations by most recent as the timestamps have been fixed
in `MessengerUtils.GetContactDataArray()`.

!!! warning Learn from my pain
    Having taken a deep dive into the "logic" and implementation of these poorly named
    `VirtualNestedListDataView` and `VirutalNestedListData` classes, I have developed a deep hatred
    for whatever excuse for a developer birthed these horrors into the world and forced them upon
    their co-workers.
*/


@addField(MessengerContactDataView)
private let f_sortOrder: flibSortOrder;

@addMethod(MessengerContactDataView)
public final func flibSetSortOrder(order: flibSortOrder) -> Void {
  this.f_sortOrder = order;
  this.Sort();
}

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
/** @section MessengerContactsVirtualNestedListController

The container that holds the `MessengerContactDataView` collection
*/

/// A simple pass-through method to transfer the sort order
@addMethod(MessengerContactsVirtualNestedListController)
public final func flibSetSortOrder(order: flibSortOrder) -> Void {
  this.m_currentDataView.flibSetSortOrder(order);
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

@replaceMethod(MessengerGameController)
protected cb func OnInitialize() -> Bool {
  let hintsWidget: wref<inkWidget> = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsManagerRef), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root");
  this.m_buttonHintsController = hintsWidget.GetController() as ButtonHints;
  this.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
  this.m_dialogController = inkWidgetRef.GetController(this.m_dialogRef) as MessengerDialogViewController;
  this.m_listController = inkWidgetRef.GetController(this.m_contactsRef) as MessengerContactsVirtualNestedListController;
  this.m_activeData = new MessengerContactSyncData();
  this.PlayLibraryAnimation(n"contacts_intro");
  // Added below
  this.m_buttonHintsController.AddButtonHint(
    flibSortingUtils.GetButtonEventName(),
    flibSortingUtils.GetSortOrderButtonHint(this.f_sortOrder)
  );
  this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"flibOnPostOnRelease");
}

@replaceMethod(MessengerGameController)
protected cb func OnUninitialize() -> Bool {
  this.m_menuEventDispatcher.UnregisterFromEvent(n"OnBack", this, n"OnBack");
  // Added below
  this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"flibOnPostOnRelease");
}

@replaceMethod(MessengerGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_journalManager = GameInstance.GetJournalManager(this.GetPlayerControlledObject().GetGame());
  this.m_dialogController.AttachJournalManager(this.m_journalManager);
  this.PopulateData();
  this.m_journalManager.RegisterScriptCallback(this, n"OnJournalUpdate", gameJournalListenerType.Visited);
  // Added below
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