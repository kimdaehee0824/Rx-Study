import UIKit
import RxSwift

let bag = DisposeBag()
enum MyError : Error {
    case error
}

print("\n-------------------------\nPublishSubject\n")

//  PublishSubject

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
/*
 ------------------------------------------------------------------------
 */

print("\n-------------------------\nBehaviorSubject\n")

// BehaviorSubject

let p = PublishSubject<Int>()
p.subscribe { print(">> PublishSubject", $0) }
.disposed(by: bag)


let b = BehaviorSubject<Int>(value: 0)  // PublishSubject 와 달리 값이 전달됨(여기서는 int)
b.subscribe { print(">> BehaviorSubject", $0) }
.disposed(by: bag)

b.onNext(2)

b.subscribe { print(">> BehaviorSubject2", $0) }
    // 생성할 때에 값을 가지고 있다가 새로운 Observer에 저장함
    // 가장 최신 이밴트를 Observer에 저장함

//b.onCompleted() // 모든 subscribe에게 onCompleted 이밴트가 저장됨

b.onError(MyError.error)    //onCompleted와 마찬가지 전달되고 끝

b.subscribe { print(">> BehaviorSubject3", $0) }
.disposed(by: bag)  // 다른 곳에서 onCompleted를 저장하였기 때문에 onNext이밴트 저장 안됨

