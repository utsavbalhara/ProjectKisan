import Foundation

// MARK: - Widget Sample Data Extensions
extension FarmConditions {
    static var sampleData: FarmConditions {
        FarmConditions(
            soilMoisture: 45.0,
            soilTemperature: 22.5,
            growingDegreeDays: 1250.0,
            evapotranspiration: 4.2,
            irrigationRecommendation: .moderate,
            sprayingConditions: .good
        )
    }
}

extension IrrigationRecommendation {
    var color: String {
        switch self {
        case .none: return "#37B24D"
        case .light: return "#F59F00"
        case .moderate: return "#4DABF7"
        case .heavy: return "#FA5252"
        }
    }
}

extension SprayingConditions {
    var color: String {
        switch self {
        case .poor: return "#FA5252"
        case .fair: return "#F59F00"
        case .good: return "#37B24D"
        case .excellent: return "#4DABF7"
        }
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}