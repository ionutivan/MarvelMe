//
//  ComicCellViewModel.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 11/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import Foundation

struct ComicCellViewModel {
  let name: String?
  let imageURL: String?
  
  init(item: Comic) {
    self.name = item.title
    if let path = item.thumbnailPath, let imageExtension = item.thumbnailExtension {
      self.imageURL = path + "." + imageExtension
    } else {
      self.imageURL = nil
    }
  }
}
