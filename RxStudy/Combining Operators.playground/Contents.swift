import UIKit
import RxSwift

let bag = DisposeBag()
let numbers = [1, 2, 3, 4, 5]

enum MyError : Error {
    case error
}

// startWith
print("\n-------------------------\nstartWith\n")

Observable.from(numbers)
    .startWith(0)
    .startWith(-2)  // 마지막으로 나온 startWith가 처음으로 전달
// 가변 파라미터, Stack같은 느낌, 후입선출
    .subscribe { print($0) }
    .disposed(by: bag)

// combineLatest
print("\n-------------------------\ncombineLatest\n")

let languangs = PublishSubject<String>()
let greetings = PublishSubject<String>()

Observable.combineLatest(greetings, languangs) { rth, lth -> String in
    return "\(rth) \(lth)"
}
.subscribe { print($0) }
.disposed(by: bag)

greetings.onNext("hi")  // 이 상태에서는 languangs가 안나와서 방출이 안됨
languangs.onNext("world!")

greetings.onNext("Hello")   // 전에 꺼랑 알아서 조합해서 맘ㄴ들어줌
languangs.onNext("RxSwift!")

greetings.onCompleted()

greetings.onError(MyError.error)
languangs.onError(MyError.error)    // onError가 두개 모두 있어야 되네.....


languangs.onNext("SwiftUI!")    // languangs가 onCompleted되어있지 않기 때문에 next 전달됨

languangs.onCompleted() // 이러면 onCompleted됨

