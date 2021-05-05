
public static class QuicksortContacts {

  public static func SortArray(journal: ref<JournalManager>, out contacts: array<wref<JournalEntry>>, comparator: ref<QuicksortComparator>) {
    let contactCount = ArraySize(contacts);
    if (contactCount > 1) {
      QuicksortContacts.SortRecurse(journal, contacts, comparator, 0, contactCount-1);
    }
  }

  private static func SortRecurse(journal: ref<JournalManager>, out contacts: array<wref<JournalEntry>>, comparator: ref<QuicksortComparator>, lo: Int32, hi: Int32) -> Void {
    let pivot: Int32;

    if (lo < hi) {
      pivot = QuicksortContacts.Partition(journal, contacts, comparator, lo, hi);
      
      QuicksortContacts.SortRecurse(journal, contacts, comparator, lo, pivot);
      QuicksortContacts.SortRecurse(journal, contacts, comparator, pivot + 1, hi);
    }
  }

  private static func Partition(journal: ref<JournalManager>, out contacts: array<wref<JournalEntry>>, comparator: ref<QuicksortComparator>, lo: Int32, hi: Int32) -> Int32 {
    let i: Int32;
    let j: Int32;
    let pivot: wref<JournalEntry>;
    let tempItem: wref<JournalEntry>;

    // Hoare partition scheme implementation of quicksort
    pivot = contacts[(lo+hi)/2];
    i = lo;
    j = hi;    

    while true {
      while !comparator.Compare(journal, contacts[i], pivot) {
        i = i + 1;
      }      
      
      while !comparator.Compare(journal, pivot, contacts[j]) {
        j = j - 1;
      }
      
      if i >= j {
        return j;
      }

      tempItem = contacts[i];
      contacts[i] = contacts[j];
      contacts[j] = tempItem;

      i = i + 1;
      j = j - 1;
    }
  }
}

public class QuicksortComparator {
  public func Compare(journalManager: wref<JournalManager>, left: wref<JournalEntry>, right: wref<JournalEntry>) -> Bool {
    return false;
  }
}


public class SortContactsByNameComparator extends QuicksortComparator {
  public func Compare(journalManager: wref<JournalManager>, left: wref<JournalEntry>, right: wref<JournalEntry>) -> Bool {
    let leftData = (left as JournalContact);
    let rightData = (right as JournalContact);

    if (leftData != null) && (rightData != null) {
      return CompareBuilder.Make()
        .BoolTrue(
          MessengerUtils.GetUnreadMessagesCount(journalManager, leftData) > 0,
          MessengerUtils.GetUnreadMessagesCount(journalManager, rightData) > 0
        )
        .UnicodeStringAsc(
          GetLocalizedText(leftData.GetLocalizedName(journalManager)),
          GetLocalizedText(rightData.GetLocalizedName(journalManager))
        )
        .GetBool();
    }
    return false;
  }
}
