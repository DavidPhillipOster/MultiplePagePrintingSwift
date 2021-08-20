//  Document.swift
// by David Phillip Oster 2021
// License: APACHE Version 2

import Cocoa

class Document: NSDocument {
  var model:Model = Model()
  @IBOutlet var tableView: NSTableView!
  @IBOutlet var dataSource: DataSource!

  /// non-nil during printing
  var printBoss: PrintBoss?

  /// true while the user is dragging the resize handles.
  var inLiveResize = false

  override var printInfo: NSPrintInfo {
    get { return super.printInfo}
    set {
      super.printInfo = newValue
      self.model.printInfo = newValue
    }
  }

  override init() {
    super.init()

// This block creates a dummy document with a thousand labels.
#if true
    var items: [ModelItem] = []
    for i in 1...1000 {
      let name = "name: \(i)"
      let addr = "address: \(i)"
      let item = ModelItem(name: name, address: addr)
      items.append(item)
    }
    model.items = items
#endif
   }

  override class var autosavesInPlace: Bool {
    return true
  }

  override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
    super.windowControllerDidLoadNib(windowController)
    dataSource.model = model
    let nib = NSNib(nibNamed: "LabelView", bundle: nil)
    tableView.register(nib, forIdentifier: NSUserInterfaceItemIdentifier("Label"))
    if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Label"), owner: tableView) {
      tableView.rowHeight = cellView.bounds.size.height
      if let column = tableView.tableColumns.first {
        column.width = cellView.bounds.size.width
        column.maxWidth = cellView.bounds.size.width
        column.minWidth = cellView.bounds.size.width
        setupColumns()
      }
    }
  }

  func setupColumns(){
    if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Label"), owner: tableView) {
      if let tableFrame = self.tableView?.superview?.frame {
        let frame = cellView.frame
        let numColumns = max(1, Int(tableFrame.size.width/frame.size.width))
        self.setNumberOfColumns(numColumns)
      }
    }
  }

  func setNumberOfColumns(_ n:Int){
    if let tableView = tableView {
      if n < tableView.tableColumns.count {
        while n < tableView.tableColumns.count {
          tableView.removeTableColumn(tableView.tableColumns.last!)
        }
        tableView.reloadData()
      } else if tableView.tableColumns.count < n {
        if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Label"), owner: tableView) {
          while tableView.tableColumns.count < n {
            let s = "\(tableView.tableColumns.count)"
            let column = NSTableColumn.init(identifier: NSUserInterfaceItemIdentifier(s))
            column.width = cellView.bounds.size.width
            column.maxWidth = cellView.bounds.size.width
            column.minWidth = cellView.bounds.size.width
            tableView.addTableColumn(column)
          }
          tableView.reloadData()
        }
      }
    }
  }

  @objc func windowDidResize( _ notification : NSNotification) {
    if !inLiveResize {
      setupColumns()
    }
  }

  @objc func windowWillStartLiveResize( _ notification : NSNotification) {
    inLiveResize = true
  }

  @objc func windowDidEndLiveResize( _ notification : NSNotification) {
    inLiveResize = false
    setupColumns()
  }

  override var windowNibName: NSNib.Name? {
    // Returns the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
    return NSNib.Name("Document")
  }

  override func data(ofType typeName: String) throws -> Data {
    return try JSONSerialization.data(withJSONObject: model.dictionary, options: [])
  }

  override func read(from data: Data, ofType typeName: String) throws {
    if let modelDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
      self.model = Model(dictionary: modelDict)
      if let printInfo = self.model.printInfo {
        self.printInfo = printInfo
      }
    }
  }

  @objc func document(_ : NSDocument, didPrint : Bool, contextInfo : Any?) {
    printBoss = nil
  }

  override func printDocument(_ sender: Any?) {
    print(withSettings: [:], showPrintPanel: true, delegate: self, didPrint: #selector(document(_:didPrint:contextInfo:)), contextInfo: nil)
  }

  override func printOperation(withSettings printSettings: [NSPrintInfo.AttributeKey : Any]) throws -> NSPrintOperation {
    printInfo.isHorizontallyCentered = false
    printInfo.isVerticallyCentered = false
    let printBoss = PrintBoss()
    self.printBoss = printBoss
    printBoss.dataSource = dataSource
    printBoss.printInfo = printInfo
    model.printInfo = printInfo
    return NSPrintOperation(view: printBoss.printableView, printInfo: printInfo)
  }

}

