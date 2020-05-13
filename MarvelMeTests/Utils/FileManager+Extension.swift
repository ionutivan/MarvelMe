//
//  FileManager+Extension.swift
//  MarvelMeTests
//
//  Created by Ionut Ivan on 13/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import Foundation

extension FileManager {
  static func readJson(forResource fileName: String, bundle: Bundle) -> Data? {
    if let path = bundle.path(forResource: fileName, ofType: "json") {
      do {
          let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
          return data
      } catch {
          // handle error
      }
    }
    
    return nil
  }
}
