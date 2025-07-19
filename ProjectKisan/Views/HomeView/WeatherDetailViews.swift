import SwiftUI

// MARK: - Hourly Forecast View
struct HourlyForecastView: View {
    let forecasts: [HourlyForecast]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("5-Hour Forecast")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(forecasts.enumerated()), id: \.offset) { index, forecast in
                        HourlyForecastCard(forecast: forecast, isFirst: index == 0)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

struct HourlyForecastCard: View {
    let forecast: HourlyForecast
    let isFirst: Bool
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(isFirst ? "Now" : timeFormatter.string(from: forecast.time))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isFirst ? Color.farmColors.primary : Color.farmColors.textSecondary)
            
            Image(systemName: forecast.condition.icon)
                .font(.title2)
                .foregroundColor(Color(hex: forecast.condition.color))
                .frame(height: 30)
            
            Text("\(Int(forecast.temperature.rounded()))°")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)
            
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .font(.caption2)
                        .foregroundColor(Color.farmColors.primary)
                    
                    Text("\(Int(forecast.precipitationProbability.rounded()))%")
                        .font(.caption2)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "wind")
                        .font(.caption2)
                        .foregroundColor(Color.farmColors.primary)
                    
                    Text("\(Int(forecast.windSpeed.rounded()))")
                        .font(.caption2)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isFirst ? Color.farmColors.primary.opacity(0.1) : Color.farmColors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isFirst ? Color.farmColors.primary.opacity(0.3) : Color.clear, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 6)
        )
        .frame(width: 80)
    }
}

// MARK: - Detailed Conditions View
struct DetailedConditionsView: View {
    let currentWeather: CurrentWeather
    let sunTimes: SunTimes
    let airQuality: AirQuality
    
    var body: some View {
        VStack(spacing: 16) {
            // Weather Details Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                DetailCard(
                    icon: "thermometer",
                    title: "Feels Like",
                    value: "\(Int(currentWeather.feelsLike.rounded()))°C",
                    subtitle: "Actual: \(Int(currentWeather.temperature.rounded()))°C"
                )
                
                DetailCard(
                    icon: "drop.fill",
                    title: "Dew Point",
                    value: "\(Int(currentWeather.dewPoint.rounded()))°C",
                    subtitle: "Humidity: \(Int(currentWeather.humidity.rounded()))%"
                )
                
                DetailCard(
                    icon: "wind",
                    title: "Wind",
                    value: "\(Int(currentWeather.windSpeed.rounded())) km/h",
                    subtitle: "Direction: \(currentWeather.windDirection)"
                )
                
                DetailCard(
                    icon: "barometer",
                    title: "Pressure",
                    value: "\(Int(currentWeather.pressure.rounded())) hPa",
                    subtitle: "Sea Level"
                )
            }
            
            // Sun Times
            SunTimesCard(sunTimes: sunTimes)
            
            // Air Quality
            AirQualityCard(airQuality: airQuality)
        }
        .padding(.vertical, 8)
    }
}

struct DetailCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Color.farmColors.primary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.farmColors.surface)
                .shadow(color: Color.black.opacity(0.05), radius: 6)
        )
    }
}

struct SunTimesCard: View {
    let sunTimes: SunTimes
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    private var durationFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .font(.title3)
                    .foregroundColor(.orange)
                
                Text("Sun Times")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
            }
            
            HStack {
                VStack(spacing: 8) {
                    SunTimeItem(
                        icon: "sunrise.fill",
                        label: "Sunrise",
                        time: timeFormatter.string(from: sunTimes.sunrise),
                        color: .orange
                    )
                    
                    SunTimeItem(
                        icon: "sunset.fill",
                        label: "Sunset",
                        time: timeFormatter.string(from: sunTimes.sunset),
                        color: .red
                    )
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Daylight")
                            .font(.caption)
                            .foregroundColor(Color.farmColors.textSecondary)
                        
                        Text(durationFormatter.string(from: sunTimes.dayLength) ?? "")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.textPrimary)
                    }
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Solar Noon")
                            .font(.caption)
                            .foregroundColor(Color.farmColors.textSecondary)
                        
                        Text(timeFormatter.string(from: sunTimes.solarNoon))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.textPrimary)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.farmColors.surface)
                .shadow(color: Color.black.opacity(0.05), radius: 6)
        )
    }
}

struct SunTimeItem: View {
    let icon: String
    let label: String
    let time: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Text(time)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
            }
            
            Spacer()
        }
    }
}

struct AirQualityCard: View {
    let airQuality: AirQuality
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lungs.fill")
                    .font(.title3)
                    .foregroundColor(Color(hex: airQuality.category.color))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Air Quality")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text(airQuality.category.rawValue)
                        .font(.caption)
                        .foregroundColor(Color(hex: airQuality.category.color))
                }
                
                Spacer()
                
                Text("\(airQuality.aqi)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: airQuality.category.color))
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach(Array(airQuality.pollutants.keys.sorted()), id: \.self) { pollutant in
                    if let value = airQuality.pollutants[pollutant] {
                        PollutantItem(name: pollutant, value: value)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.farmColors.surface)
                .shadow(color: Color.black.opacity(0.05), radius: 6)
        )
    }
}

struct PollutantItem: View {
    let name: String
    let value: Double
    
    var body: some View {
        VStack(spacing: 4) {
            Text(name)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(Color.farmColors.textSecondary)
            
            Text(String(format: "%.1f", value))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.farmColors.backgroundLight)
        )
    }
}

// MARK: - Farm Conditions View
struct FarmConditionsView: View {
    let conditions: FarmConditions
    
