

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

typealias SectionModel = AnimatableSectionModel<Int, WeatherData>

class MainViewModel: HasDisposeBag {
    
    static let tempFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "Ko_kr")
        return formatter
    }()
    
    let title : BehaviorRelay<String>
    let WeatherAPI : WeatherApiType
    let locationProvider : LocationProviderType
    
    
    init(title: String, WeatherAPI: WeatherApiType, locationProvider: LocationProviderType) {
        self.title = BehaviorRelay(value: title)
        self.WeatherAPI = WeatherAPI
        self.locationProvider = locationProvider
        
        locationProvider.currentAddress().bind(to: self.title)
            .disposed(by: disposeBag)
    }
    
    var weatherData : Driver<[SectionModel]> {
        return locationProvider.currentLocation()
            .flatMap { [unowned self] in
                self.WeatherAPI.fetch(location: $0)
                    .asDriver(onErrorJustReturn: (nil, []))
            }
            .map { summary, forecast in
                var sumaryList = [WeatherData]()
                if let summary = summary as? WeatherData {
                    sumaryList.append(summary)
                }
                return [
                    SectionModel(model: 0, items: sumaryList),
                    SectionModel(model: 1, items: forecast as! [WeatherData])
                ]
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    let dataSourse : RxTableViewSectionedAnimatedDataSource<SectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<SectionModel>{ (dataSourse, tableView, indexPath, data) -> UITableViewCell in
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as! SummaryTableViewCell
                cell.configure(from: data, tempFormatter: MainViewModel.tempFormatter)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
                cell.configure(from: data, dateFormatter: MainViewModel.dateFormatter, tempFormatter: MainViewModel.tempFormatter)
                return cell
            }
        }
        return ds
    }()
}
