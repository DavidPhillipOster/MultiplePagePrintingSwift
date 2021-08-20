//  LabelView.swift
// by David Phillip Oster 2021
// License: APACHE Version 2

import Cocoa

/// The view for one label.
class LabelView : NSTableCellView {
  @IBOutlet var nameLabel : NSTextField?
  @IBOutlet var addressLabel : NSTextField?
  override var objectValue: Any? {
    didSet {
      if let item = objectValue as? ModelItem {
        nameLabel?.stringValue = item.name
        addressLabel?.stringValue = item.address
      } else  {
        nameLabel?.stringValue = ""
        addressLabel?.stringValue = ""
      }
    }
  }

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    if let nameLabel = nameLabel, let addressLabel = addressLabel {
      if !nameLabel.stringValue.isEmpty || !addressLabel.stringValue.isEmpty {
        bounds.frame()
      }
    }
  }
}

