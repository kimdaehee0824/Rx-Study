import UIKit
import Foundation
import RxSwift

let disposeBag = DisposeBag()
let element = "📱🇰🇷"
let keyBoard =  "⌨️"
let iPhone = "📱"
let cdBox = "💽"
let products = ["📱", "⌚️", "🖱", "⌨️", "🖨"]

// Just
print("\n--------------------\nJust")

Observable.just(element)    // return Observable
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)


Observable.just([1, 2, 3, 4])   // 문자열을 그대로 방출. from 과 혼동 ㄴㄴ해
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)

// 문자열을 방출하는 Observable

/*
 public static func just(_ element: Element) -> Observable<Element> {
 Just(element: element)
 }
 */

// of
print("\n--------------------\nof")

Observable.of(iPhone, cdBox, keyBoard)  // 여러개 전달 가능
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)


Observable.of([1, 2], [3, 4], [5, 6])
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)

/*
 public static func of(_ elements: Element ..., scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<Element> {
 ObservableSequence(elements: elements, scheduler: scheduler)
 }
 */

// from
print("\n--------------------\nfrom")


Observable.from(products)   // products는 배열, of에서 사용 불가
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)
// 배열에 포함된 요소를 하나씩 방출

/*
 public static func from(_ array: [Element], scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<Element> {
 ObservableSequence(elements: array, scheduler: scheduler)
 }
 */

// range

print("\n--------------------\nrange")

Observable.range(start: 1, count: 5)    //시작부터 start count번까지 1씩 증가
    .subscribe { print($0)}
    .disposed(by: disposeBag)

/*
 public static func range(start: Element, count: Element, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<Element> {
 RangeProducer<Element>(start: start, count: count, scheduler: scheduler)
 }
 */

// generate
print("\n--------------------\ngenerate")

Observable.generate(initialState: 0, condition: {$0 <= 10}, iterate: {$0 + 2})
    .subscribe { print($0)}
    .disposed(by: disposeBag)

Observable.generate(initialState: iPhone, condition: {$0.count <= 10}, iterate: {
    $0.count.isMultiple(of: 2) ? $0 + iPhone : $0 + cdBox
})
    .subscribe { print($0)}
    .disposed(by: disposeBag)

/*
 initialState : 시작점, condition : true를 전달해야 작동, false 누르면 complete 후 종료
 iterate : 값을 바꾸는 거 (증가, 감소 등)
 
 */
/*
 public static func generate(initialState: Element, condition: @escaping (Element) throws -> Bool, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance, iterate: @escaping (Element) throws -> Element) -> Observable<Element> {
 Generate(initialState: initialState, condition: condition, iterate: iterate, resultSelector: { $0 }, scheduler: scheduler)
 }
 */
