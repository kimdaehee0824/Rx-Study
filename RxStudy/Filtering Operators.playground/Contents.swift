import UIKit
import RxSwift

let disposeBag = DisposeBag()
let fruits = ["🍏", "🍐", "🍊", "🍋", "🍌", "🍉"]

// ignoreElements
print("\n--------------------\nignoreElements\n")

Observable.from(fruits)
    .ignoreElements()
// next 같은 거는 전달되지 않고 Completed, Error 메세지가 전딜됨
// next가 방출은 되고 있지만 전달되지 않음
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// element
print("\n--------------------\nelementAt\n")

Observable.from(fruits)
    .element(at: 2) // 현재는 element 권장
// 정수를 받아 Observable 리턴
// 제한적으로 방출
    .subscribe {print($0)}
    .disposed(by: disposeBag)
