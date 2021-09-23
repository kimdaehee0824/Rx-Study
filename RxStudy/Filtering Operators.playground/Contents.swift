import UIKit
import RxSwift

let disposeBag = DisposeBag()
let fruits = ["🍏", "🍐", "🍊", "🍋", "🍌", "🍉"]
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

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

// filter
print("\n--------------------\nfilter\n")

Observable.from(numbers)
    .filter { $0.isMultiple(of: 2)}
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// skip
print("\n--------------------\nskip\n")

Observable.from(numbers)
    .skip(3)    // 선택된 숫자만큼 스킵
    .subscribe {print($0)}
    .disposed(by: disposeBag)

Observable.from(numbers)
    .skip { !$0.isMultiple(of: 2)}  // skipwhile는 사라짐
    .subscribe {print($0)}
    .disposed(by: disposeBag)


print("\n--------------------\nskipUntil\n")

let subject = PublishSubject<Int>()
let triger = PublishSubject<Int>()
subject.skip(until: triger)
    .subscribe {print($0)}
    .disposed(by: disposeBag)

subject.onNext(1)   // trigger가 요쇼 방출 안함
triger.onNext(0)    // No
subject.onNext(2)   // 이제부터 방출됨


