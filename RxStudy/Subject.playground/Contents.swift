import UIKit
import RxSwift
import RxCocoa

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

// ReplaySubject
print("\n-------------------------\nReplaySubject\n")

let rs = ReplaySubject<Int>.create(bufferSize: 3)   //3개의 이밴트를 저장하는 버퍼 생성

(1 ... 10).forEach { rs.onNext($0) }    // 10개의 이밴트를 생성
rs.subscribe { print(">> Observer1", $0) }  // bufferSize가 3개이므로 뒤에 2개를 저장
.disposed(by: bag)

rs.subscribe { print(">> Observer2", $0) }  // 동일하게 저장
.disposed(by: bag)

rs.onNext(11)   // 즉시 저장, buffer의 가장 오래된 이밴트가 사라짐

rs.subscribe { print(">> Observer3", $0) }
.disposed(by: bag)
    // ReplaySubject는 가장 최신의 buffer만큼을 저장, buffer는 메모리에 저장되므로 관리 필요

rs.onCompleted()    //모두 onCompleted를 저장

rs.subscribe { print(">> Observer4", $0) }
.disposed(by: bag)
    // buffer에 저장된 이밴트를 수행하고 onCompleted를 수행
    // onError도 마찬가지

    // AsyncSubject
print("\n-------------------------\nAsyncSubject\n")

let asubject = AsyncSubject<Int>()

asubject
    .subscribe { print($0) }
    .disposed(by: bag)
                            
asubject.onNext(1)
    //AsyncSubject는 onCompleted가 나오지 않아 전달 안됨

asubject.onNext(2)
asubject.onNext(3)
asubject.onCompleted()  //가장 최근의 Next 이밴트가 저장
    //구독 종료
/*
 AsyncSubject는 가장 최신의 next 이밴트를 저장하고 Completed를 출력
 Next 이밴트가 없을 때에는 Completed만 전달
 error 이밴트를 지정하면 next 전갈 안되고 에러만 표시
 */


    // Relay
    // import RxCocoa

print("\n-------------------------\nReplaySubject\n")

let pelay = PublishRelay<Int>()
pelay.subscribe { print("1 : \($0)") }
.disposed(by: bag)

pelay.accept(1) // Relay는 accept사용, onNext 사용 불가

let brelay = BehaviorRelay<Int>(value: 1)

brelay.accept(2)

brelay.subscribe { print("2 : \($0)") }
.disposed(by: bag)
    //가장 최근 accept가 전달

brelay.accept(3)    //바로 전달

print(brelay.value) // 3

