import Foundation

// MARK: - Weather Models
struct ComprehensiveWeather {
    let currentWeather: CurrentWeather
    let forecast: [HourlyForecast]
    let alerts: [WeatherAlert]
    let sunTimes: SunTimes
    let airQuality: AirQuality
    let farmConditions: FarmConditions
}

struct CurrentWeather {
    let temperature: Double
    let feelsLike: Double
    let condition: WeatherCondition
    let humidity: Double
    let windSpeed: Double
    let windDirection: String
    let windGust: Double?
    let pressure: Double
    let visibility: Double
    let uvIndex: Int
    let dewPoint: Double
    let precipitation: Double
    let precipitationProbability: Double
    let lastUpdated: Date
}

struct HourlyForecast {
    let time: Date
    let temperature: Double
    let condition: WeatherCondition
    let precipitationProbability: Double
    let windSpeed: Double
    let humidity: Double
}

struct WeatherAlert {
    let id: String
    let type: WeatherAlertType
    let severity: AlertSeverity
    let title: String
    let description: String
    let impact: String
    let recommendations: [String]
    let validUntil: Date
}

struct SunTimes {
    let sunrise: Date
    let sunset: Date
    let dayLength: TimeInterval
    let solarNoon: Date
}

struct AirQuality {
    let aqi: Int
    let category: AirQualityCategory
    let pollutants: [String: Double]
}

struct FarmConditions {
    let soilMoisture: Double
    let soilTemperature: Double
    let growingDegreeDays: Double
    let evapotranspiration: Double
    let irrigationRecommendation: IrrigationRecommendation
    let sprayingConditions: SprayingConditions
}

enum WeatherCondition: String, CaseIterable {
    case clear = "Clear"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case overcast = "Overcast"
    case lightRain = "Light Rain"
    case rain = "Rain"
    case heavyRain = "Heavy Rain"
    case thunderstorm = "Thunderstorm"
    case snow = "Snow"
    case fog = "Fog"
    case windy = "Windy"
    case hail = "Hail"
    
    var icon: String {
        switch self {
        case .clear: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .overcast: return "cloud.fill"
        case .lightRain: return "cloud.rain.fill"
        case .rain: return "cloud.rain.fill"
        case .heavyRain: return "cloud.heavyrain.fill"
        case .thunderstorm: return "cloud.bolt.rain.fill"
        case .snow: return "cloud.snow.fill"
        case .fog: return "cloud.fog.fill"
        case .windy: return "wind"
        case .hail: return "cloud.hail.fill"
        }
    }
    
    var color: String {
        switch self {
        case .clear: return "#FFB946"
        case .partlyCloudy: return "#74C0FC"
        case .cloudy, .overcast: return "#868E96"
        case .lightRain, .rain: return "#4DABF7"
        case .heavyRain, .thunderstorm: return "#1971C2"
        case .snow: return "#E3FAFC"
        case .fog: return "#ADB5BD"
        case .windy: return "#51CF66"
        case .hail: return "#C92A2A"
        }
    }
}

enum WeatherAlertType: String, CaseIterable {
    case frost = "Frost"
    case hail = "Hail"
    case drought = "Drought"
    case flooding = "Flooding"
    case strongWind = "Strong Wind"
    case heatWave = "Heat Wave"
    case coldWave = "Cold Wave"
    case pestRisk = "Pest Risk"
    case diseaseRisk = "Disease Risk"
    case sprayingAdvisory = "Spraying Advisory"
    
    var icon: String {
        switch self {
        case .frost: return "thermometer.snowflake"
        case .hail: return "cloud.hail.fill"
        case .drought: return "drop.fill"
        case .flooding: return "water.waves"
        case .strongWind: return "wind"
        case .heatWave: return "thermometer.sun.fill"
        case .coldWave: return "thermometer.snowflake"
        case .pestRisk: return "ant.fill"
        case .diseaseRisk: return "leaf.fill"
        case .sprayingAdvisory: return "drop.triangle.fill"
        }
    }
}

enum AlertSeverity: String, CaseIterable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
    case extreme = "Extreme"
    
    var color: String {
        switch self {
        case .low: return "#51CF66"
        case .moderate: return "#FFB946"
        case .high: return "#FF8C42"
        case .extreme: return "#FA5252"
        }
    }
}

enum AirQualityCategory: String, CaseIterable {
    case good = "Good"
    case moderate = "Moderate"
    case unhealthyForSensitive = "Unhealthy for Sensitive Groups"
    case unhealthy = "Unhealthy"
    case veryUnhealthy = "Very Unhealthy"
    case hazardous = "Hazardous"
    
