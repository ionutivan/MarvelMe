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
import CryptoSwift

//let baseURL = "developer.marvel.com"
let baseURL = "http://gateway.marvel.com/v1/public"
let publicKey = "0dac58e8603e1a946fc868e4af83d17a"
let privateKey = "9b085aedb6bc43560a546a594ae23ac6fd377212"

enum ServiceError: Error {
  case requestFailed
  case comicsParsingFailed
  case noResults
  case comicDetailParsingFailed
  
  var localizedDescription: String {
    switch self {
    case .requestFailed:
      return "requestFailed"
    case .comicsParsingFailed:
      return "comicsParsingFailed"
    case .noResults:
      return "noResults"
    case .comicDetailParsingFailed:
      return "comicDetailParsingFailed"
    }
  }
}

protocol MarvelServiceProtocol {
  func getComics(offset: Int, limit: Int) -> Observable<[Comic]>
  func getComicDetail(id: String) -> Observable<ComicDetail>
}

final class MarvelService: MarvelServiceProtocol {
  
  func getComicDetail(id: String) -> Observable<ComicDetail> {
    let comicDetailURL = baseURL + "/comics" + "/\(id)"
    return buildRequest(url: URL(string: comicDetailURL)!, offset: 0, limit: 1)
      .map { data in
        let decoder = JSONDecoder()
        do {
          let mainData = try decoder.decode(ComicDetail.self, from: data)
          return mainData
        } catch {
          throw ServiceError.comicDetailParsingFailed
        }
    }
  }
  
  func getComics(offset: Int = 0, limit: Int = 20) -> Observable<[Comic]> {
    let comicsURL = baseURL + "/comics"
    return buildRequest(url: URL(string: comicsURL)!, offset: offset, limit: limit)
      .map { data in
        let decoder = JSONDecoder()
        do {
          let mainData = try decoder.decode(MainData.self, from: data)
          if let comics = mainData.comics {
            return comics
          } else {
            throw ServiceError.noResults
          }
        } catch {
          throw ServiceError.comicsParsingFailed
        }
    }
  }
  
  private func buildRequest(url: URL, offset: Int = 0, limit: Int = 1) -> Observable<Data> {
    let request: Observable<URLRequest> = Observable.create() { observer in
      let ts = Int(Date().timeIntervalSince1970)
      let hash = "\(ts)\(privateKey)\(publicKey)".md5()
      let queryItems = [URLQueryItem(name: "ts", value: "\(ts)"),
                        URLQueryItem(name: "apikey", value: publicKey),
                        URLQueryItem(name: "hash", value: hash),
                        URLQueryItem(name: "offset", value: String(offset)),
                        URLQueryItem(name: "limit", value: String(limit))]
      var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
      urlComps.queryItems = queryItems
      var request = URLRequest(url: urlComps.url!)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      observer.onNext(request)
      observer.onCompleted()
      
      return Disposables.create()
    }
    
    let session = URLSession.shared
    
    return request.flatMap() { req in
      
      return session.rx.response(request: req).map() { response, data in
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
