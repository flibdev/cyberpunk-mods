/// Added field to track the parent contact of message threads
@addField(ContactData)
public let f_parent: wref<ContactData>;

/// Added logic to fill the `ContactData.timeStamp` field with the latest message timestamp
@replaceMethod(MessengerUtils)
public final static func GetContactDataArray(journal: ref<JournalManager>, includeUnknown: Bool, skipEmpty: Bool, activeDataSync: wref<MessengerContactSyncData>) -> array<ref<VirutalNestedListData>> {
  let contactData: ref<ContactData>;
  let contactEntry: wref<JournalContact>;
  let contactVirtualListData: ref<VirutalNestedListData>;
  let context: JournalRequestContext;
  let conversationEntry: wref<JournalPhoneConversation>;
  let conversations: array<wref<JournalEntry>>;
  let conversationsCount: Int32;
  let entries: array<wref<JournalEntry>>;
  let i: Int32;
  let j: Int32;
  let messagesReceived: array<wref<JournalEntry>>;
  let playerReplies: array<wref<JournalEntry>>;
  let threadData: ref<ContactData>;
  let threadVirtualListData: ref<VirutalNestedListData>;
  let virtualDataList: array<ref<VirutalNestedListData>>;
  let lastTimestamp: GameTime;
  context.stateFilter.active = true;
  journal.GetContacts(context, entries);
  i = 0;
  while i < ArraySize(entries) {
    contactEntry = entries[i] as JournalContact;
    if includeUnknown || contactEntry.IsKnown(journal) {
      ArrayClear(messagesReceived);
      ArrayClear(playerReplies);
      journal.GetConversations(contactEntry, conversations);
      journal.GetFlattenedMessagesAndChoices(contactEntry, messagesReceived, playerReplies);
      if skipEmpty && ArraySize(messagesReceived) <= 0 && ArraySize(playerReplies) <= 0 {
      } else {
        contactData = new ContactData();
        contactData.id = contactEntry.GetId();
        contactData.hash = journal.GetEntryHash(contactEntry);
        contactData.localizedName = contactEntry.GetLocalizedName(journal);
        contactData.avatarID = contactEntry.GetAvatarID(journal);
        // This timestamp appears to be when you first met the contact
        contactData.timeStamp = journal.GetEntryTimestamp(contactEntry);
        contactData.activeDataSync = activeDataSync;
        contactData.f_parent = null;
        MessengerUtils.GetContactMessageData(contactData, journal, messagesReceived, playerReplies);
        contactVirtualListData = new VirutalNestedListData();
        contactVirtualListData.m_level = contactData.hash;
        contactVirtualListData.m_widgetType = 0u;
        contactVirtualListData.m_isHeader = true;
        contactVirtualListData.m_data = contactData;
        conversationsCount = ArraySize(conversations);
        if conversationsCount > 1 {
          contactVirtualListData.m_collapsable = true;
          j = 0;
          while j < conversationsCount {
            ArrayClear(messagesReceived);
            ArrayClear(playerReplies);
            conversationEntry = conversations[j] as JournalPhoneConversation;
            journal.GetMessagesAndChoices(conversationEntry, messagesReceived, playerReplies);
            threadData = new ContactData();
            threadData.id = conversationEntry.GetId();
            threadData.hash = journal.GetEntryHash(conversationEntry);
            threadData.localizedName = conversationEntry.GetTitle();
            // This timestamp appears to be when you first started the conversation
            threadData.timeStamp = journal.GetEntryTimestamp(conversationEntry);
            threadData.activeDataSync = activeDataSync;
            threadData.f_parent = contactData;
            MessengerUtils.GetContactMessageData(threadData, journal, messagesReceived, playerReplies);
            threadVirtualListData = new VirutalNestedListData();
            threadVirtualListData.m_collapsable = false;
            threadVirtualListData.m_isHeader = false;
            threadVirtualListData.m_level = contactData.hash;
            threadVirtualListData.m_widgetType = 1u;
            threadVirtualListData.m_data = threadData;
            // Grab the timestamp from the most recent message
            if ArraySize(messagesReceived) > 0 {
              lastTimestamp = journal.GetEntryTimestamp(ArrayLast(messagesReceived));
              if lastTimestamp > threadData.timeStamp {
                threadData.timeStamp = lastTimestamp;
              }
            }
            if threadData.timeStamp > contactData.timeStamp {
              contactData.timeStamp = threadData.timeStamp;
            }

            ArrayPush(virtualDataList, threadVirtualListData);
            j += 1;
          };
        } else {
          contactVirtualListData.m_collapsable = false;
          // Check if the single converation has a more recent timestamp
          if conversationsCount > 0 {
            conversationEntry = conversations[0] as JournalPhoneConversation;
            // This timestamp appears to be when you first started the conversation
            let convoTimestamp = journal.GetEntryTimestamp(conversationEntry);
            // This check is necessary for recently learned contacts
            if ArraySize(messagesReceived) > 0 {
              // Grab the timestamp from the most recent message
              lastTimestamp = journal.GetEntryTimestamp(ArrayLast(messagesReceived));
              if lastTimestamp > convoTimestamp {
                convoTimestamp = lastTimestamp;
              }
            }
            if convoTimestamp > contactData.timeStamp {
              contactData.timeStamp = convoTimestamp;
            }
          }
        }

        ArrayPush(virtualDataList, contactVirtualListData);
      }
    }
    i += 1;
  }
  return virtualDataList;
}
