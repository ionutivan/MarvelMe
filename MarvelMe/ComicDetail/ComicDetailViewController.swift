import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class ComicDetailViewController: UIViewController {
  
  
  private var viewModel: ComicDetailViewModel!
  private var comic: Comic!
  
  private let disposeBag = DisposeBag()
  
  var nameLabel: UILabel = {
    let nameLabel = UILabel()
    nameLabel.numberOfLines = 0
    nameLabel.textColor = .white
    return nameLabel
  }()
  
  var thumbImage: UIImageView = {
    let thumbImage = UIImageView()
    thumbImage.translatesAutoresizingMaskIntoConstraints = false
    thumbImage.contentMode = .scaleAspectFill
    thumbImage.clipsToBounds = true
    return thumbImage
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [thumbImage, nameLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .top
    stackView.spacing = 16
    return stackView
  }()
  
  var descriptionLabel: UILabel = {
    let descriptionLabel = UILabel()
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textColor = .white
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    return descriptionLabel
  }()
  
  convenience init(viewModel: ComicDetailViewModel, comic: Comic) {
    self.init()
    self.comic = comic
  
    self.viewModel = viewModel
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    view.addSubview(stackView)
    view.addSubview(descriptionLabel)
    
    constraintInit()
    
    bindViews()
  }
  
  func constraintInit() {
    NSLayoutConstraint.activate([
      thumbImage.widthAnchor.constraint(equalToConstant: 56),
      thumbImage.heightAnchor.constraint(equalToConstant: 56),
      
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      stackView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16),
      
      descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    ])
  }
  
  func bindViews() {

    viewModel.output.name
      .drive(nameLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.output.imageStringURL
      .asObservable()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { imageURLString in
        if let urlString = imageURLString,
          let url = URL(string: urlString) {
          self.thumbImage.kf.setImage(with: url)
        } else {
          self.thumbImage.image = nil
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.output.description
      .drive(descriptionLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.input.comic.accept(comic)
  }
}
