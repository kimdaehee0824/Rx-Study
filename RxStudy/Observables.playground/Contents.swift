import UIKit
import RxSwift

let o1 = Observable<Int>.create {
    (observer) -> Disposable in
    
    observer.on(.next(0))
    observer.onNext(1)
    observer.onCompleted()
    return Disposables.create()
}

// 1
o1.subscribe {
    print("=== start ===")
    print($0)
    if let elem = $0.element {
        print(elem)
    }
    print("=== end ===")
}
// 2

print("---------------\n")

// subscribe 각자 하는 법
o1.subscribe(onNext: {elem in
    print(elem)
})


print("==============================")
/* onDisposed 예시 */

// 1
Observable.from([1, 2, 3])
    .subscribe(onNext: { elem in
        print("next", elem)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Comaleted ")
    }, onDisposed: {
        print("Dispossed")  // Observable을 제거하고 보여줌, 모든 리소스 제거 후 보여줌
    })

// 헤제할 때 필요한 코드만 Dispossed 사용, 보통 2번으로

// 2
Observable.from([1, 2, 3])
    .subscribe {
        print("=== start ===")
        print($0)
        print("=== end ===")
    }
// Dispossed는 Observable이 전달하는 함수가 아님
