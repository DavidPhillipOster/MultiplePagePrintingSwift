//  ModelItem.swift
// by David Phillip Oster 2021
// License: APACHE Version 2

import Foundation

/// The model data for one label.
struct ModelItem {
  let name: String
  let address: String
  var dictionary: [String:String] { return ["name": name, "address": address] }

  init(name: String, address: String) {
    self.name = name
    self.address = address
  }

  init(dictionary: [String:String]) {
    if let name = dictionary["name"] {
      self.name = name
    } else {
      self.name = ""
    }
    if let address = dictionary["address"] {
      self.address = address
    } else {
      self.address = ""
    }
  }

}
