
module flib._common.sort

public class Quicksort {

  public static func SortArray(wrap: ref<ArrayWrapper>, comp: ref<Comparator>) -> Void {
    let arrSize = wrap.Size();
    if (arrSize > 1) {
      Quicksort.Quicksort(wrap, comp, 0, arrSize-1);
    }
  }

  private static func Quicksort(wrap: ref<ArrayWrapper>, comp: ref<Comparator>, lo: Int32, hi: Int32) -> Void {
    let pivot: Int32;

    Log("> Quicksort(" + lo + ", " + hi +")");

    if (lo < hi) {
      pivot = Quicksort.Partition(wrap, comp, lo, hi);

      if (lo < pivot) {
        Quicksort.Quicksort(wrap, comp, lo, pivot);
      }
      if (pivot < hi) {
        Quicksort.Quicksort(wrap, comp, pivot + 1, hi);
      }
    }
  }

  private static func Partition(wrap: ref<ArrayWrapper>, comp: ref<Comparator>, lo: Int32, hi: Int32) -> Int32 {
    let i = lo;
    let j = hi;

    let pivot = (hi + lo) / 2;

    Log("> Partition(" + lo + ", " + hi +") = " + pivot);

    while i < j {
      while !comp.Compare(wrap, i, pivot) && i < hi {
        i += 1;
      }

      while comp.Compare(wrap, j, pivot) && j > lo {
        j -= 1;
      }

      if i < j {
        wrap.Swap(i, j);

        i += 1;
        j -= 1;
      }
    }

    return j;
  }
}

// Wrapper needed to get around lack of generic arrays
public class ArrayWrapper {
  public func Size() -> Int32 { Log("OH NO I'M IN THE ABSTRACT METHOD"); return 0; }
  public func At(index: Int32) -> Variant { }
  public func Swap(leftIndex: Int32, rightIndex: Int32) -> Void {}
}

public class Comparator {
  // Return true if left > right
  public func Compare(wrap: ref<ArrayWrapper>, leftIndex: Int32, rightIndex: Int32) -> Bool {
    return false;
  }
}



// Testing
public class IntArrayWrapper {
  protected let m_arr: array<Int32>;

  public static func Make(arr: array<Int32>) -> ref<IntArrayWrapper> {
    let wrapper = new IntArrayWrapper();
    wrapper.m_arr = arr;
    return wrapper;
  }

  public func Size() -> Int32 {
    return ArraySize(this.m_arr);
  }
  
  public func At(index: Int32) -> Int32 {
    return this.m_arr[index];
  }
  
  public func Swap(leftIndex: Int32, rightIndex: Int32) -> Void {
    let temp: Int32 = this.m_arr[leftIndex];
    this.m_arr[leftIndex] = this.m_arr[rightIndex];
    this.m_arr[rightIndex] = temp;
  }
}

public class IntComparator {
  // Return true if left > right
  public func Compare(wrap: ref<IntArrayWrapper>, leftIndex: Int32, rightIndex: Int32) -> Bool {
    return wrap.At(leftIndex) > wrap.At(rightIndex);
  }
}

@replaceGlobal()
public static exec func LogGender(gameInstance: GameInstance) -> Void {

  let testArray: array<Int32> = [4,5,6,7,8,9,1,2,3];

  LogIntArray("Unsorted array", testArray);

  Quicksort.SortArray(
    IntArrayWrapper.Make(testArray) as ArrayWrapper,
    new IntComparator() as Comparator
  );

  LogIntArray("Sorted array", testArray);

}

public static func LogIntArray(label: String, arr: array<Int32>) -> Void {
  let buffer: String = label + " = [";

  let i: Int32 = 0;
  let size: Int32 = ArraySize(arr);

  while (i < size) {
    if (i > 0) {
      buffer += ",";
    }

    buffer += ToString(arr[i]) ;

    i += 0;
  }

  Log(buffer + "]");
}
