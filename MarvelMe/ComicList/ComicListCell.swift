//
//  ComicListCell.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 11/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import UIKit
import Kingfisher

class ComicListCell: UITableViewCell {
  
  var viewModel: ComicCellViewModel? {
    didSet {
      bindViewModel()
    }
  }
    
  var comicNameLabel: UILabel = {
    let pilotNameLabel = UILabel()
    pilotNameLabel.textColor = .black
    pilotNameLabel.numberOfLines = 0
    pilotNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    pilotNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return pilotNameLabel
  }()
  
  var comicImageView: UIImageView = {
    let pilotImageView = UIImageView(frame: .zero)
    pilotImageView.contentMode = .scaleAspectFill
    pilotImageView.translatesAutoresizingMaskIntoConstraints = false
    pilotImageView.clipsToBounds = true
    return pilotImageView
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [self.comicImageView, self.comicNameLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 8
    return stackView
  }()
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  func setupView() {
    backgroundColor = .clear
    contentView.addSubview(stackView)
    setupLayout()
  }
  
  func setupLayout() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      stackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    ])
    
    NSLayoutConstraint.activate([
      comicImageView.widthAnchor.constraint(equalToConstant: 56),
      comicImageView.heightAnchor.constraint(equalToConstant: 56),
      ])
  }
  
  func bindViewModel() {
    if let viewModel = viewModel {
      
      comicNameLabel.text = viewModel.name

      if let urlString = viewModel.imageURL,
        let url = URL(string: urlString) {
        comicImageView.kf.setImage(with: url)
      }
    }
    
  }
}
