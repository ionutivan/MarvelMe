//
//  MarvelService.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 07/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ServiceError: Error {
  case requestFailed
  case superheroParsingFailed
}

final class MarvelService {
  
  func getSuperheroes() -> Observable<[Superhero]> { //TODO replace URL
    let decoder = JSONDecoder()
    return buildRequest(url: URL(string: "")!)
      .map { data in
        do {
          let superheroes = try decoder.decode([Superhero].self, from: data)
          return superheroes
        } catch {
          throw ServiceError.superheroParsingFailed
        }
    }
  }
  
  func buildRequest(url: URL) -> Observable<Data> {
    let request: Observable<URLRequest> = Observable.create { observer in
      var request = URLRequest(url: url)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      observer.onNext(request)
      observer.onCompleted()
      
      return Disposables.create()
    }
    
    let session = URLSession.shared
    
    return request.flatMap() { request in
      return session.rx.response(request: request).map() { response, data in
        switch response.statusCode {
        case 200 ..< 300:
          return data
        default:
          throw ServiceError.requestFailed
        }
      }
    }
  }
}
