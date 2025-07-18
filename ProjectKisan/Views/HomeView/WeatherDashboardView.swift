import SwiftUI

struct WeatherDashboardView: View {
    let weather: ComprehensiveWeather
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 20) {
            // Main Weather Header
            MainWeatherCard(weather: weather.currentWeather)
            
            // Weather Alerts (if any)
            if !weather.alerts.isEmpty {
                WeatherAlertsView(alerts: weather.alerts)
            }
            
            // Tabbed Content
            VStack(spacing: 16) {
                // Tab Selector
                HStack(spacing: 0) {
                    ForEach(0..<3) { index in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = index
                            }
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: tabIcon(for: index))
                                    .font(.title2)
                                    .foregroundColor(selectedTab == index ? .white : Color.farmColors.textSecondary)
                                
                                Text(tabTitle(for: index))
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedTab == index ? .white : Color.farmColors.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedTab == index ? Color.farmColors.primary : Color.clear)
                            )
                        }
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.farmColors.surface)
                        .shadow(color: Color.farmColors.shadow, radius: 4, x: 0, y: 2)
                )
                
                // Tab Content
                Group {
                    switch selectedTab {
                    case 0:
                        HourlyForecastView(forecasts: weather.forecast)
                    case 1:
                        DetailedConditionsView(
                            currentWeather: weather.currentWeather,
                            sunTimes: weather.sunTimes,
                            airQuality: weather.airQuality
                        )
                    case 2:
                        FarmConditionsView(conditions: weather.farmConditions)
                    default:
                        EmptyView()
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "clock.fill"
        case 1: return "info.circle.fill"
        case 2: return "leaf.fill"
        default: return "questionmark"
        }
    }
    
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Hourly"
        case 1: return "Details"
        case 2: return "Farm"
        default: return ""
        }
    }
}

struct MainWeatherCard: View {
    let weather: CurrentWeather
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: weather.condition.icon)
                            .font(.largeTitle)
                            .foregroundColor(Color(hex: weather.condition.color))
                        
                        VStack(alignment: .leading) {
                            Text("\(Int(weather.temperature.rounded()))°")
                                .font(.system(size: 48, weight: .thin, design: .rounded))
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            Text("Feels like \(Int(weather.feelsLike.rounded()))°")
                                .font(.subheadline)
                                .foregroundColor(Color.farmColors.textSecondary)
                        }
                    }
                    
                    Text(weather.condition.rawValue)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(Color.farmColors.textPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    WeatherMetricView(
                        icon: "humidity.fill",
                        value: "\(Int(weather.humidity.rounded()))%",
                        label: "Humidity"
                    )
                    
                    WeatherMetricView(
                        icon: "wind",
                        value: "\(Int(weather.windSpeed.rounded())) km/h",
                        label: "Wind"
                    )
                    
                    WeatherMetricView(
                        icon: "drop.fill",
                        value: "\(Int(weather.precipitationProbability.rounded()))%",
                        label: "Rain"
                    )
                }
            }
            
            // Quick Stats Row
            HStack(spacing: 0) {
                QuickStatView(
                    icon: "eye.fill",
                    value: "\(Int(weather.visibility.rounded())) km",
                    label: "Visibility"
                )
                
                Divider()
                    .frame(height: 40)
                
                QuickStatView(
                    icon: "barometer",
                    value: "\(Int(weather.pressure.rounded())) hPa",
                    label: "Pressure"
                )
                
                Divider()
                    .frame(height: 40)
                
                QuickStatView(
                    icon: "sun.max.fill",
                    value: "\(weather.uvIndex)",
                    label: "UV Index"
                )
            }
            .padding(.vertical, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.farmColors.surface)
                .shadow(color: Color.farmColors.shadow, radius: 8, x: 0, y: 4)
        )
    }
}

struct WeatherMetricView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.primary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
            }
            
            Text(label)
                .font(.caption2)
                .foregroundColor(Color.farmColors.textSecondary)
        }
    }
}

struct QuickStatView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color.farmColors.primary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(Color.farmColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WeatherAlertsView: View {
    let alerts: [WeatherAlert]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(alerts, id: \.id) { alert in
                WeatherAlertCard(alert: alert)
            }
        }
    }
}

struct WeatherAlertCard: View {
    let alert: WeatherAlert
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: alert.type.icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color(hex: alert.severity.color))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(alert.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text(alert.severity.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: alert.severity.color))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color(hex: alert.severity.color).opacity(0.1))
                        )
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Text(alert.description)
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    if !alert.impact.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Impact:")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            Text(alert.impact)
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                        }
                    }
                    
                    if !alert.recommendations.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recommendations:")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            ForEach(alert.recommendations, id: \.self) { recommendation in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(Color.farmColors.primary)
                                    
                                    Text(recommendation)
                                        .font(.caption)
                                        .foregroundColor(Color.farmColors.textSecondary)
                                }
                            }
                        }
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.farmColors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: alert.severity.color).opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.farmColors.shadow, radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    WeatherDashboardView(weather: ComprehensiveWeather.sampleData)
        .padding()
        .background(Color.farmColors.backgroundLight)
}
