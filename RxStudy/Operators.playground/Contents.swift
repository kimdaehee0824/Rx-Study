import UIKit
import RxSwift

let bag = DisposeBag()

Observable.from([1, 2, 3, 5, 6, 7, 9])
    .take(5)    //처음 4개만 전달
    // 만약 두개가 바뀐다면 바뀐 대로 결과가 바뀜, 선 방출 후 필터.
    .filter { $0.isMultiple(of: 3) }    // isMultiple 안에 들어있는 수 배수
    .subscribe { print($0) }
    .disposed(by: bag)

//  연산자는 새로운 Observable를 방출2
//



