import UIKit
import RxSwift

// Sharing Subscription

print("\n----------Sharing Subscription----------\n")
let bag = DisposeBag()

let source = Observable<String>.create { observer in
    let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/string")!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data, let html = String(data: data, encoding: .utf8) {
            observer.onNext(html)
        }
        
        observer.onCompleted()
    }
    task.resume()
    
    return Disposables.create {
        task.cancel()
    }
}
//    .debug()  //

source.subscribe().disposed(by: bag)
source.subscribe().disposed(by: bag)    // 중첩되니 불~~편


// multicast
print("\n-------multicast-------\n")

let mBag = DisposeBag()
let mSubject = PublishSubject<Int>()

let mSource = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .take(5)
    .multicast(mSubject)    // 원본 Observable를 ConnectableObservable로 변경
mSource
   .subscribe { print("🔵", $0) }
   .disposed(by: mBag)

mSource
   .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
   .subscribe { print("🔴", $0) }
   .disposed(by: mBag)

mSource.connect()   // 이거를 해 줘야 실행이 됨
// 이거를 해 줘야 개별 시퀀스를 생성해 각자 움직임

/*
 원하는 걸 자유롭게 만들 수 있지만, connect나 Subject를 직접 설정해야 해 귀찮,
 이 연산자는 다소 번거료울 수 있어 이거를 활용한 다른 거를 사용하도록 하자.
 */
