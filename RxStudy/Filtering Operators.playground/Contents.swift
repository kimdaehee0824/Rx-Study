import UIKit
import RxSwift

let disposeBag = DisposeBag()
let fruits = ["๐", "๐", "๐", "๐", "๐", "๐"]
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 7, 7, ]

// ignoreElements
print("\n--------------------\nignoreElements\n")

Observable.from(fruits)
    .ignoreElements()
// next ๊ฐ์ ๊ฑฐ๋ ์ ๋ฌ๋์ง ์๊ณ  Completed, Error ๋ฉ์ธ์ง๊ฐ ์ ๋๋จ
// next๊ฐ ๋ฐฉ์ถ์ ๋๊ณ  ์์ง๋ง ์ ๋ฌ๋์ง ์์
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// element
print("\n--------------------\nelementAt\n")

Observable.from(fruits)
    .element(at: 2) // ํ์ฌ๋ element ๊ถ์ฅ
// ์ ์๋ฅผ ๋ฐ์ Observable ๋ฆฌํด
// ์ ํ์ ์ผ๋ก ๋ฐฉ์ถ
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// filter
print("\n--------------------\nfilter\n")

Observable.from(numbers)
    .filter { $0.isMultiple(of: 2)}
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// skip
print("\n--------------------\nskip\n")

Observable.from(numbers)
    .skip(3)    // ์ ํ๋ ์ซ์๋งํผ ์คํต
    .subscribe {print($0)}
    .disposed(by: disposeBag)

Observable.from(numbers)
    .skip { !$0.isMultiple(of: 2)}  // skipwhile๋ ์ฌ๋ผ์ง
    .subscribe {print($0)}
    .disposed(by: disposeBag)


print("\n--------------------\nskipUntil\n")

let subject = PublishSubject<Int>()
let triger = PublishSubject<Int>()
subject.skip(until: triger)
    .subscribe {print($0)}
    .disposed(by: disposeBag)

subject.onNext(1)   // trigger๊ฐ ์์ผ ๋ฐฉ์ถ ์ํจ
triger.onNext(0)    // No
subject.onNext(2)   // ์ด์ ๋ถํฐ ๋ฐฉ์ถ๋จ


// take
print("\n--------------------\ntake\n")

Observable.from(numbers)
    .take(5)     // next ์ด๋ฐดํธ์๋ง ์ํฅ, ๋๋จธ์ง๋ ์ํฅ์ ์ฃผ์ง ๋ณ์
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// takeWhile

Observable.from(numbers)
    .takeWhile { !$0.isMultiple(of: 2)} // takeWhile ๊ถ์ฅํ์ง ์์
// ํ์๊ฐ ๋์ค๊ณ ๋ ์์ง๋ง ๋ฐฉ์ถ๋์ง๋ ์์
// ์๊ฐ false๋ฅผ ๋ฆฌํดํ๋ฉด ๋์ด์ ๋ฐฉ์ถํ์ง ์์, ์ดํ Completed, Error event๋ง ์ ๋ฌ
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// takeUntil

let subject2 = PublishSubject<Int>()
let triger2 = PublishSubject<Int>()

subject2.take(until: triger2)
    .subscribe {print($0)}
    .disposed(by: disposeBag)

subject2.onNext(1)
triger2.onNext(0)   // ์์๋ฅผ ๋ฐฉ์ถํ๋ฉด completed ๋ฐฉ์ถ๋จ

// single
print("\n--------------------\nsingle\n")

Observable.just(1)
    .single()   // ์๋ ํ๋๋ง ๋ฐฉ์ถ๋จ ๊ณ ๋ก completed
    .subscribe {print($0)}
    .disposed(by: disposeBag)

Observable.from(numbers)
    .single()   // ์๋ ๋ฌธ์์ด์, ๊ณ ๋ก Error messaage ๋์ด, ๋ฐฉ์ถ์ ํ๋๋ง ๋จ
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// ์ด๋ฐ ๋ฐฉ๋ฒ๋ ์์
Observable.from(numbers)
    .single { $0 == 3 } // ์๋ ์ ๋ฌ๊ฐ ์๋จ๋ค??
    .subscribe {print($0)}
    .disposed(by: disposeBag)

let subject3 = PublishSubject<Int>()
subject3.single()
    .subscribe {print($0)}
    .disposed(by: disposeBag)

subject3.onNext(100)
subject3.onNext(200)    // ์ด๋ฏธ ํ๋์ onNext๊ฐ ์ ๋ฌ๋์ด Error message๊ฐ ๋์ด

// distinctUntilChanged
print("\n--------------------\nsingle\n")

Observable.from(numbers)
    .distinctUntilChanged() // ์  ๋ฐฐ์ด๊ณผ ๋น๊ตํด ๊ฐ์ผ๋ฉด ๋ฌด์.
    .subscribe {print($0)}
    .disposed(by: disposeBag)

// ์ด๊ฑฐ๋ ์ข ๋ณ๋ก์ธ๋ฏ

