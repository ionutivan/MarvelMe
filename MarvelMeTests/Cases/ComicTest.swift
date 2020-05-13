//
//  ComicTest.swift
//  MarvelMeTests
//
//  Created by Ionut Ivan on 13/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import XCTest
@testable import MarvelMe

class ComicTest: XCTestCase {

  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testParseEmptyComic() {
      
      // giving empty data
      let data = Data()
      let decoder = JSONDecoder()
    do {
      _ = try decoder.decode([Comic].self, from: data)
      XCTAssertTrue(false, "There is no failure")
    } catch {
      XCTAssertTrue(true, "Expected failure when no data")
    }
  }
  
  func testParseComic() {
      
      // giving a sample json file
    guard let data = FileManager.readJson(forResource: "sample", bundle: Bundle(for: ComicTest.self)) else {
          XCTAssert(false, "Can't get data from sample.json")
          return
      }
      let decoder = JSONDecoder()
    
      do {
        let comics = try decoder.decode([Comic].self, from: data)
        XCTAssertEqual(comics.count, 20)
      } catch {
        XCTAssertTrue(true, "Expected failure when no data")
      }
  }
  
  func testWrongKeyComic() {
      
    // giving a wrong dictionary
    let dictionary = ["test" : 123 as AnyObject]
    
    guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
      XCTAssert(false, "Info can't be encoded")
      return
    }
    
    // expected to return error of converter
    let decoder = JSONDecoder()
    do {
      _ = try decoder.decode([Comic].self, from: jsonData)
      XCTAssertTrue(false, "There is no failure")
    } catch {
      XCTAssertTrue(true, "Expected failure when wrong keys")
    }

  }

}
