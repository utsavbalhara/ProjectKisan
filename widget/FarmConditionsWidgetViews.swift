//
//  FarmConditionsWidgetViews.swift
//  widget
//
//  Created by Utsav Balhara on 7/19/25.
//

import WidgetKit
import SwiftUI

// MARK: - Small Widget (2x2) - Matches App Design
struct SmallFarmConditionsWidget: View {
    let conditions: FarmConditions
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Farm Conditions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            // Single metric for small widget
            CompactFarmMetric(
                icon: "drop.fill",
                title: "Soil Moisture",
                value: "\(Int(conditions.soilMoisture.rounded()))%",
                status: getSoilMoistureStatus(conditions.soilMoisture),
                color: getSoilMoistureColor(conditions.soilMoisture)
            )
            
            Spacer()
            
            // Single recommendation
            CompactRecommendation(
                icon: "drop.circle.fill",
                title: "Irrigation",
                status: conditions.irrigationRecommendation.rawValue,
                color: conditions.irrigationRecommendation.color
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(.ultraThinMaterial)
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
        case 30..<60: return "#37B24D"
        case 60..<80: return "#F59F00"
        default: return "#4DABF7"
        }
    }
}

// MARK: - Medium Widget (4x2) - Matches App Design
struct MediumFarmConditionsWidget: View {
    let conditions: FarmConditions
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Farm Conditions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            HStack(spacing: 12) {
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
                    color: "#37B24D"
                )
            }
            
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
            RoundedRectangle(cornerRadius: 22)
                .fill(.ultraThinMaterial)
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
        case 30..<60: return "#37B24D"
        case 60..<80: return "#F59F00"
        default: return "#4DABF7"
        }
    }
}

// MARK: - Large Widget (4x4) - Exact App Design
struct LargeFarmConditionsWidget: View {
    let conditions: FarmConditions
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Farm Conditions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
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
                    color: "#37B24D"
                )
                
                CompactFarmMetric(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Growing Days",
                    value: String(format: "%.0f", conditions.growingDegreeDays),
                    status: "On Track",
                    color: "#F59F00"
                )
                
                CompactFarmMetric(
                    icon: "humidity.fill",
                    title: "Evaporation",
                    value: "\(String(format: "%.1f", conditions.evapotranspiration))mm",
                    status: "Normal",
                    color: "#4DABF7"
                )
            }
            
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
            RoundedRectangle(cornerRadius: 22)
                .fill(.ultraThinMaterial)
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
        case 30..<60: return "#37B24D"
        case 60..<80: return "#F59F00"
        default: return "#4DABF7"
        }
    }
}

// MARK: - Reusable Components from App
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
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
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
                    .foregroundColor(.secondary)

                Text(status)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: color))
            }

            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: color).opacity(0.2), lineWidth: 1)
                )
        )
    }
}