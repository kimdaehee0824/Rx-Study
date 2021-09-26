import UIKit
import RxSwift

let bag = DisposeBag()
let numbers = [1, 2, 3, 4, 5]

// startWith
print("\n-------------------------\nstartWith\n")

Observable.from(numbers)
    .startWith(0)
    .startWith(-2)  // 마지막으로 나온 startWith가 처음으로 전달
// 가변 파라미터, Stack같은 느낌, 후입선출
    .subscribe { print($0) }
    .disposed(by: bag)

