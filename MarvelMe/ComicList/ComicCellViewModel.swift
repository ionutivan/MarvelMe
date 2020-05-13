import Foundation

struct ComicCellViewModel {
  let name: String?
  let imageURL: String?
  
  init(item: Comic) {
    self.name = item.title
    if let path = item.thumbnailPath, let imageExtension = item.thumbnailExtension {
      self.imageURL = path + "." + imageExtension
    } else {
      self.imageURL = nil
    }
  }
}