    var body: some View {
        VStack(spacing: 16) {
            // Farm Metrics Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                FarmMetricCard(
                    icon: "drop.fill",
                    title: "Soil Moisture",
                    value: "\(Int(conditions.soilMoisture.rounded()))%",
                    status: getSoilMoistureStatus(conditions.soilMoisture),
                    color: getSoilMoistureColor(conditions.soilMoisture)
                )
                
                FarmMetricCard(
                    icon: "thermometer",
                    title: "Soil Temperature",
                    value: "\(String(format: "%.1f", conditions.soilTemperature))°C",
                    status: "Optimal",
                    color: "#51CF66"
                )
                
                FarmMetricCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Growing Degree Days",
                    value: String(format: "%.0f", conditions.growingDegreeDays),
                    status: "On Track",
                    color: "#FFB946"
                )
                
                FarmMetricCard(
                    icon: "humidity.fill",
                    title: "Evapotranspiration",
                    value: "\(String(format: "%.1f", conditions.evapotranspiration)) mm/day",
                    status: "Normal",
                    color: "#4DABF7"
                )
            }
            
            // Recommendations
            VStack(spacing: 12) {
                IrrigationRecommendationCard(recommendation: conditions.irrigationRecommendation)
                SprayingConditionsCard(conditions: conditions.sprayingConditions)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func getSoilMoistureStatus(_ moisture: Double) -> String {
        switch moisture {
        case 0..<30:
            return "Low"
        case 30..<60:
            return "Good"
        case 60..<80:
            return "High"
        default:
            return "Very High"
        }
    }
    
    private func getSoilMoistureColor(_ moisture: Double) -> String {
        switch moisture {
        case 0..<30:
            return "#FA5252"
        case 30..<60:
            return "#51CF66"
        case 60..<80:
            return "#FFB946"
        default:
            return "#4DABF7"
        }
    }
}

struct FarmMetricCard: View {
    let icon: String
    let title: String
    let value: String
    let status: String
    let color: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Color(hex: color))
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Text(status)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: color))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color(hex: color).opacity(0.1))
                    )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.farmColors.surface)
                .shadow(color: Color.black.opacity(0.05), radius: 6)
        )
    }
}

struct IrrigationRecommendationCard: View {
    let recommendation: IrrigationRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "drop.circle.fill")
                    .font(.title3)
                    .foregroundColor(Color(hex: recommendation.color))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Irrigation Recommendation")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text(recommendation.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: recommendation.color))
                }
                
                Spacer()
                
                Image(systemName: getIrrigationIcon(recommendation))
                    .font(.title2)
                    .foregroundColor(Color(hex: recommendation.color))
            }
            
            Text(getIrrigationAdvice(recommendation))
                .font(.subheadline)
                .foregroundColor(Color.farmColors.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.farmColors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: recommendation.color).opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 6)
        )
    }
    
    private func getIrrigationIcon(_ recommendation: IrrigationRecommendation) -> String {
        switch recommendation {
        case .notNeeded:
            return "checkmark.circle.fill"
        case .consider:
            return "clock.fill"
        case .recommended:
            return "exclamationmark.triangle.fill"
        case .urgent:
            return "alarm.fill"
        }
    }
    
    private func getIrrigationAdvice(_ recommendation: IrrigationRecommendation) -> String {
        switch recommendation {
        case .notNeeded:
            return "Soil moisture levels are adequate. No irrigation needed at this time."
        case .consider:
            return "Soil moisture is getting low. Consider irrigating within the next 24-48 hours."
        case .recommended:
            return "Soil moisture levels are below optimal. Irrigation is recommended within 24 hours."
        case .urgent:
            return "Soil moisture is critically low. Immediate irrigation required to prevent crop stress."
        }
    }
}

struct SprayingConditionsCard: View {
    let conditions: SprayingConditions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "spray.fill")
                    .font(.title3)
                    .foregroundColor(Color(hex: conditions.color))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Spraying Conditions")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text(conditions.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: conditions.color))
                }
                
                Spacer()
                
                Image(systemName: getSprayingIcon(conditions))
                    .font(.title2)
                    .foregroundColor(Color(hex: conditions.color))
            }
            
            Text(getSprayingAdvice(conditions))
                .font(.subheadline)
                .foregroundColor(Color.farmColors.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.farmColors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: conditions.color).opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 6)
        )
    }
    
    private func getSprayingIcon(_ conditions: SprayingConditions) -> String {
        switch conditions {
        case .ideal:
            return "checkmark.circle.fill"
        case .good:
            return "checkmark.circle"
        case .caution:
            return "exclamationmark.triangle.fill"
        case .avoid:
            return "xmark.circle.fill"
        }
    }
    
    private func getSprayingAdvice(_ conditions: SprayingConditions) -> String {
        switch conditions {
        case .ideal:
            return "Perfect conditions for spraying. Low wind speeds and optimal humidity levels."
        case .good:
            return "Good conditions for spraying. Minor wind or humidity considerations."
        case .caution:
            return "Use caution when spraying. Check wind speeds and drift potential."
        case .avoid:
            return "Avoid spraying operations. High wind speeds or unfavorable conditions present."
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            HourlyForecastView(forecasts: ComprehensiveWeather.sampleData.forecast)
            
            DetailedConditionsView(
                currentWeather: ComprehensiveWeather.sampleData.currentWeather,
                sunTimes: ComprehensiveWeather.sampleData.sunTimes,
                airQuality: ComprehensiveWeather.sampleData.airQuality
            )
            
            FarmConditionsView(conditions: ComprehensiveWeather.sampleData.farmConditions)
        }
        .padding()
    }
    .background(Color.farmColors.backgroundLight)
}
