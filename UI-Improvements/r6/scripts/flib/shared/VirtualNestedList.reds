/** @section SortItem() Logic

The logic used in the `VirtualNestedListDataView.SortItem()` method is as follows:
 1. `PreSortItems()`
 2. Sort by `VirutalNestedListData.m_level` (which controls the grouping of subitems)
 3. Sort by `VirutalNestedListData.m_isHeader` (which determines if group header or content item)
 4. `SortItems()`

`PreSortItems()` has to maintain `m_level` contiguousness or it will break the ordering of nested
subitems, especially when opening and closing the parent contact widget. If `PreSortItems()` is used
correctly and keeps groups together, then `SortItems()` can be used to sort the content items within
a group on their own.
*/

/// @section VirtualNestedListDataView

@addField(VirtualNestedListDataView)
private let f_sortOrder: flibSortOrder;

@addMethod(VirtualNestedListDataView)
public final func flibSetSortOrder(order: flibSortOrder) -> Void {
  this.f_sortOrder = order;
  this.Sort();
}


/// @section VirtualNestedListController

/// A simple pass-through method to transfer the sort order
@addMethod(VirtualNestedListController)
public final func flibSetSortOrder(order: flibSortOrder) -> Void {
  this.m_dataView.flibSetSortOrder(order);
}
