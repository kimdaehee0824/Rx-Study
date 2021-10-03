
import UIKit
import RxSwift

// Scheduler

let bag = DisposeBag()
let bckgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .subscribe(on: MainScheduler.instance)
// 얘는 Observable이 시작되는 시점에 어떤 Scheduler를 사용하는지 정해줌,
// 에는 호출 시점이 중요하지 않음
    .filter { num -> Bool in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
        return num.isMultiple(of: 2)
    }
    .observe(on: bckgroundScheduler) // map 연산자가 bckground에서 실행됨
// observeon은 이어지는 작업을 하는 Scheduler를 지정, 앞에 있는 거는 설정이 안됨
    .map { num -> Int in
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
        return num * 2
    }
// 다른 Scheduler를 지정해주지 않으면 기존에 있는 Scheduler를 계속 사용
    .observe(on: MainScheduler.instance)
    .subscribe { // subscribe를 해야 Observable이 생성됨
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: bag)
