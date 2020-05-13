import Foundation
import RxSwift
import RxCocoa


final class ComicListViewModel {

  private let api: MarvelServiceProtocol
   private let bag = DisposeBag()
   private(set) var input: Input
   private(set) var output: Output
   
   struct Input {
     let reload: PublishRelay<Bool>
   }
       
   struct Output {
     let comics: Driver<[Comic]>
     let errorMessage: Driver<String>
     let selectComic: PublishRelay<Comic?>
   }
  
  init(api: MarvelServiceProtocol) {
   self.api = api
   let reloadRelay = PublishRelay<Bool>()
   let errorRelay = PublishRelay<String>()
   let selectComic = PublishRelay<Comic?>()
   let comics = reloadRelay
    .flatMapLatest({ _ in api.getComics(offset: 0, limit: 20) })
    .asDriver{ (error) -> Driver<[Comic]> in
      
      print(error.localizedDescription)
       errorRelay.accept((error as? ServiceError)?.localizedDescription ?? error.localizedDescription)
       return Driver.just([])
    }
    
   self.input = Input(reload: reloadRelay)
   self.output = Output(comics: comics,
                        errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"),
                        selectComic: selectComic)
  }
  
  func getComics() {
    input.reload.accept(true)
  }
}
