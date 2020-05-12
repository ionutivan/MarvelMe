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
  
  private var compactConstraints: [NSLayoutConstraint] = []
  private var regularConstraints: [NSLayoutConstraint] = []
  private var sharedConstraints: [NSLayoutConstraint] = []
  
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
    sharedConstraints.append(contentsOf: [
      stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      stackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    ])
    
    compactConstraints.append(contentsOf: [
      comicImageView.widthAnchor.constraint(equalToConstant: 56),
      comicImageView.heightAnchor.constraint(equalToConstant: 56)
    ])
    
    regularConstraints.append(contentsOf: [
      comicImageView.widthAnchor.constraint(equalToConstant: 75),
      comicImageView.heightAnchor.constraint(equalToConstant: 75)
    ])
    
    NSLayoutConstraint.activate(sharedConstraints)
    layoutTrait(traitCollection: UIScreen.main.traitCollection)
  }
  
  func layoutTrait(traitCollection:UITraitCollection) {
    if (!sharedConstraints[0].isActive) {
      NSLayoutConstraint.activate(sharedConstraints)
    }
    
    if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
      if regularConstraints.count > 0 && regularConstraints[0].isActive {
        NSLayoutConstraint.deactivate(regularConstraints)
      }
        NSLayoutConstraint.activate(compactConstraints)
    } else {
        if compactConstraints.count > 0 && compactConstraints[0].isActive {
            NSLayoutConstraint.deactivate(compactConstraints)
        }
        NSLayoutConstraint.activate(regularConstraints)
    }
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    layoutTrait(traitCollection: traitCollection)
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
