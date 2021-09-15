import UIKit
import RxSwift

let bag = DisposeBag()

//  PublishSubject

enum MyError : Error {
    case error
}

let subject = PublishSubject<String>()  // subject 가 실행되면 비어 있음(초기)
subject.onNext("hello??")

let o1 = subject.subscribe { print(">> 1", $0) }
o1.disposed(by: bag)
    // 구독 이후에 전달되는 이밴트만 전달(PublishSubject)

subject.onNext("RxSwift")

print("\n-------------------------\n")
let o2 = subject.subscribe { print(">> 2", $0) }
o2.disposed(by: bag)

subject.onNext("아니??")
//subject.onCompleted()

subject.onError(MyError.error)

let o3 = subject.subscribe { print(">> 3", $0) }
o3.disposed(by: bag)

subject.onNext("ohhhhh")    // onCompleted 이후 o3도 Completed
    // error 사용시 completed와 마찬가지로 새로운 구독자항태도 전달됨

/*
 PublishSubject는 이밴트가 전달되면 즉시 전달됨
 최초와 첫번째 사이 이밴츠는 사라짐
 */



