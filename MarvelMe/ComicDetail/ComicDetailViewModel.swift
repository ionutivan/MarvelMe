//
//  ComicDetailViewModel.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 11/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ComicDetailViewModel {
    
    private static var isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private static var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    let input: Input
    let output: Output
    
    struct Input {
        let comic: PublishRelay<Comic>
    }
    
    struct Output {
      let name: Driver<String?>
      let imageStringURL: Driver<String?>
    }
    
    init() {

      let selectComic = PublishRelay<Comic>()
        
      let sharedComic = selectComic.share()
      
      let name = sharedComic
        .map { $0.title }
        .asDriver(onErrorJustReturn: nil)
      
      let thumb = sharedComic.compactMap{ $0.thumbnailPath }
      let ext = sharedComic.compactMap{ $0.thumbnailExtension }
      
      let imageStringURL = Observable.zip(thumb, ext)
        .map { $0.0 + "." + $0.1 }
        .asDriver(onErrorJustReturn: nil)
      
      self.input = Input(comic: selectComic)
      self.output = Output(name: name, imageStringURL: imageStringURL)

    }
}
