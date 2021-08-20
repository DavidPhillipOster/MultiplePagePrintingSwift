//  PrintTableView.swift
// by David Phillip Oster 2021
// License: APACHE Version 2

import Cocoa

/// subclass of NSTableView that implements inherited function of NSView for page layout.
class PrintTableView : NSTableView {
  var rowsPerPage:Int = 0
  var itemsPerPage:Int = 0
  var itemCount:Int = 0

  override func knowsPageRange(_ range: NSRangePointer) -> Bool {
    let isKnown = 0 < itemsPerPage
    if isKnown {
      let numPages = Int(ceil(Float(itemCount)/Float(itemsPerPage)))
      range.pointee = NSMakeRange(1, numPages)
    }
    return isKnown
  }

  override func rectForPage(_ page: Int) -> NSRect {
    let height = rowHeight*CGFloat(rowsPerPage)
    return NSMakeRect(0, height*CGFloat(page-1), self.frame.size.width, height)
  }
}

