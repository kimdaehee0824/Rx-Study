

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import WebKit

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
    
}

public class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    public init( locationManager : CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register {
            RxCLLocationManagerDelegateProxy(locationManager: $0)
        }
    }
}

extension Reactive where Base : CLLocationManager {
    var dekegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    public var didUpateLocation: Observable<[CLLocation]> {
        let sel = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
        return dekegate.methodInvoked(sel)
            .map { paraetors in
                return paraetors[1] as! [CLLocation]
            }
    }
    public var didChangeAuterizationStatus: Observable<CLAuthorizationStatus> {
        let sele : Selector
        if #available(iOS 14.0, *) {
            sele = #selector(CLLocationManagerDelegate.locationManagerDidChangeAuthorization(_:))
        } else {
            sele = #selector(CLLocationManagerDelegate.locationManager(_: didChangeAuthorization:))
        }
        return dekegate.methodInvoked(sele)
            .map { paraetors in
                return CLAuthorizationStatus(rawValue: paraetors[1] as! Int32) ?? .notDetermined
            }
    }
}

