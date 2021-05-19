// Added field to track the parent contact of message threads
@addField(ContactData)
public let parent: wref<ContactData>;
