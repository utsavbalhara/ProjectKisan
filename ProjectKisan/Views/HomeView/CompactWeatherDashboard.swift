import SwiftUI

struct CompactWeatherDashboard: View {
    let weather: ComprehensiveWeather
    @State private var showingDetailedWeather = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Main Weather Info - Compact (Clickable)
            CompactWeatherHeader(currentWeather: weather.currentWeather) {
                showingDetailedWeather = true
            }
            
            // Farm Conditions Grid - Key metrics only
            CompactFarmConditions(conditions: weather.farmConditions)
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $showingDetailedWeather) {
            DetailedWeatherView(weather: weather)
        }
    }
}

struct CompactWeatherHeader: View {
    let currentWeather: CurrentWeather
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Left side - Weather icon and temp
                HStack(spacing: 12) {
                    Image(systemName: currentWeather.condition.icon)
                        .font(.title)
                        .foregroundColor(Color(hex: currentWeather.condition.color))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(Int(currentWeather.temperature.rounded()))°")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text(currentWeather.condition.rawValue)
                            .font(.caption)
                            .foregroundColor(Color.farmColors.textSecondary)
                    }
                }
                
                Spacer()
                
                // Right side - Key metrics
                HStack(spacing: 16) {
                    CompactMetric(
                        icon: "humidity.fill",
                        value: "\(Int(currentWeather.humidity.rounded()))%",
                        label: "Humidity"
                    )
                    
                    CompactMetric(
                        icon: "wind",
                        value: "\(Int(currentWeather.windSpeed.rounded()))",
                        label: "Wind"
                    )
                    
                    CompactMetric(
                        icon: "drop.fill",
                        value: "\(Int(currentWeather.precipitationProbability.rounded()))%",
                        label: "Rain"
                    )
                }
                
                // Chevron indicator
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.farmColors.surface)
                    .shadow(color: Color.farmColors.shadow, radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CompactMetric: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(Color.farmColors.primary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(Color.farmColors.textSecondary)
        }
    }
}

struct CompactFarmConditions: View {
    let conditions: FarmConditions
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Farm Conditions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                CompactFarmMetric(
                    icon: "drop.fill",
                    title: "Soil Moisture",
                    value: "\(Int(conditions.soilMoisture.rounded()))%",
                    status: getSoilMoistureStatus(conditions.soilMoisture),
                    color: getSoilMoistureColor(conditions.soilMoisture)
                )
                
                CompactFarmMetric(
                    icon: "thermometer",
                    title: "Soil Temp",
                    value: "\(String(format: "%.1f", conditions.soilTemperature))°C",
                    status: "Optimal",
                    color: "#37B24D" // Darker Green
                )
                
                CompactFarmMetric(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Growing Days",
                    value: String(format: "%.0f", conditions.growingDegreeDays),
                    status: "On Track",
                    color: "#F59F00" // Darker Yellow
                )
                
                CompactFarmMetric(
                    icon: "humidity.fill",
                    title: "Evaporation",
                    value: "\(String(format: "%.1f", conditions.evapotranspiration))mm",
                    status: "Normal",
                    color: "#4DABF7"
                )
            }
            
            // Compact recommendations
            HStack(spacing: 12) {
                CompactRecommendation(
                    icon: "drop.circle.fill",
                    title: "Irrigation",
                    status: conditions.irrigationRecommendation.rawValue,
                    color: conditions.irrigationRecommendation.color
                )
                
                CompactRecommendation(
                    icon: "spray.fill",
                    title: "Spraying",
                    status: conditions.sprayingConditions.rawValue,
                    color: conditions.sprayingConditions.color
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.farmColors.surface)
                .shadow(color: Color.farmColors.shadow, radius: 4, x: 0, y: 2)
        )
    }
    
    private func getSoilMoistureStatus(_ moisture: Double) -> String {
        switch moisture {
        case 0..<30: return "Low"
        case 30..<60: return "Good"
        case 60..<80: return "High"
        default: return "Very High"
        }
    }
    
    private func getSoilMoistureColor(_ moisture: Double) -> String {
        switch moisture {
        case 0..<30: return "#FA5252"
        case 30..<60: return "#37B24D" // Darker Green
        case 60..<80: return "#F59F00" // Darker Yellow
        default: return "#4DABF7"
        }
    }
}

struct CompactFarmMetric: View {
    let icon: String
    let title: String
    let value: String
    let status: String
    let color: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: color))
                
                Spacer()
                
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
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.farmColors.backgroundLight)
        )
    }
}

struct CompactRecommendation: View {
    let icon: String
    let title: String
    let status: String
    let color: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(Color(hex: color))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Text(status)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: color))
            }
            
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.farmColors.backgroundLight)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: color).opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ScrollView {
        CompactWeatherDashboard(weather: ComprehensiveWeather.sampleData)
            .padding()
    }
    .background(Color.farmColors.backgroundLight)
}
