/** @file Sorting Utilities

Common sorting utilities shared between each of the new sorted menus
*/


/// Supported sorting methods used 
enum flibSortOrder {
  Timestamp = 0,
  Name = 1,
  Difficulty = 2
}

/// Utility class to help with custom sorting
public class flibSortingUtils {
  /// Returns the CName of the event to use for the sorting action
  /// None of the screens I've added sorting to use the comparison tooltips
  public static func GetButtonEventName() -> CName = n"toggle_comparison_tooltip"

  /// Returns the Localization Key CName for a given sorting order
  public static func GetSortOrderLocKey(order: flibSortOrder) -> CName {
    switch order {
      case flibSortOrder.Timestamp:
        return n"UI-Labels-Time";
      case flibSortOrder.Name:
        return n"UI-Sorting-Name";
      case flibSortOrder.Difficulty:
        return n"UI-ResourceExports-Threat";
      default:
        // Shouldn't ever hit this, but the scripting runtime
        // supports undefined values for enums so ¯\_(ツ)_/¯
        return n"UI-Sorting-Default";
    }
  }

  /// Returns a (hopefully) localized string of the sorting order
  /// For example: `flibSortOrder.Timestamp` will return "Sorting: New Items"
  public static func GetSortOrderButtonHint(order: flibSortOrder) -> String {
    // Took a while to find a lockey that said anything related to sorting
    // This one just says "Sorting" in lang_en
    let sortLabel = GetLocalizedTextByKey(n"Story-base-gameplay-gui-fullscreen-inventory-backpack-_localizationString0");
    let orderStr = GetLocalizedTextByKey(flibSortingUtils.GetSortOrderLocKey(order));

    return sortLabel + ": " + orderStr;
  }
}
