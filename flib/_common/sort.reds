
//module flib._common.sort

// Array wrapper needed to get around lack of generic arrays or array<variant> typecasting support
public abstract class IArrayWrapper extends IScriptable {
  public func Size() -> Int32 { return 0; }
  public func At(index: Int32) -> Variant { }
  public func Swap(leftIndex: Int32, rightIndex: Int32) -> Void {}
}

public abstract class IComparator extends IScriptable {
  // Return true if left < right, otherwise false
  public func Compare(left: Variant, right: Variant) -> Bool {
    return true;
  }
}

public class Quicksort extends IScriptable {

  public static func SortArray(wrap: ref<IArrayWrapper>, comp: ref<IComparator>) -> Void {
    let arrSize = wrap.Size();
    if (arrSize > 1) {
      Quicksort.Quicksort(wrap, comp, 0, arrSize-1);
    }
  }

  private static func Quicksort(wrap: ref<IArrayWrapper>, comp: ref<IComparator>, lo: Int32, hi: Int32) -> Void {
    let pivot: Int32;

    if (lo < hi) {
      pivot = Quicksort.Partition(wrap, comp, lo, hi);

      Quicksort.Quicksort(wrap, comp, lo, pivot);
      Quicksort.Quicksort(wrap, comp, pivot + 1, hi);
    }
  }

  private static func Partition(wrap: ref<IArrayWrapper>, comp: ref<IComparator>, lo: Int32, hi: Int32) -> Int32 {
    let i = lo;
    let j = hi;

    let pivot: Variant = wrap.At((hi + lo) / 2);

    while true {
      while comp.Compare(wrap.At(i), pivot) {
        i += 1;
      }
      
      while comp.Compare(pivot, wrap.At(j)) {
        j -= 1;
      }

      if i >= j {
        return j;
      }

      wrap.Swap(i, j);

      i += 1;
      j -= 1;
    }
    
  }
}

//------------------------------------------------------------------------------
// Testing

public class Int32ArrayWrapper extends IArrayWrapper {
  protected let m_arr: script_ref<array<Int32>>;

  public static func Make(arr: script_ref<array<Int32>>) -> ref<IArrayWrapper> {
    let wrapper = new Int32ArrayWrapper();
    wrapper.m_arr = arr;
    return wrapper;
  }

  public func Size() -> Int32 {
    return ArraySize(Deref(this.m_arr));
  }
  
  public func At(index: Int32) -> Variant {
    return ToVariant(Deref(this.m_arr)[index]);
  }
  
  public func Swap(leftIndex: Int32, rightIndex: Int32) -> Void {
    let temp: Int32 = Deref(this.m_arr)[leftIndex];
    Deref(this.m_arr)[leftIndex] = Deref(this.m_arr)[rightIndex];
    Deref(this.m_arr)[rightIndex] = temp;
  }
}

public class Int32Comparator extends IComparator {
  public static func Make() -> ref<IComparator> {
    return new Int32Comparator();
  }
  // Return true if left < right, otherwise false
  public func Compare(left: Variant, right: Variant) -> Bool {
    let leftData: Int32 = FromVariant(left);
    let rightData: Int32 = FromVariant(right);

    return leftData < rightData;
  }
}



public static exec func TestSort(gameInstance: GameInstance) -> Void {

  let testArray: array<Int32> = [4,5,6,7,8,9,1,2,3];

  LogIntArray("Unsorted array", AsRef(testArray));

  let wrap: ref<IArrayWrapper> = Int32ArrayWrapper.Make(AsRef(testArray)) as IArrayWrapper;
  let comp: ref<IComparator> = Int32Comparator.Make() as IComparator;

  Quicksort.SortArray(wrap, comp);
  
  LogIntArray("Sorted array", AsRef(testArray));

}

public static func LogIntArray(label: String, arr: script_ref<array<Int32>>) -> Void {
  let buffer: String = label + " = [";

  let i: Int32 = 0;
  let size: Int32 = ArraySize(Deref(arr));

  while (i < size) {
    if (i > 0) {
      buffer += ",";
    }

    buffer += ToString(Deref(arr)[i]);

    i += 1;
  }

  Log(buffer + "]");
}
