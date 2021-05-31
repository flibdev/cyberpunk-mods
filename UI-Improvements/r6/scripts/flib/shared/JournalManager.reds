/// Added logic to fill the ContactData.timeStamp field
@replaceMethod(JournalManager)
public final func GetContactDataArray(includeUnknown: Bool) -> array<ref<IScriptable>> {
  let contactData: ref<ContactData>;
  let contactDataArray: array<ref<IScriptable>>;
  let contactEntry: wref<JournalContact>;
  let context: JournalRequestContext;
  let emptyContactData: ref<ContactData>;
  let entries: array<wref<JournalEntry>>;
  let i: Int32;
  let j: Int32;
  let k: Int32;
  let lastMessegeRecived: wref<JournalPhoneMessage>;
  let lastMessegeSent: wref<JournalPhoneChoiceEntry>;
  let messagesReceived: array<wref<JournalEntry>>;
  let playerReplies: array<wref<JournalEntry>>;
  let trackedChildEntriesCount: Int32;
  let trackedChildEntriesHashList: array<Int32>;
  let trackedChildEntriesList: array<wref<JournalEntry>>;
  let trackedChildEntry: wref<JournalQuestCodexLink>;
  let trackedObjective: ref<JournalQuestObjective>;

  context.stateFilter.active = true;
  this.GetContacts(context, entries);
  trackedChildEntriesCount = 0;
  trackedObjective = this.GetTrackedEntry() as JournalQuestObjective;

  if trackedObjective != null {
    this.GetChildren(trackedObjective, context.stateFilter, trackedChildEntriesList);
    trackedChildEntriesCount = ArraySize(trackedChildEntriesList);
    j = 0;
    while j < trackedChildEntriesCount {
      trackedChildEntry = trackedChildEntriesList[j] as JournalQuestCodexLink;
      if IsDefined(trackedChildEntry) {
        ArrayPush(trackedChildEntriesHashList, Cast(trackedChildEntry.GetLinkPathHash()));
      };
      j = j + 1;
    };
  };

  i = 0;
  while i < ArraySize(entries) {
    contactEntry = entries[i] as JournalContact;
    if IsDefined(contactEntry) {
      if includeUnknown || contactEntry.IsKnown(this) {
        contactData = new ContactData();
        contactData.id = contactEntry.GetId();
        contactData.hash = this.GetEntryHash(contactEntry);
        contactData.localizedName = contactEntry.GetLocalizedName(this);
        contactData.avatarID = contactEntry.GetAvatarID(this);
        contactData.questRelated = ArrayContains(trackedChildEntriesHashList, contactData.hash);
        contactData.f_parent = null;

        ArrayClear(messagesReceived);
        ArrayClear(playerReplies);
        this.GetFlattenedMessagesAndChoices(contactEntry, messagesReceived, playerReplies);

        j = 0;
        while j < ArraySize(messagesReceived) {
          if !this.IsEntryVisited(messagesReceived[j]) {
            ArrayPush(contactData.unreadMessages, this.GetEntryHash(messagesReceived[j]));
          }
          j += 1;
        }
        contactData.unreadMessegeCount = ArraySize(contactData.unreadMessages);
        contactData.playerCanReply = ArraySize(playerReplies) > 0;

        if ArraySize(messagesReceived) > 0 {
          contactData.hasMessages = true;
          lastMessegeRecived = ArrayLast(messagesReceived) as JournalPhoneMessage;
          if IsDefined(lastMessegeRecived) {
            contactData.lastMesssagePreview = lastMessegeRecived.GetText();
            contactData.playerIsLastSender = false;
            contactData.timeStamp = this.GetEntryTimestamp(lastMessegeRecived);
          } else {
            lastMessegeSent = ArrayLast(messagesReceived) as JournalPhoneChoiceEntry;
            contactData.lastMesssagePreview = lastMessegeSent.GetText();
            contactData.playerIsLastSender = true;
            contactData.timeStamp = this.GetEntryTimestamp(lastMessegeSent);
          }
        } else {
          // What even is localization?
          contactData.lastMesssagePreview = "You are now connected.";
        }
        ArrayPush(contactDataArray, contactData);
      }
    } else {
      // Why?
      ArrayPush(contactDataArray, emptyContactData);
    }

    i += 1;
  }

  return contactDataArray;
}
