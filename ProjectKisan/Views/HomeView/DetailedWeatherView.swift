import SwiftUI

struct DetailedWeatherView: View {
    let weather: ComprehensiveWeather
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Main Weather Card
                    DetailedWeatherCard(currentWeather: weather.currentWeather)

                    // Weather Metrics Grid
                    WeatherMetricsGrid(currentWeather: weather.currentWeather)

                    // Sun Information
                    SunInformationCard(sunTimes: weather.sunTimes)

                    // Hourly Forecast
                    HourlyForecastSection(forecasts: weather.forecast)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(Color.farmColors.backgroundLight.ignoresSafeArea())
            .navigationTitle("Weather Details")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.farmColors.primary)
                }
            }
        }
    }
}

struct DetailedWeatherCard: View {
    let currentWeather: CurrentWeather

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: currentWeather.condition.icon)
                            .font(.largeTitle)
                            .foregroundColor(Color(hex: currentWeather.condition.color))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(Int(currentWeather.temperature.rounded()))°C")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.farmColors.textPrimary)

                            Text(currentWeather.condition.rawValue)
                                .font(.subheadline)
                                .foregroundColor(Color.farmColors.textSecondary)
                        }
                    }

                    Text("Feels like \(Int(currentWeather.feelsLike.rounded()))°C")
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text("Today")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("High: 32°C")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color.farmColors.textPrimary)

                        Text("Low: 18°C")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color.farmColors.textPrimary)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.farmColors.surface)
                .shadow(color: Color.black.opacity(0.05), radius: 6)
        )
    }
}

struct WeatherMetricsGrid: View {
    let currentWeather: CurrentWeather

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weather Details")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                WeatherMetricCard(
                    icon: "humidity.fill",
                    title: "Humidity",
                    value: "\(Int(currentWeather.humidity.rounded()))%",
                    subtitle: "Dew Point: \(Int(currentWeather.dewPoint.rounded()))°C"
                )

                WeatherMetricCard(
                    icon: "wind",
                    title: "Wind",
                    value: "\(Int(currentWeather.windSpeed.rounded())) km/h",
                    subtitle: "Direction: \(currentWeather.windDirection)"
                )

                WeatherMetricCard(
                    icon: "drop.fill",
                    title: "Precipitation",
                    value: "\(Int(currentWeather.precipitationProbability.rounded()))%",
                    subtitle: "Current: \(String(format: "%.1f", currentWeather.precipitation))mm"
                )

                WeatherMetricCard(
                    icon: "barometer",
                    title: "Pressure",
                    value: "\(Int(currentWeather.pressure.rounded())) hPa",
                    subtitle: "Sea Level"
                )

                WeatherMetricCard(
                    icon: "eye.fill",
                    title: "Visibility",
                    value: "\(String(format: "%.1f", currentWeather.visibility)) km",
                    subtitle: currentWeather.visibility > 10 ? "Excellent" : "Good"
                )

                WeatherMetricCard(
                    icon: "sun.max.fill",
                    title: "UV Index",
                    value: "\(Int(currentWeather.uvIndex))",
                    subtitle: getUVIndexDescription(Double(currentWeather.uvIndex))
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.farmColors.surface)
                .shadow(color: Color.black.opacity(0.05), radius: 6)
        )
    }

    private func getUVIndexDescription(_ uvIndex: Double) -> String {
        switch uvIndex {
        case 0..<3: return "Low"
        case 3..<6: return "Moderate"
        case 6..<8: return "High"
        case 8..<11: return "Very High"
        default: return "Extreme"
        }
    }
}

struct WeatherMetricCard: View {
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
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.farmColors.backgroundLight)
        )
    }
}

struct SunInformationCard: View {
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
        VStack(alignment: .leading, spacing: 16) {
            Text("Sun Information")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)

            HStack(spacing: 20) {
                VStack(spacing: 12) {
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

                VStack(alignment: .trailing, spacing: 12) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Daylight")
                            .font(.caption)
                            .foregroundColor(Color.farmColors.textSecondary)

                        Text(durationFormatter.string(from: sunTimes.dayLength) ?? "")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.textPrimary)
                    }

                    VStack(alignment: .trailing, spacing: 4) {
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
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.farmColors.surface)
                .shadow(color: Color.black.opacity(0.05), radius: 6)
        )
    }
}


struct HourlyForecastSection: View {
    let forecasts: [HourlyForecast]

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hourly Forecast")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(forecasts.enumerated()), id: \.offset) { index, forecast in
                        HourlyForecastItem(
                            forecast: forecast,
                            isFirst: index == 0,
                            timeFormatter: timeFormatter
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.farmColors.surface)
                .shadow(color: Color.farmColors.shadow, radius: 4, x: 0, y: 2)
        )
    }
}

struct HourlyForecastItem: View {
    let forecast: HourlyForecast
    let isFirst: Bool
    let timeFormatter: DateFormatter

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
            RoundedRectangle(cornerRadius: 18)
                .fill(isFirst ? Color.farmColors.primary.opacity(0.1) : Color.farmColors.backgroundLight)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(isFirst ? Color.farmColors.primary.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
        .frame(width: 80)
    }
}

#Preview {
    DetailedWeatherView(weather: ComprehensiveWeather.sampleData)
}
