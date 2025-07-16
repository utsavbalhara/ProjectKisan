import SwiftUI

extension Color {
    static let farmColors = FarmColors()
}

struct FarmColors {
    let primary = Color(hex: "2E7D32")
    let primaryLight = Color(hex: "4CAF50")
    let primaryDark = Color(hex: "1B5E20")
    let secondary = Color(hex: "66BB6A")
    let secondaryLight = Color(hex: "81C784")
    let accent = Color(hex: "8BC34A")
    let accentLight = Color(hex: "9CCC65")
    
    let backgroundLight = Color(hex: "F1F8E9")
    let backgroundMedium = Color(hex: "E8F5E8")
    let backgroundDark = Color(hex: "C8E6C9")
    
    let surface = Color(hex: "FFFFFF")
    let surfaceVariant = Color(hex: "F8FFF8")
    
    let textPrimary = Color(hex: "1B5E20")
    let textSecondary = Color(hex: "2E7D32")
    let textTertiary = Color(hex: "4CAF50")
    
    let warningRed = Color(hex: "D32F2F")
    let warningRedLight = Color(hex: "F44336")
    let warningYellow = Color(hex: "F57C00")
    let warningYellowLight = Color(hex: "FF9800")
    
    let successGreen = Color(hex: "388E3C")
    let infoBlue = Color(hex: "1976D2")
    
    let shadow = Color(hex: "000000").opacity(0.1)
}