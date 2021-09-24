import UIKit
import RxSwift

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let skills = ["Swift", "SwiftUI", "RxSwift"]

// toArray
print("\n--------------------\ntoArray\n")

let subject = PublishSubject<Int>()

subject
    .toArray()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(3)
subject.onCompleted()   // 지금까지 onNext 받은 것들을 배열로 쏴준다.
// onCompleted 나오지 않으면 계속 실행되어 있음

// map
print("\n--------------------\nmap\n")

Observable.from(skills)
//    .map { "hello \($0)" }
    .map { $0.count }   // array의
    .subscribe { print($0)}
    .disposed(by: disposeBag)

// 원본 옵저버블이 방출하는 요소를 대상으로 함수를 실행하고 결과를 새로운 옵저버블로 리턴하는 map

// flatMap
print("\n--------------------\nflatMap\n")

let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)
let c = BehaviorSubject(value: 4)

let subject2 = PublishSubject<BehaviorSubject<Int>>()
subject2
    .flatMap { $0.asObservable() }  // asObservable는 subject를 Observable로 변환
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject2.onNext(a)
subject2.onNext(b)  // 값이 바뀌면 자동으로 변경
subject2.onNext(c)
// network 연결할 떄 자주 사용
