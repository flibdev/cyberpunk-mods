
module flib.JournalContact
import flib._common.sort.*

public class JournalEntryArrayWrapper extends ArrayWrapper {
  protected let m_arr: array<wref<JournalEntry>>;

  public static func Create(arr: array<wref<JournalEntry>>) -> ref<JournalEntryArrayWrapper> {
    let comp = new JournalEntryArrayWrapper();
    comp.m_arr = arr;
    return comp;
  }

  public func Size() -> Int32 {
    return ArraySize(this.m_arr);
  }

  public func At(index: Int32) -> wref<JournalEntry> {
    return this.m_arr[index];
  }

  public func Swap(leftIndex: Int32, rightIndex: Int32) -> Void {
    let temp = this.m_arr[leftIndex];
    this.m_arr[leftIndex] = this.m_arr[rightIndex];
    this.m_arr[rightIndex] = temp;
  }
}

public class JournalContactByNameComparator extends Comparator {
  protected let m_journalManager: wref<JournalManager>;
  protected let m_compareBuilder: ref<CompareBuilder>;

  public static func Create(journalManager: wref<JournalManager>) -> ref<JournalContactByNameComparator> {
    let comp = new JournalContactByNameComparator();
    comp.m_journalManager = journalManager;
    comp.m_compareBuilder = CompareBuilder.Make();
    return comp;
  }

  public func Compare(wrap: ref<JournalEntryArrayWrapper>, leftIndex: Int32, rightIndex: Int32) -> Bool {
    let left = wrap.At(leftIndex) as JournalContact;
    let right = wrap.At(rightIndex) as JournalContact;
    
    this.m_compareBuilder.Reset();

    if IsDefined(left) && IsDefined(right) {
      this.m_compareBuilder
        .UnicodeStringAsc(
          GetLocalizedText(left.GetLocalizedName(this.m_journalManager)),
          GetLocalizedText(right.GetLocalizedName(this.m_journalManager))
        );
    }    

    return this.m_compareBuilder.GetBool();
  }
}