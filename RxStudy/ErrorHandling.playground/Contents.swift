
import UIKit
import RxSwift

let bag = DisposeBag()

enum MyError: Error {
    case error
}

// catchError
print("\n----------catchError----------\n")

let subject = PublishSubject<Int>()
let recovery = PublishSubject<Int>()

subject
    .catch { _ in recovery }    // 예가 error를 recovery로 교체
    .subscribe { print($0) }
    .disposed(by: bag)

subject.onError(MyError.error)
subject.onNext(11)  // not working

recovery.onNext(22) // 예는 작동함, 새로운 요소 방출
recovery.onCompleted()


let subject1 = PublishSubject<Int>()
subject1
    .catchAndReturn(-1)
    .subscribe { print($0) }
    .disposed(by: bag)

subject1.onError(MyError.error) // catchAndReturn에 들어가 있는 걸로 바뀜
// Observable이 아닌 value이기 때문에 그냥 onCompleted 실행

/*
 발생한 종류에 상관없이 항상 동일한 error만 return
 클로져를 통해 error를 자유롭게 처리하는 장점이 있다.
 */