    var color: String {
        switch self {
        case .good: return "#51CF66"
        case .moderate: return "#FFB946"
        case .unhealthyForSensitive: return "#FF8C42"
        case .unhealthy: return "#FA5252"
        case .veryUnhealthy: return "#C92A2A"
        case .hazardous: return "#862E9C"
        }
    }
}

enum IrrigationRecommendation: String, CaseIterable {
    case notNeeded = "Not Needed"
    case consider = "Consider"
    case recommended = "Recommended"
    case urgent = "Urgent"
    
    var color: String {
        switch self {
        case .notNeeded: return "#37B24D" // Darker Green
        case .consider: return "#F59F00" // Darker Yellow
        case .recommended: return "#FF8C42"
        case .urgent: return "#FA5252"
        }
    }
}

enum SprayingConditions: String, CaseIterable {
    case ideal = "Ideal"
    case good = "Good"
    case caution = "Caution"
    case avoid = "Avoid"
    
    var color: String {
        switch self {
        case .ideal: return "#37B24D" // Darker Green
        case .good: return "#94D82D"
        case .caution: return "#F59F00" // Darker Yellow
        case .avoid: return "#FA5252"
        }
    }
}

// MARK: - Sample Data
extension ComprehensiveWeather {
    static let sampleData = ComprehensiveWeather(
        currentWeather: CurrentWeather(
            temperature: 24.5,
            feelsLike: 27.2,
            condition: .partlyCloudy,
            humidity: 68.0,
            windSpeed: 12.4,
            windDirection: "NW",
            windGust: 18.2,
            pressure: 1013.2,
            visibility: 10.0,
            uvIndex: 6,
            dewPoint: 18.1,
            precipitation: 0.0,
            precipitationProbability: 25.0,
            lastUpdated: Date()
        ),
        forecast: [
            HourlyForecast(time: Date().addingTimeInterval(3600), temperature: 25.1, condition: .partlyCloudy, precipitationProbability: 15, windSpeed: 11.2, humidity: 65),
            HourlyForecast(time: Date().addingTimeInterval(7200), temperature: 26.3, condition: .cloudy, precipitationProbability: 35, windSpeed: 14.1, humidity: 72),
            HourlyForecast(time: Date().addingTimeInterval(10800), temperature: 23.8, condition: .lightRain, precipitationProbability: 65, windSpeed: 16.3, humidity: 78),
            HourlyForecast(time: Date().addingTimeInterval(14400), temperature: 22.1, condition: .rain, precipitationProbability: 85, windSpeed: 18.7, humidity: 82),
            HourlyForecast(time: Date().addingTimeInterval(18000), temperature: 21.4, condition: .partlyCloudy, precipitationProbability: 40, windSpeed: 13.2, humidity: 75)
        ],
        alerts: [
            WeatherAlert(
                id: "alert1",
                type: .strongWind,
                severity: .moderate,
                title: "Strong Wind Advisory",
                description: "Wind speeds may reach 25-35 km/h with gusts up to 45 km/h",
                impact: "May affect spraying operations and tall crops",
                recommendations: ["Avoid pesticide application", "Secure loose equipment", "Monitor tall crops for damage"],
                validUntil: Date().addingTimeInterval(21600)
            ),
            WeatherAlert(
                id: "alert2",
                type: .diseaseRisk,
                severity: .high,
                title: "High Disease Risk",
                description: "High humidity and moderate temperatures create ideal conditions for fungal diseases",
                impact: "Increased risk of crop diseases, especially in wheat and rice",
                recommendations: ["Consider preventive fungicide application", "Improve field ventilation", "Monitor crops closely"],
                validUntil: Date().addingTimeInterval(86400)
            )
        ],
        sunTimes: SunTimes(
            sunrise: Calendar.current.date(bySettingHour: 5, minute: 45, second: 0, of: Date())!,
            sunset: Calendar.current.date(bySettingHour: 18, minute: 32, second: 0, of: Date())!,
            dayLength: 46020,
            solarNoon: Calendar.current.date(bySettingHour: 12, minute: 8, second: 0, of: Date())!
        ),
        airQuality: AirQuality(
            aqi: 45,
            category: .good,
            pollutants: [
                "PM2.5": 12.3,
                "PM10": 28.1,
                "NO2": 15.7,
                "SO2": 8.2,
                "CO": 0.8,
                "O3": 32.4
            ]
        ),
        farmConditions: FarmConditions(
            soilMoisture: 45.8,
            soilTemperature: 18.7,
            growingDegreeDays: 145.2,
            evapotranspiration: 4.2,
            irrigationRecommendation: .consider,
            sprayingConditions: .caution
        )
    )
}
