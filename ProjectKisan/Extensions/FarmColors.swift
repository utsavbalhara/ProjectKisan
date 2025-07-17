import SwiftUI

extension Color {
    static let farmColors = FarmColors()
}

struct FarmColors {
    let primary = Color("farmPrimary")
    let primaryLight = Color("farmPrimaryLight")
    let backgroundLight = Color("farmBackgroundLight")
    let backgroundMedium = Color("farmBackgroundMedium")
    let textPrimary = Color("farmTextPrimary")
    let surface = Color("farmSurface")
    let textSecondary = Color("farmTextSecondary")
    let secondary = Color("farmSecondary")
    let backgroundDark = Color("farmBackgroundDark")
    let successGreen = Color("farmSuccessGreen")
    let shadow = Color(hex: "000000").opacity(0.1)
}
