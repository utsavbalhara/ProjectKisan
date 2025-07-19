import WidgetKit
import SwiftUI

struct FarmConditionsWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallFarmConditionsWidget(conditions: entry.farmConditions)
        case .systemMedium:
            MediumFarmConditionsWidget(conditions: entry.farmConditions)
        case .systemLarge:
            LargeFarmConditionsWidget(conditions: entry.farmConditions)
        default:
            SmallFarmConditionsWidget(conditions: entry.farmConditions)
        }
    }
}

// MARK: - Small Widget (2x2)
struct SmallFarmConditionsWidget: View {
    let conditions: FarmConditions
    
    var body: some View {
        VStack(spacing: 8) {
            // Header
            HStack {
                Image(systemName: "leaf.fill")
                    .font(.caption)
                    .foregroundColor(.green)
                Text("Farm Status")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            // Main metric
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: "drop.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Soil Moisture")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(Int(conditions.soilMoisture.rounded()))%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                
                // Status indicator
                HStack {
                    Circle()
                        .fill(getSoilMoistureColor(conditions.soilMoisture))
                        .frame(width: 6, height: 6)
                    Text(getSoilMoistureStatus(conditions.soilMoisture))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            Spacer()
            
            // Quick info
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text("Temp")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("\(String(format: "%.1f", conditions.soilTemperature))°C")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 1) {
                    Text("Irrigation")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(conditions.irrigationRecommendation.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(conditions.irrigationRecommendation.color))
                }
            }
        }
        .padding()
    }
    
    private func getSoilMoistureStatus(_ moisture: Double) -> String {
        switch moisture {
        case 0..<30: return "Low"
        case 30..<60: return "Good"
        case 60..<80: return "High"
        default: return "Very High"
        }
    }
    
    private func getSoilMoistureColor(_ moisture: Double) -> Color {
        switch moisture {
        case 0..<30: return .red
        case 30..<60: return .green
        case 60..<80: return .orange
        default: return .blue
        }
    }
}

// MARK: - Medium Widget (4x2)
struct MediumFarmConditionsWidget: View {
    let conditions: FarmConditions
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: "leaf.fill")
                    .font(.subheadline)
                    .foregroundColor(.green)
                Text("Farm Conditions")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
                Text("Updated Now")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Metrics Grid
            HStack(spacing: 12) {
                // Soil Moisture
                VStack(spacing: 6) {
                    HStack {
                        Image(systemName: "drop.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("Moisture")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    
                    Text("\(Int(conditions.soilMoisture.rounded()))%")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(getSoilMoistureStatus(conditions.soilMoisture))
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(getSoilMoistureColor(conditions.soilMoisture).opacity(0.1))
                        .foregroundColor(getSoilMoistureColor(conditions.soilMoisture))
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // Soil Temperature
                VStack(spacing: 6) {
                    HStack {
                        Image(systemName: "thermometer")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("Soil Temp")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    
                    Text("\(String(format: "%.1f", conditions.soilTemperature))°C")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Optimal")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.green.opacity(0.1))
                        .foregroundColor(.green)
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Recommendations
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "drop.circle.fill")
                        .font(.caption)
                        .foregroundColor(Color(conditions.irrigationRecommendation.color))
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Irrigation")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(conditions.irrigationRecommendation.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(conditions.irrigationRecommendation.color))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Image(systemName: "spray.fill")
                        .font(.caption)
                        .foregroundColor(Color(conditions.sprayingConditions.color))
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Spraying")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(conditions.sprayingConditions.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(conditions.sprayingConditions.color))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
    
    private func getSoilMoistureStatus(_ moisture: Double) -> String {
        switch moisture {
        case 0..<30: return "Low"
        case 30..<60: return "Good"
        case 60..<80: return "High"
        default: return "Very High"
        }
    }
    
    private func getSoilMoistureColor(_ moisture: Double) -> Color {
        switch moisture {
        case 0..<30: return .red
        case 30..<60: return .green
        case 60..<80: return .orange
        default: return .blue
        }
    }
}

// MARK: - Large Widget (4x4)
struct LargeFarmConditionsWidget: View {
    let conditions: FarmConditions
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "leaf.fill")
                    .font(.title3)
                    .foregroundColor(.green)
                Text("Farm Conditions Dashboard")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
                VStack(alignment: .trailing, spacing: 1) {
                    Text("Updated")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("Just now")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
            }
            
            // Main Metrics Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                // Soil Moisture
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "drop.fill")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        Text("Soil Moisture")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    Text("\(Int(conditions.soilMoisture.rounded()))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(getSoilMoistureStatus(conditions.soilMoisture))
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(getSoilMoistureColor(conditions.soilMoisture).opacity(0.1))
                        .foregroundColor(getSoilMoistureColor(conditions.soilMoisture))
                        .clipShape(Capsule())
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Soil Temperature
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "thermometer")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        Text("Soil Temperature")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    Text("\(String(format: "%.1f", conditions.soilTemperature))°C")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Optimal")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.green.opacity(0.1))
                        .foregroundColor(.green)
                        .clipShape(Capsule())
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Growing Degree Days
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.subheadline)
                            .foregroundColor(.purple)
                        Text("Growing Days")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    Text(String(format: "%.0f", conditions.growingDegreeDays))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("On Track")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.purple.opacity(0.1))
                        .foregroundColor(.purple)
                        .clipShape(Capsule())
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Evapotranspiration
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "humidity.fill")
                            .font(.subheadline)
                            .foregroundColor(.cyan)
                        Text("Evaporation")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    Text("\(String(format: "%.1f", conditions.evapotranspiration))mm")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Normal")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.cyan.opacity(0.1))
                        .foregroundColor(.cyan)
                        .clipShape(Capsule())
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Recommendations
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "drop.circle.fill")
                        .font(.subheadline)
                        .foregroundColor(Color(conditions.irrigationRecommendation.color))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Irrigation")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(conditions.irrigationRecommendation.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color(conditions.irrigationRecommendation.color))
                    }
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack {
                    Image(systemName: "spray.fill")
                        .font(.subheadline)
                        .foregroundColor(Color(conditions.sprayingConditions.color))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Spraying")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(conditions.sprayingConditions.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color(conditions.sprayingConditions.color))
                    }
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
    }
    
    private func getSoilMoistureStatus(_ moisture: Double) -> String {
        switch moisture {
        case 0..<30: return "Low"
        case 30..<60: return "Good"
        case 60..<80: return "High"
        default: return "Very High"
        }
    }
    
    private func getSoilMoistureColor(_ moisture: Double) -> Color {
        switch moisture {
        case 0..<30: return .red
        case 30..<60: return .green
        case 60..<80: return .orange
        default: return .blue
        }
    }
}