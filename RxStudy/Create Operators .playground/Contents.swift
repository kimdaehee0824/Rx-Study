import UIKit
import Foundation
import RxSwift

let disposeBag = DisposeBag()
let element = "📱🇰🇷"
let keyBoard =  "⌨️"
let iPhone = "📱"
let cdBox = "💽"
let products = ["📱", "⌚️", "🖱", "⌨️", "🖨"]
let fruits = ["🍏", "🍐", "🍊", "🍋", "🍌", "🍉"]
var flag = true

enum MyError : Error {
    case error
}

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


// from
print("\n--------------------\nfrom")


Observable.from(products)   // products는 배열, of에서 사용 불가
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)
// 배열에 포함된 요소를 하나씩 방출



// range

print("\n--------------------\nrange")

Observable.range(start: 1, count: 5)    //시작부터 start count번까지 1씩 증가
    .subscribe { print($0)}
    .disposed(by: disposeBag)



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


// repeatElement

let seven = Int(7)
print("\n--------------------\nrepeatElement")

Observable.repeatElement(element)   // 반복적으로 방출하는 Observable 반환
    .take(seven)    // take로 감싸주지 않는다면 무한루프 돕니다. 조심하세요!!
    .subscribe { print($0)}
    .disposed(by: disposeBag)

// 무한정 도는 반복루프

// deferred
// 결과에 따라 방출되는 값이 달라짐

print("\n--------------------\ndeferred")

let factory : Observable<String> = Observable.deferred {    // 타입 추론이 안되면 <String>
    flag.toggle()   // 방향 뒤집기
    if flag {
        return Observable.from(products)
    } else {
        return Observable.from(fruits)
    }
}
factory // 1
    .subscribe { print($0)}
    .disposed(by: disposeBag)

factory // 2
    .subscribe { print($0)}
    .disposed(by: disposeBag)


// create
print("\n--------------------\ncreate")

let create = Observable<String>.create { (observer) -> Disposable in
    
    guard let url = URL(string: "https://www.a.com") else {
        observer.onError(MyError.error)
        return Disposables.create() // Disposables 리턴해야 됨
        // Disposable은 Disposables 리턴, 후 create() 붙여서 리턴
    }   // Observer 로 전달된 파라미터
    
    guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        observer.onError(MyError.error)
        return Disposables.create() // Disposables 리턴해야 됨
    }
    // 문자열 방출
    observer.onNext(html)
    observer.onCompleted()  // 이거 전에 onNext event를 전달해야함
    return Disposables.create() // 정상적으로  종료
}
create
.subscribe { print($0)}
.disposed(by: disposeBag)

// 현재 주소를 정획하게 적지 않아 error message 출력됨

// empty
print("\n--------------------\nempty")

Observable<Void>.empty()    // 예는 파라미터가 없음
    .subscribe { print($0)}
    .disposed(by: disposeBag)   // completed event만 전달되고 끝남
/*
 observer 가 아무것도 안하고 종료해야 할 때에 자주 사용
 */

// error
print("\n--------------------\nerrror")

Observable<Void>.error(MyError.error)    // 예는 파라미터가 없음
    .subscribe { print($0)}
    .disposed(by: disposeBag)   // error event만 전달되고 끝남
