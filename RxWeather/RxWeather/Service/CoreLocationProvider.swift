

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import NSObject_Rx

class CoreLocationProvider: LocationProviderType {
    
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    
    private let location = BehaviorRelay<CLLocation>(value: CLLocation.gangnamStation)
    private let address = BehaviorRelay<String>(value: "강남역")
    private let authorized = BehaviorRelay<Bool>(value: false)
    
    init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.rx.didUpateLocation
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .map{ $0.last ?? CLLocation.gangnamStation}
            .bind(to: location)
            .disposed(by: disposeBag)
        
        location.flatMap { location in
            return  Observable<String>.create{  observaber in
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if let place = placemarks?.first {
                        if let gu = place.locality, let dong = place.subLocality {
                            observaber.onNext("\(gu) \(dong)")
                        } else {
                            observaber.onNext(place.name ?? "알 수 없음")
                        }
                    } else {
                        observaber.onNext("알 수 없음")
                    }
                    observaber.onCompleted()
                }
                return Disposables.create()
            }
        }
        .bind(to: address)
        .disposed(by: disposeBag)
        
        locationManager.rx.didChangeAuterizationStatus
            .map {
                $0 == .authorizedAlways || $0 == .authorizedWhenInUse
            }
            .bind(to: authorized)
            .disposed(by: disposeBag)
    }
    
    
    @discardableResult
    func currentLocation() -> Observable<CLLocation> {
        return location.asObservable()
    }
    func currentAddress() -> Observable<String> {
        return address.asObservable()
    }
}
