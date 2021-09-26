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

a.onNext(12)
b.onNext(32)
b.onNext(42)
c.onNext(62)

let a2 = BehaviorSubject(value: 1)
let b2 = BehaviorSubject(value: 2)

// flatMapFirst
print("\n--------------------\nflatMapFirst\n")

let subject3 = PublishSubject<BehaviorSubject<Int>>()
subject3
    .flatMapFirst { $0.asObservable() }  // asObservable는 subject를 Observable로 변환
    .subscribe { print($0) }
    .disposed(by: disposeBag)


subject3.onNext(b2) // 첫번째로 나오는 거만 나옴
subject3.onNext(a2)

a2.onNext(12)
b2.onNext(32)   // 예는 나옴, b2가 상속? 비슷한거를 하니까
b2.onNext(42)

// flatMapLatest
print("\n--------------------\nflatMapLatest\n")

let a3 = BehaviorSubject(value: 1)
let b3 = BehaviorSubject(value: 2)

//a3.onNext(12)
//b3.onNext(32)   // 예는 나옴, b2가 상속? 비슷한거를 하니까
//b3.onNext(42)

let subject4 = PublishSubject<BehaviorSubject<Int>>()
subject4
    .flatMapLatest { $0.asObservable() }  // asObservable는 subject를 Observable로 변환
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject4.onNext(b3)

b3.onNext(32)
b3.onNext(42)

subject4.onNext(a3) // 마지막에 나온 거를 보내기 떄문에 a3 이제 값니 변경되어도 방출되지 않음
a3.onNext(44)
b3.onNext(54)   // b3는 전달되지 않음

// scan
print("\n--------------------\nscan\n")

Observable.range(start: 0, count: 10)
    .scan(0, accumulator: +)    // 누적되어 더한 값을 전달함, 합산이나 감산을 할떼에 사용
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// buffer
print("\n--------------------\nbuffer\n")

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .buffer(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance)
    .take(6)    // 6개반 방출
    .subscribe { print($0) }
    .disposed(by: disposeBag)
/*
 timeSpan은 초마다 방출, 허나 count가 되면 시간이 지나지 않나도 방출
 count는 timeSpan이 졍과되지 않을 동안 수집함, 시간이 끝나면 방출하지 않음
 */
