//
//  ComicDetailTest.swift
//  MarvelMeTests
//
//  Created by Ionut Ivan on 13/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import XCTest
@testable import MarvelMe

class ComicDetailTest: XCTestCase {

  var decoder: JSONDecoder!

  override func setUp() {
    super.setUp()
    decoder = JSONDecoder()
  }
  
  override func tearDown() {
    decoder = nil
    super.tearDown()
  }
  
  func testParseEmptyComicDetail() {
      
    // giving empty data
    let data = Data()
    
    do {
      _ = try decoder.decode(ComicDetail.self, from: data)
      XCTAssertTrue(false, "There is no failure")
    } catch {
      XCTAssertTrue(true, "Expected failure when no data")
    }
  }
  
  func testParseComicDetail() {
      
    // giving a sample json file
    guard let data = FileManager.readJson(forResource: "sampleComicDetail", bundle: Bundle(for: ComicTest.self)) else {
      XCTAssert(false, "Can't get data from sampleComicDetail.json")
      return
    }
    
    do {
      let comicDetail = try decoder.decode(ComicDetail.self, from: data)
      XCTAssertNotNil(comicDetail.description)
    } catch {
      XCTAssertTrue(true, "Expected failure when no data")
    }
  }
  
  func testWrongKeyComicDetail() {
      
    // giving a wrong dictionary
    let dictionary = ["test" : 123 as AnyObject]
    
    guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
      XCTAssert(false, "Info can't be encoded")
      return
    }
    
    // expected to return error of converter
    do {
      _ = try decoder.decode(ComicDetail.self, from: jsonData)
      XCTAssertTrue(false, "There is no failure")
    } catch {
      XCTAssertTrue(true, "Expected failure when wrong keys")
    }

  }

}
