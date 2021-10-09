//
//  ViewController.swift
//  RxStudy
//
//  Created by 김대희 on 2021/09/15.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class NSObjectRxViewController: UIViewController {

//    let bag = DisposeBag()

      let button = UIButton(type: .system)
      let label = UILabel()

      override func viewDidLoad() {
         super.viewDidLoad()

         Observable.just("Hello")
            .subscribe { print($0) }
            .disposed(by: rx.disposeBag)    // 기본

          button.rx.tap
            .map { "Hello" }
            .bind(to: label.rx.text)
            .disposed(by: rx.disposeBag)
      }
   }

class MyClass: HasDisposeBag {  // nsObject 상속 안됨. HasDisposeBag protocol 사용
      let bag = DisposeBag()

      func doSomething() {
         Observable.just("Hello")
         .subscribe { print($0) }
         .disposed(by: disposeBag)
      }}

