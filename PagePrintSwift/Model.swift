//  Model.swift
// by David Phillip Oster 2021
// License: APACHE Version 2

import Cocoa

/// The data model, and in dictioanry form, the file format, of this app.
class Model {
  var items: [ModelItem] = []
  var printInfo: NSPrintInfo?
  var dictionary: [String:Any] {
    var result:[String:Any] = [:]
    if let printInfo = self.printInfo {
      do {
        result["printInfo"] = try NSKeyedArchiver.archivedData(withRootObject:printInfo, requiringSecureCoding:true).base64EncodedString()
      } catch {
      }
    }
    var items:[[String:String]] = []
    for item in self.items {
      items.append(item.dictionary)
    }
    result["items"] = items
    return result
  }

  init() {
  }

  init(dictionary: [String:Any]) {
    if let printInfoString = dictionary["printInfo"] as? String, let printInfoData = Data(base64Encoded: printInfoString) {
      do {
        if let printInfo = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPrintInfo.self, from: printInfoData) {
          self.printInfo = printInfo
        }
      } catch {
      }
    }
    if let itemsData = dictionary["items"] as? [[String:String]] {
      var items: [ModelItem] = []
      for itemData in itemsData {
        items.append(ModelItem(dictionary: itemData))
      }
      self.items = items
    }
  }

}
