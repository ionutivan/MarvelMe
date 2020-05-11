//
//  SuperheroListViewModel.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 11/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


final class SuperheroListViewModel {

  private let api: MarvelService
   private let bag = DisposeBag()
   private(set) var input: Input
   private(set) var output: Output
   
   struct Input {
     let reload: PublishRelay<Bool>
   }
       
   struct Output {
     let superheroes: Driver<[Superhero]>
     let errorMessage: Driver<String>
     let selectSuperhero: PublishRelay<Superhero?>
   }
         
     
     
     init(api: MarvelService) {
       self.api = api
       let reloadRelay = PublishRelay<Bool>()
       let errorRelay = PublishRelay<String>()
       let selectSuperhero = PublishRelay<Superhero?>()
       let superheroes = reloadRelay
         .flatMapLatest({ _ in api.getSuperheroes() })
         .asDriver{ (error) -> Driver<[Superhero]> in
           errorRelay.accept((error as? ServiceError)?.localizedDescription ?? error.localizedDescription)
           return Driver.just([])
       }
       self.input = Input(reload: reloadRelay)
       self.output = Output(superheroes: superheroes,
                            errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"),
                            selectSuperhero: selectSuperhero)
     }
  
  func getSuperheroes() {
    input.reload.accept(true)
  }
}
