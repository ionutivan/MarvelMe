//
//  Superhero.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 07/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import Foundation

struct Superhero: Decodable {
  let title: String?
  let thumbnailPath: String?
  let thumbnailExtension: String?
  
  enum CodingKeys: String, CodingKey {
    case title
    case thumbnail
  }
  
  enum ThumbnailKeys: String, CodingKey {
    case path
    case imageExtension = "extension"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    title = try values.decode(String.self, forKey: .title)
    let thumbnailInfo = try values.nestedContainer(keyedBy: ThumbnailKeys.self, forKey: .thumbnail)
    thumbnailPath = try thumbnailInfo.decode(String.self, forKey: .path)
    thumbnailExtension = try thumbnailInfo.decode(String.self, forKey: .imageExtension)
  }
}

struct MainData: Decodable {
  let superheroes: [Superhero]?
  let count: Int?
  let offset: Int?
  let total: Int?
  
  enum CodingKeys: String, CodingKey {
    case data
  }
  
  enum PaginationKeys: String, CodingKey {
    case offset
    case total
    case count
    case results
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let mainInfo = try values.nestedContainer(keyedBy: PaginationKeys.self, forKey: .data)
    superheroes = try mainInfo.decode([Superhero].self, forKey: .results)
    count = try mainInfo.decode(Int.self, forKey: .count)
    offset = try mainInfo.decode(Int.self, forKey: .offset)
    total = try mainInfo.decode(Int.self, forKey: .total)
  }
}
