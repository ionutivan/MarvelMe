//
//  ComicListViewController.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 11/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ComicListViewController: UIViewController {
    
  lazy var tableView: UITableView! = {
    let tableView = UITableView()
    tableView.register(ComicListCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
    tableView.separatorColor = .gray
    tableView.separatorInset = .zero
    tableView.refreshControl = refreshControl
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

    let refreshControl = UIRefreshControl()
    let cellIdentifier = "ComicListCell"
    
    private var viewModel: ComicListViewModel!
    private let disposeBag = DisposeBag()
    let api = MarvelService()
    convenience init(viewModel: ComicListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      view.addSubview(tableView)
      
      constraintInit()
        
      bindViews()
      
      viewModel.getComics()
    }
  
  func constraintInit() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
    ])
  }
    
    func bindViews() {
        
      viewModel.output.comics
        .drive(self.tableView.rx.items(cellIdentifier: cellIdentifier, cellType: ComicListCell.self)) { (row, item, cell) in
          let viewModel = ComicCellViewModel(item: item)
          cell.viewModel = viewModel
          }
          .disposed(by: disposeBag)
        
      viewModel.output.errorMessage
        .asObservable()
        .subscribe(onNext:  { [weak self] errorMessage in
                guard let strongSelf = self else { return }
                strongSelf.showError(errorMessage)
            })
            .disposed(by: disposeBag)
            
        tableView.rx.modelSelected(Comic.self)
            .subscribe(onNext: { [weak self] model in
                
              self?.viewModel.output.selectComic.accept(model)
              if let selectedIndexPath = self?.tableView.indexPathForSelectedRow {
                self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
              }
            }
        )
            .disposed(by: disposeBag)
      
      refreshControl.rx.controlEvent(.valueChanged)
        .delay(.seconds(3), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] in
          self?.refreshControl.endRefreshing()
          self?.viewModel.input.reload.accept(true)
        })
        .disposed(by: disposeBag)
      
      
  
    }
    
    func showError(_ errorMessage: String) {
        let controller = UIAlertController(title: "An error occured", message: errorMessage, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
}
