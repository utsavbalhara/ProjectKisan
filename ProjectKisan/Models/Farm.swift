import Foundation
import UIKit

enum CropStage: String, CaseIterable {
    case preparation = "Preparation"
    case sowingPlanting = "Sowing/Planting"
    case cropManagement = "Crop Management"
    case irrigation = "Irrigation"
    case weeding = "Weeding"
    case harvesting = "Harvesting"
    case postHarvestStorage = "Post-Harvest/Storage"
    
    var progressValue: Double {
        switch self {
        case .preparation: return 1.0/7.0
        case .sowingPlanting: return 2.0/7.0
        case .cropManagement: return 3.0/7.0
        case .irrigation: return 4.0/7.0
        case .weeding: return 5.0/7.0
        case .harvesting: return 6.0/7.0
        case .postHarvestStorage: return 7.0/7.0
        }
    }
}

struct WeatherData {
    let temperature: Double // °C
    let precipitation: Double // mm
    let windSpeed: Double // km/h
    let windDirection: String
    let humidity: Double // %
    let hoursOfSunshine: Double // hours
}

struct IoTSensorData {
    let soilMoisture: Double // %
    let soilTemperature: Double // °C
    let soilPH: Double
    let airTemperature: Double // °C
    let humidity: Double // %
    let nutrientLevels: String // Description
}

class Farm: Identifiable {
    let id = UUID()
    let farmName: String
    let typeOfCrop: String
    let areaInAcres: Double
    let currentStage: CropStage
    let iotSensorId: String
    let weatherData: WeatherData
    let iotSensorData: IoTSensorData
    let farmImage: UIImage?
    
    init(farmName: String = "", typeOfCrop: String, areaInAcres: Double, currentStage: CropStage, iotSensorId: String = "", weatherData: WeatherData, iotSensorData: IoTSensorData, farmImage: UIImage? = nil) {
        self.farmName = farmName.isEmpty ? "\(typeOfCrop) Farm" : farmName
        self.typeOfCrop = typeOfCrop
        self.areaInAcres = areaInAcres
        self.currentStage = currentStage
        self.iotSensorId = iotSensorId
        self.weatherData = weatherData
        self.iotSensorData = iotSensorData
        self.farmImage = farmImage
    }
}
