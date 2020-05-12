//
//  ComicDetail.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 12/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import Foundation

struct ComicDetail: Decodable {
  let description: String?
  
  enum CodingKeys: String, CodingKey {
    case description
  }
  
  enum MainContainerKeys: String, CodingKey {
    case data
  }
  
  enum InsideMainContainerKeys: String, CodingKey {
    case results
  }
  
  enum ComicDetailKeys: String, CodingKey {
    case description
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: MainContainerKeys.self)
    let dataContainer = try values.nestedContainer(keyedBy: InsideMainContainerKeys.self, forKey: .data)
    var results = try dataContainer.nestedUnkeyedContainer(forKey: .results)
    let result = try results.nestedContainer(keyedBy: ComicDetailKeys.self)
    let description = try result.decode(String.self, forKey: .description)
    self.description = description
  }
}
