import Foundation
import RxSwift
import RxCocoa

struct ComicDetailViewModel {
    
  private let api: MarvelService
  
    let input: Input
    let output: Output
    
    struct Input {
      let comic: PublishRelay<Comic>
    }
    
    struct Output {
      let name: Driver<String?>
      let imageStringURL: Driver<String?>
      let description: Driver<String?>
    }
    
    init(api: MarvelService) {
      self.api = api
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
      
      let description = sharedComic
        .filter{ $0.id != nil }
        .flatMap { comic in
          api.getComicDetail(id: String(comic.id!))
        }
      .map{ $0.description }
      .asDriver(onErrorJustReturn: "")
      
      self.input = Input(comic: selectComic)
      self.output = Output(name: name, imageStringURL: imageStringURL, description: description)

    }
}
