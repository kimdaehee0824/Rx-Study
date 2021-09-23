import UIKit
import RxSwift

let disposeBag = DisposeBag()
let fruits = ["🍏", "🍐", "🍊", "🍋", "🍌", "🍉"]
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 7, 7, ]

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


// take
print("\n--------------------\ntake\n")

Observable.from(numbers)
    .take(5)     // next 이밴트에만 영향, 나머지는 영향을 주지 낳음
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// takeWhile

Observable.from(numbers)
    .takeWhile { !$0.isMultiple(of: 2)} // takeWhile 권장하지 않음
// 홀수가 나오고는 있지만 방출되지는 않음
// 예가 false를 리턴하면 더이상 방출하지 않음, 이후 Completed, Error event만 전달
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// takeUntil

let subject2 = PublishSubject<Int>()
let triger2 = PublishSubject<Int>()

subject2.take(until: triger2)
    .subscribe {print($0)}
    .disposed(by: disposeBag)

subject2.onNext(1)
triger2.onNext(0)   // 요소를 방출하면 completed 방출됨

// single
print("\n--------------------\nsingle\n")

Observable.just(1)
    .single()   // 예는 하나만 방출됨 고로 completed
    .subscribe {print($0)}
    .disposed(by: disposeBag)

Observable.from(numbers)
    .single()   // 예는 문자열임, 고로 Error messaage 나옴, 방출은 하나만 됨
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// 이런 방법도 있음
Observable.from(numbers)
    .single { $0 == 3 } // 예는 애러가 안뜨네??
    .subscribe {print($0)}
    .disposed(by: disposeBag)

let subject3 = PublishSubject<Int>()
subject3.single()
    .subscribe {print($0)}
    .disposed(by: disposeBag)

subject3.onNext(100)
subject3.onNext(200)    // 이미 하나의 onNext가 전달되어 Error message가 나옴

// distinctUntilChanged
print("\n--------------------\nsingle\n")

Observable.from(numbers)
    .distinctUntilChanged() // 전 배열과 비교해 같으면 무시.
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// 이거는 좀 별로인듯

