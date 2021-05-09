// 
import flib._common.sort.*


public class ContactAndMessages {
  public let contact: ref<ContactData>;
  public let messages: array<ref<ContactData>>;
  public let latest: GameTime;
}

public class ContactAndMessagesArrayWrapper extends IArrayWrapper {
  protected let m_arr: script_ref<array<ref<ContactAndMessages>>>;
  public static func Make(arr: script_ref<array<ref<ContactAndMessages>>>) -> ref<ContactAndMessagesArrayWrapper> {
    let wrap = new ContactAndMessagesArrayWrapper();
    wrap.m_arr = arr;
    return wrap;
  }
  public func Size() -> Int32 { return ArraySize(Deref(this.m_arr)); }
  public func At(index: Int32) -> Variant { return ToVariant(Deref(this.m_arr)[index]); }
  public func Swap(leftIndex: Int32, rightIndex: Int32) -> Void {
    let temp: ref<ContactAndMessages> = Deref(this.m_arr)[leftIndex];
    Deref(this.m_arr)[leftIndex] = Deref(this.m_arr)[rightIndex];
    Deref(this.m_arr)[rightIndex] = temp;
  }
}

public class ContactAndMessagesComparator extends IComparator {
  // Return true if left < right, otherwise false
  public func Compare(left: Variant, right: Variant) -> Bool {
    let leftData: ref<ContactAndMessages> = FromVariant(left);
    let rightData: ref<ContactAndMessages> = FromVariant(right);

    return leftData.latest < rightData.latest;
  }
}


@replaceMethod(MessengerUtils)
public final static func GetContactDataArray(journal: ref<JournalManager>, includeUnknown: Bool, skipEmpty: Bool, activeDataSync: wref<MessengerContactSyncData>) -> array<ref<VirutalNestedListData>> {
  let i: Int32;
  let j: Int32;
  let conversationsCount: Int32;
  let context: JournalRequestContext;
  let entries: array<wref<JournalEntry>>;
  let contactEntry: wref<JournalContact>;
  let conversationEntry: wref<JournalPhoneConversation>;
  let conversations: array<wref<JournalEntry>>;
  let messagesReceived: array<wref<JournalEntry>>;
  let playerReplies: array<wref<JournalEntry>>;
  let contactData: ref<ContactData>;
  let threadData: ref<ContactData>;
  let contactVirtualListData: ref<VirutalNestedListData>;
  let threadVirtualListData: ref<VirutalNestedListData>;
  let virtualDataList: array<ref<VirutalNestedListData>>;
  let contactsMessagesArray: array<ref<ContactAndMessages>>;
  let contactMessages: ref<ContactAndMessages>;

  context.stateFilter.active = true;
  journal.GetContacts(context, entries);  

  // Split this method into two loops
  // The first collects the contact data, messages and the actual latest message timestamp
  for entry in entries {
    contactEntry = entry as JournalContact;

    if includeUnknown || contactEntry.IsKnown(journal) {
      ArrayClear(messagesReceived);
      ArrayClear(playerReplies);
      journal.GetConversations(contactEntry, conversations);
      journal.GetFlattenedMessagesAndChoices(contactEntry, messagesReceived, playerReplies);

      if !(skipEmpty && ArraySize(messagesReceived) <= 0 && ArraySize(playerReplies) <= 0) {
        contactData = new ContactData();
        contactData.id = contactEntry.GetId();
        contactData.hash = journal.GetEntryHash(contactEntry);
        contactData.localizedName = contactEntry.GetLocalizedName(journal);
        contactData.avatarID = contactEntry.GetAvatarID(journal);
        contactData.timeStamp = journal.GetEntryTimestamp(contactEntry);
        contactData.activeDataSync = activeDataSync;

        MessengerUtils.GetContactMessageData(contactData, journal, messagesReceived, playerReplies);

        contactMessages = new ContactAndMessages();
        contactMessages.contact = contactData;
        // I'm pretty sure this timestamp is actually the timestamp of when you met the character
        contactMessages.latest = contactData.timeStamp;
        ArrayClear(contactMessages.messages);

        for conversation in conversations {
          conversationEntry = conversation as JournalPhoneConversation;

          journal.GetMessagesAndChoices(conversationEntry, messagesReceived, playerReplies);
        
          threadData = new ContactData();
          threadData.id = conversationEntry.GetId();
          threadData.hash = journal.GetEntryHash(conversationEntry);
          threadData.localizedName = conversationEntry.GetTitle();
          threadData.timeStamp = journal.GetEntryTimestamp(conversationEntry);
          threadData.activeDataSync = activeDataSync;

          MessengerUtils.GetContactMessageData(threadData, journal, messagesReceived, playerReplies);

          ArrayPush(contactMessages.messages, threadData);
          if threadData.timeStamp > contactMessages.latest {
            contactMessages.latest = threadData.timeStamp;
          }
        }

        ArrayPush(contactsMessagesArray, contactMessages);
      }
    }
  }

  // Then the contacts are sorted by latest message timestamp
  Quicksort.SortArray(
    ContactAndMessagesArrayWrapper.Make(AsRef(contactsMessagesArray)),
    new ContactAndMessagesComparator()
  );

  // Then the second loop transforms this information into a VirutalNestedListData
  i = 0;
  while i < ArraySize(contactsMessagesArray) {
    contactMessages = contactsMessagesArray[i];

    // I truely hate this mispelt and woefully implemented "class"
    // This language supports classes and passing-by-reference, what fucking moron
    // decided to pass contacts and messages around in a flat array with magic fields?
    contactVirtualListData = new VirutalNestedListData();
    // m_level is used to determine both order and connects messages to their contact
    contactVirtualListData.m_level = i; 
    contactVirtualListData.m_widgetType = 0u;
    contactVirtualListData.m_isHeader = true;
    contactVirtualListData.m_data = contactMessages.contact;
    contactVirtualListData.m_collapsable = (ArraySize(contactMessages.messages) > 0);

    for messages in contactMessages.messages {
      threadVirtualListData = new VirutalNestedListData();
      threadVirtualListData.m_collapsable = false;
      threadVirtualListData.m_isHeader = false;
      threadVirtualListData.m_level = i; // has to match
      threadVirtualListData.m_widgetType = 1u;
      threadVirtualListData.m_data = messages;

      ArrayPush(virtualDataList, threadVirtualListData);
    }

    // Also the contact goes after the messages?
    ArrayPush(virtualDataList, contactVirtualListData);

    i += 1;
  }

  return virtualDataList;
}
