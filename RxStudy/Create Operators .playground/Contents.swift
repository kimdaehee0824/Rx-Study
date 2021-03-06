import UIKit
import Foundation
import RxSwift

let disposeBag = DisposeBag()
let element = "๐ฑ๐ฐ๐ท"
let keyBoard =  "โจ๏ธ"
let iPhone = "๐ฑ"
let cdBox = "๐ฝ"
let products = ["๐ฑ", "โ๏ธ", "๐ฑ", "โจ๏ธ", "๐จ"]
let fruits = ["๐", "๐", "๐", "๐", "๐", "๐"]
var flag = true

enum MyError : Error {
    case error
}

// Just
print("\n--------------------\nJust")

Observable.just(element)    // return Observable
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)


Observable.just([1, 2, 3, 4])   // ๋ฌธ์์ด์ ๊ทธ๋๋ก ๋ฐฉ์ถ. from ๊ณผ ํผ๋ ใดใดํด
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)

// ๋ฌธ์์ด์ ๋ฐฉ์ถํ๋ Observable

/*
 public static func just(_ element: Element) -> Observable<Element> {
 Just(element: element)
 }
 */

// of
print("\n--------------------\nof")

Observable.of(iPhone, cdBox, keyBoard)  // ์ฌ๋ฌ๊ฐ ์ ๋ฌ ๊ฐ๋ฅ
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)


Observable.of([1, 2], [3, 4], [5, 6])
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)


// from
print("\n--------------------\nfrom")


Observable.from(products)   // products๋ ๋ฐฐ์ด, of์์ ์ฌ์ฉ ๋ถ๊ฐ
    .subscribe { event in print(event)}
    .disposed(by: disposeBag)
// ๋ฐฐ์ด์ ํฌํจ๋ ์์๋ฅผ ํ๋์ฉ ๋ฐฉ์ถ



// range

print("\n--------------------\nrange")

Observable.range(start: 1, count: 5)    //์์๋ถํฐ start count๋ฒ๊น์ง 1์ฉ ์ฆ๊ฐ
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
 initialState : ์์์ , condition : true๋ฅผ ์ ๋ฌํด์ผ ์๋, false ๋๋ฅด๋ฉด complete ํ ์ข๋ฃ
 iterate : ๊ฐ์ ๋ฐ๊พธ๋ ๊ฑฐ (์ฆ๊ฐ, ๊ฐ์ ๋ฑ)
 
 */


// repeatElement

let seven = Int(7)
print("\n--------------------\nrepeatElement")

Observable.repeatElement(element)   // ๋ฐ๋ณต์ ์ผ๋ก ๋ฐฉ์ถํ๋ Observable ๋ฐํ
    .take(seven)    // take๋ก ๊ฐ์ธ์ฃผ์ง ์๋๋ค๋ฉด ๋ฌดํ๋ฃจํ ๋๋๋ค. ์กฐ์ฌํ์ธ์!!
    .subscribe { print($0)}
    .disposed(by: disposeBag)

// ๋ฌดํ์  ๋๋ ๋ฐ๋ณต๋ฃจํ

// deferred
// ๊ฒฐ๊ณผ์ ๋ฐ๋ผ ๋ฐฉ์ถ๋๋ ๊ฐ์ด ๋ฌ๋ผ์ง

print("\n--------------------\ndeferred")

let factory : Observable<String> = Observable.deferred {    // ํ์ ์ถ๋ก ์ด ์๋๋ฉด <String>
    flag.toggle()   // ๋ฐฉํฅ ๋ค์ง๊ธฐ
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
        return Disposables.create() // Disposables ๋ฆฌํดํด์ผ ๋จ
        // Disposable์ Disposables ๋ฆฌํด, ํ create() ๋ถ์ฌ์ ๋ฆฌํด
    }   // Observer ๋ก ์ ๋ฌ๋ ํ๋ผ๋ฏธํฐ
    
    guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        observer.onError(MyError.error)
        return Disposables.create() // Disposables ๋ฆฌํดํด์ผ ๋จ
    }
    // ๋ฌธ์์ด ๋ฐฉ์ถ
    observer.onNext(html)
    observer.onCompleted()  // ์ด๊ฑฐ ์ ์ onNext event๋ฅผ ์ ๋ฌํด์ผํจ
    return Disposables.create() // ์ ์์ ์ผ๋ก  ์ข๋ฃ
}
create
.subscribe { print($0)}
.disposed(by: disposeBag)

// ํ์ฌ ์ฃผ์๋ฅผ ์ ํํ๊ฒ ์ ์ง ์์ error message ์ถ๋ ฅ๋จ

// empty
print("\n--------------------\nempty")

Observable<Void>.empty()    // ์๋ ํ๋ผ๋ฏธํฐ๊ฐ ์์
    .subscribe { print($0)}
    .disposed(by: disposeBag)   // completed event๋ง ์ ๋ฌ๋๊ณ  ๋๋จ
/*
 observer ๊ฐ ์๋ฌด๊ฒ๋ ์ํ๊ณ  ์ข๋ฃํด์ผ ํ  ๋์ ์์ฃผ ์ฌ์ฉ
 */

// error
print("\n--------------------\nerrror")

Observable<Void>.error(MyError.error)    // ์๋ ํ๋ผ๋ฏธํฐ๊ฐ ์์
    .subscribe { print($0)}
    .disposed(by: disposeBag)   // error event๋ง ์ ๋ฌ๋๊ณ  ๋๋จ
