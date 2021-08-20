//  PrintBoss.swift
// by David Phillip Oster 2021
// License: APACHE Version 2

import Cocoa

/// Given a datasource and a printInfo, return an appropriate PrintTableView
class PrintBoss {
  var dataSource : DataSource?
  var printInfo : NSPrintInfo?
  var printableView : NSView {
    set {
      hiddenView = newValue
    }
    get {
      if nil != hiddenView {
        return hiddenView!
      }
      assert(nil != printInfo, "needs printInfo")
      assert(nil != dataSource, "needs dataSource")
      guard let dataSource = dataSource,
        let printInfo = printInfo,
        let nib = NSNib(nibNamed: "LabelView", bundle: nil) else { return NSView() }
      let paperSize = printInfo.paperSize
      var pageContentSize = NSMakeSize(paperSize.width - printInfo.leftMargin - printInfo.rightMargin,
                                        paperSize.height - printInfo.topMargin - printInfo.bottomMargin)
      pageContentSize.width /= printInfo.scalingFactor
      pageContentSize.height /= printInfo.scalingFactor
      let printPageFrame = CGRect(x: 0, y: 0, width: pageContentSize.width, height: pageContentSize.height)
      let tableView = PrintTableView.init(frame: printPageFrame)

      var bounds = tableView.bounds
      bounds.size.width /= printInfo.scalingFactor
      bounds.size.height /= printInfo.scalingFactor
      tableView.bounds = bounds


      tableView.register(nib, forIdentifier: NSUserInterfaceItemIdentifier("Label"))

      var cellView: NSTableCellView?
      var topLevelObjects: NSArray?
      if nib.instantiate(withOwner: self, topLevelObjects: &topLevelObjects),
        let topLevelObjects = topLevelObjects {
        for obj in topLevelObjects {
          if let cell = obj as? NSTableCellView {
            cellView = cell
            break
          }
        }
      }
      assert(nil != cellView, "needs label from nib")
      guard let cellView = cellView else { return tableView }
      let columnWidth = cellView.bounds.size.width
      let numColumns = max(1, Int(floor(pageContentSize.width/columnWidth)))
      for i in 0..<numColumns {
        let column = NSTableColumn.init(identifier: NSUserInterfaceItemIdentifier("\(i)"))
        column.width = columnWidth
        column.resizingMask = []
        tableView.addTableColumn(column)
      }
      tableView.intercellSpacing = .zero
      tableView.rowHeight = cellView.bounds.size.height
      tableView.rowsPerPage = max(1, Int(floor(pageContentSize.height/tableView.rowHeight)))
      tableView.itemCount = dataSource.model.items.count
      tableView.itemsPerPage = tableView.rowsPerPage*numColumns
      tableView.columnAutoresizingStyle = .noColumnAutoresizing
      tableView.allowsColumnSelection = false
      tableView.allowsColumnResizing = false
      tableView.selectionHighlightStyle = .none
      tableView.allowsEmptySelection = true
      if #available(macOS 11.0, *) {
        // Avoid Big Sur's default horizontal padding
        tableView.style = .plain
      }
      tableView.dataSource = dataSource
      tableView.delegate = dataSource
      tableView.reloadData()

      hiddenView = tableView
      return tableView
    }
  }
  var hiddenView : NSView?
}

