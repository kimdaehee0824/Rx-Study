import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


// toArray
print("\n--------------------\ntoArray\n")

let subject = PublishSubject<Int>()

subject
    .toArray()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(3)
subject.onCompleted()   // 지금까지 onNext 받은 것들을 배열로 쏴준다.
// onCompleted 나오지 않으면 계속 실행되어 있음
