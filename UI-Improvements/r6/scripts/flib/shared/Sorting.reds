
enum flibSortingOrder {
  Timestamp = 0,
  Name = 1,
  Difficulty = 2
}

public class flibSorting extends ScriptableSystem {

  private let sortMessages: flibSortingOrder;
  private let sortQuests: flibSortingOrder;
  private let sortShards: flibSortingOrder;



  public static const func GetSortingButtonHint(order: flibSortingOrder) -> CName {
    switch order {
      case flibSortOrder.Timestamp:
        return n"flib-Sorting-Hint-Timestamp";
      case flibSortOrder.Name:
        return n"flib-Sorting-Hint-Name";
      case flibSortOrder.Difficulty:
        return n"flib-Sorting-Hint-Difficulty";
      default:
        // Shouldn't ever hit this, but the scripting runtime
        // supports undefined values for enums so ¯\_(ツ)_/¯
        return n"flib-Sorting-Hint-Timestamp";
    }
  }

  // -----------------------------------------------------------------------------------------------
  // ScriptableSystem

  // Get singleton instance from the Scriptable Systems Container
  public static func Get(gi: GameInstance) -> ref<flibSorting> {
    return GameInstance.GetScriptableSystemsContainer(gi).Get(n"flibSorting") as flibSorting;
  }

  private func OnAttach() -> Void {
    // Set defaults
    sortMessages = flibSortingOrder.Timestamp;
    sortQuests = flibSortingOrder.Timestamp;
    sortShards = flibSortingOrder.Timestamp;
  }
}
