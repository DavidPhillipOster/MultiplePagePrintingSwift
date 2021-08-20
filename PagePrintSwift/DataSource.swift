//  DataSource.swift
// by David Phillip Oster 2021
// License: APACHE Version 2

import Cocoa

/// the viewModel for the tableviews.
class DataSource : NSObject, NSTableViewDataSource, NSTableViewDelegate {
  var model = Model()

  func numberOfRows(in tableView: NSTableView) -> Int {
    Int(ceil(Double(self.model.items.count)/Double(max(1, tableView.numberOfColumns))))
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    if let tableColumn = tableColumn,
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Label"), owner: tableView) as? LabelView,
        let columnIndex = Int(tableColumn.identifier.rawValue) {
      let index = row*tableView.numberOfColumns + columnIndex
      let count = self.model.items.count
      if index < count {
        cellView.objectValue = self.model.items[index]
      } else {
        cellView.objectValue = nil
      }
      return cellView
    }
    return nil
  }
}


