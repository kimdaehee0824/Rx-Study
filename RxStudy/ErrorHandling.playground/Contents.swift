
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

// retry
print("\n----------retry----------\n")

var attempts = 1

let source = Observable<Int>.create { observer in
   let currentAttempts = attempts
   print("#\(currentAttempts) START")
   
   if attempts < 3 {
      observer.onError(MyError.error)
      attempts += 1
   }
   
   observer.onNext(1)
   observer.onNext(2)
   observer.onCompleted()
         
   return Disposables.create {
       print("#\(currentAttempts) END")  // 시작과 끝을 확인할 수 있는 코드
   }
}

source
    .retry(7)
// 현재는 7번 돈다. 마지막 이밴트도 실페한다면 error event를 전달. 성공한다면 바로 끝냄
// 중요!!!, 우리가 원하는 결과를 할라면 무조건 +1을 해야 한다. 첫번째 꺼는 카운트 안되니까
// 에지간하면 파라미터를 가지고 하도록 하자, 현재는 3번 카운트, 하지만 잘못하면 무한루프 쌉가능
   .subscribe { print($0) }
   .disposed(by: bag)

// retryWhen
print("\n----------retryWhen----------\n")

var attempts2 = 1

let source2 = Observable<Int>.create { observer in
   let currentAttempts = attempts
   print("#\(currentAttempts) START")
   
   if attempts2 < 3 {
      observer.onError(MyError.error)
      attempts2 += 1
   }
   
   observer.onNext(1)
   observer.onNext(2)
   observer.onCompleted()
         
   return Disposables.create {
       print("#\(currentAttempts) END")  // 시작과 끝을 확인할 수 있는 코드
   }
}

let trriger = PublishSubject<Void>()
// 예를 눌렀을 때에 작동하도록

source2
    .retry {_ in trriger }
   .subscribe { print($0) }
   .disposed(by: bag)

trriger.onNext(())
trriger.onNext(())  // 이때는 애러가 안나오고 정상 작동
