//
//  MarvelMeTests.swift
//  MarvelMeTests
//
//  Created by Ionut Ivan on 07/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import MarvelMe

enum MockError: Error {
  case testing(String)
}

extension MockError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .testing(let message):
      return message
    }
  }
}

class MockMarvelService: MarvelServiceProtocol {
  var comics: [Comic]?
  var comicDetail: ComicDetail?
  
  func getComics(offset: Int, limit: Int) -> Observable<[Comic]> {
    if let comics = comics {
      return Observable.just(comics)
    } else {
      return Observable.error(MockError.testing("Test error get comics"))
    }
  }
  
  func getComicDetail(id: String) -> Observable<ComicDetail> {
    if let comicDetail = comicDetail {
      return Observable.just(comicDetail)
    } else {
      return Observable.error(MockError.testing("Test error get comic detail"))
    }
  }
}

class MarvelMeTests: XCTestCase {

  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!
  var service: MarvelServiceProtocol!
  var viewModelList: ComicListViewModel!
    
  override func setUp() {
    super.setUp()
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
    self.service = MockMarvelService()
    self.viewModelList = ComicListViewModel(api: service)
  }
  
  override func tearDown() {
    service = nil
    viewModelList = nil
    disposeBag = nil
    scheduler = nil
    super.tearDown()
  }
  
  func test_FetchComicsWithError() {
    //create testable observers
    let comics = scheduler.createObserver([Comic].self)
    let errorMessage = scheduler.createObserver(String.self)
    
    //giving a service with no comics
    (service as! MockMarvelService).comics = nil
    
    viewModelList.output.errorMessage
      .drive(errorMessage)
      .disposed(by: disposeBag)
    
    viewModelList.output.comics
      .drive(comics)
      .disposed(by: disposeBag)
    
    //when fetching the service
    scheduler.createColdObservable([.next(10, true)])
      .bind(to: viewModelList.input.reload)
    .disposed(by: disposeBag)
    
    scheduler.start()
    
    XCTAssertEqual(errorMessage.events, [.next(10, "Test error get comics")])
  }

}
