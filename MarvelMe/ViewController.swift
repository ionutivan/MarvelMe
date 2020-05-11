//
//  ViewController.swift
//  MarvelMe
//
//  Created by Ionut Ivan on 07/05/2020.
//  Copyright © 2020 Ionut Ivan. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class ViewController: UIViewController {
  
  let service = MarvelService()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    
    // Do any additional setup after loading the view.
    
    service.getSuperheroes()
      .observeOn(MainScheduler.instance)
    .subscribe(onNext: { _ in
      print("onNext")
    }, onError: { e in print("onError \(e.localizedDescription)")}, onCompleted: { print("onCompleted")} , onDisposed: {print("onDisposed")})
      .disposed(by: disposeBag)
      
  }


}

