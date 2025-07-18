import SwiftUI
import Combine

class FeedViewModel: ObservableObject {
    @Published var farms: [Farm] = []
    
    init() {
        loadFarms()
    }
    
    private func loadFarms() {
        let wheatWeather = WeatherData(
            temperature: 22.5,
            precipitation: 2.3,
            windSpeed: 12.4,
            windDirection: "NW",
            humidity: 68.2,
            hoursOfSunshine: 7.5
        )
        
        let wheatIoT = IoTSensorData(
            soilMoisture: 45.8,
            soilTemperature: 18.7,
            soilPH: 6.8,
            airTemperature: 21.3,
            humidity: 65.4,
            nutrientLevels: "Nitrogen: Good, Phosphorus: Moderate, Potassium: High"
        )
        
        let riceWeather = WeatherData(
            temperature: 28.1,
            precipitation: 15.7,
            windSpeed: 8.9,
            windDirection: "SE",
            humidity: 82.5,
            hoursOfSunshine: 6.2
        )
        
        let riceIoT = IoTSensorData(
            soilMoisture: 78.3,
            soilTemperature: 25.4,
            soilPH: 6.2,
            airTemperature: 27.8,
            humidity: 80.1,
            nutrientLevels: "Nitrogen: High, Phosphorus: Good, Potassium: Moderate"
        )
        
        farms = [
            Farm(farmName: "Wheat Farm Alpha", typeOfCrop: "Wheat", areaInAcres: 25.5, currentStage: .cropManagement, iotSensorId: "WF-001", weatherData: wheatWeather, iotSensorData: wheatIoT),
            Farm(farmName: "Rice Farm Beta", typeOfCrop: "Rice", areaInAcres: 18.0, currentStage: .irrigation, iotSensorId: "RF-002", weatherData: riceWeather, iotSensorData: riceIoT)
        ]
    }
    
    func addFarm(_ farm: Farm) {
        farms.append(farm)
    }
}
