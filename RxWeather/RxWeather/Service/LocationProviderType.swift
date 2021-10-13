

import Foundation
import CoreLocation
import RxSwift

protocol LocationProviderType {
    @discardableResult
    func currentLocation() -> Observable<CLLocation>// 현제 위치가 필요할 떄
    
    @discardableResult
    func currentAddress() -> Observable<String>
    
}
