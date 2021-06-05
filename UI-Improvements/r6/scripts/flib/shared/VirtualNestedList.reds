/** @file VirtualNestedList

Implementation of runtime custom sorting for classes than inherit from the VirtualNested* classes
*/

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

None of this complex logic would be required if groups and their contents were stored in actual data
structures, with group objects containing a list of content items

!!! warning Learn from my pain
    Having taken a deep dive into the "logic" and implementation of these poorly named classes,
    I have developed a deep hatred for whatever excuse for a developer birthed these horrors into
    the world and forced them upon their co-workers.
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
