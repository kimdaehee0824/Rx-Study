

import Foundation


struct Forecast: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    
    struct ListItem: Codable {
        let dt: Int
        
        struct Main: Codable {
            let temp: Double
        }

        let main: Main
        func arrayRepresentation() -> [WeatherData] {
            let data = [WeatherData]()
            return data
        }
        struct Weather: Codable {
            let description: String
            let icon: String
        }

        let weather: [Weather]
    }
    
    let list: [ListItem]
}


