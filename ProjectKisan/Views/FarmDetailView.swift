import SwiftUI

struct FarmDetailView: View {
    let farm: Farm
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.farmColors.backgroundLight,
                    Color.farmColors.backgroundMedium.opacity(0.3),
                    Color.farmColors.backgroundLight
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Main Farm Info (no card)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(farm.farmName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text("\(farm.typeOfCrop) • \(String(format: "%.1f", farm.areaInAcres)) acres")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.textSecondary)
                    }
                    .padding(.horizontal)
                    
                    // Current Stage (no card)
                    VStack(spacing: 16) {
                        HStack {
                            Text("Current Stage")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            Spacer()
                            
                            Text(farm.currentStage.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color.farmColors.primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.farmColors.primary.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        // Progress circles with centered lines
                        HStack(spacing: 0) {
                            ForEach(Array(CropStage.allCases.enumerated()), id: \.offset) { index, stage in
                                HStack(spacing: 0) {
                                    Circle()
                                        .fill(stageColor(for: stage))
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.farmColors.surface, lineWidth: 2)
                                        )
                                    
                                    if index < CropStage.allCases.count - 1 {
                                        Rectangle()
                                            .fill(stageLineColor(for: index))
                                            .frame(height: 2)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Weather Data Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "cloud.sun.fill")
                                .font(.title2)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.farmColors.primary, Color.farmColors.primaryLight],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("Weather Data")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.farmColors.textPrimary)
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            WeatherDataItem(title: "Temperature", value: "\(String(format: "%.1f", farm.weatherData.temperature))°C", icon: "thermometer")
                            WeatherDataItem(title: "Precipitation", value: "\(String(format: "%.1f", farm.weatherData.precipitation)) mm", icon: "drop.fill")
                            WeatherDataItem(title: "Wind Speed", value: "\(String(format: "%.1f", farm.weatherData.windSpeed)) km/h", icon: "wind")
                            WeatherDataItem(title: "Wind Direction", value: farm.weatherData.windDirection, icon: "location.north.fill")
                            WeatherDataItem(title: "Humidity", value: "\(String(format: "%.1f", farm.weatherData.humidity))%", icon: "humidity.fill")
                            WeatherDataItem(title: "Sunshine", value: "\(String(format: "%.1f", farm.weatherData.hoursOfSunshine)) hrs", icon: "sun.max.fill")
                        }
                    }
                    .padding(20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    // IoT Sensor Data Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "sensor.fill")
                                .font(.title2)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.farmColors.primary, Color.farmColors.primaryLight],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("IoT Sensor Data")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.farmColors.textPrimary)
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            SensorDataItem(title: "Soil Moisture", value: "\(String(format: "%.1f", farm.iotSensorData.soilMoisture))%", icon: "drop.circle.fill")
                            SensorDataItem(title: "Soil Temp", value: "\(String(format: "%.1f", farm.iotSensorData.soilTemperature))°C", icon: "thermometer.medium")
                            SensorDataItem(title: "Soil pH", value: String(format: "%.1f", farm.iotSensorData.soilPH), icon: "flask.fill")
                            SensorDataItem(title: "Air Temp", value: "\(String(format: "%.1f", farm.iotSensorData.airTemperature))°C", icon: "thermometer.sun.fill")
                            SensorDataItem(title: "Humidity", value: "\(String(format: "%.1f", farm.iotSensorData.humidity))%", icon: "humidity")
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(Color.farmColors.primary)
                                Text("Nutrient Levels")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.farmColors.textPrimary)
                            }
                            
                            Text(farm.iotSensorData.nutrientLevels)
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                                .padding(.leading, 24)
                        }
                    }
                    .padding(20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    // Crop Insights Button
                    NavigationLink(destination: CropInsightsView(farm: farm)) {
                        HStack {
                            Image(systemName: "brain.head.profile.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Crop Insights")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text("Get AI-powered farming recommendations")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [Color.farmColors.primary, Color.farmColors.primaryLight],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.farmColors.shadow.opacity(0.2), radius: 12, x: 0, y: 6)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
            }
        }
        .navigationTitle("Farm Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func stageColor(for stage: CropStage) -> Color {
        let currentIndex = CropStage.allCases.firstIndex(of: farm.currentStage) ?? 0
        let stageIndex = CropStage.allCases.firstIndex(of: stage) ?? 0
        
        if stageIndex < currentIndex {
            return Color.farmColors.successGreen
        } else if stageIndex == currentIndex {
            return Color.farmColors.primary
        } else {
            return Color.farmColors.textSecondary.opacity(0.3)
        }
    }
    
    private func stageTextColor(for stage: CropStage) -> Color {
        let currentIndex = CropStage.allCases.firstIndex(of: farm.currentStage) ?? 0
        let stageIndex = CropStage.allCases.firstIndex(of: stage) ?? 0
        
        if stageIndex <= currentIndex {
            return Color.farmColors.textPrimary
        } else {
            return Color.farmColors.textSecondary
        }
    }
    
    private func stageLineColor(for index: Int) -> Color {
        let currentIndex = CropStage.allCases.firstIndex(of: farm.currentStage) ?? 0
        
        if index < currentIndex {
            return Color.farmColors.successGreen
        } else {
            return Color.farmColors.textSecondary.opacity(0.3)
        }
    }
}

struct WeatherDataItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.farmColors.primary)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Spacer()
            }
            
            HStack {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
            }
        }
        .padding(12)
        .background(Color.farmColors.primary.opacity(0.05))
        .cornerRadius(8)
    }
}

struct SensorDataItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.farmColors.primary)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Spacer()
            }
            
            HStack {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
            }
        }
        .padding(12)
        .background(Color.farmColors.primary.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    let sampleWeather = WeatherData(
        temperature: 22.5,
        precipitation: 2.3,
        windSpeed: 12.4,
        windDirection: "NW",
        humidity: 68.2,
        hoursOfSunshine: 7.5
    )
    
    let sampleIoT = IoTSensorData(
        soilMoisture: 45.8,
        soilTemperature: 18.7,
        soilPH: 6.8,
        airTemperature: 21.3,
        humidity: 65.4,
        nutrientLevels: "Nitrogen: Good, Phosphorus: Moderate, Potassium: High"
    )
    
    NavigationStack {
        FarmDetailView(farm: Farm(
            farmName: "Wheat Farm Alpha",
            typeOfCrop: "Wheat",
            areaInAcres: 25.5,
            currentStage: .cropManagement,
            iotSensorId: "WF-001",
            weatherData: sampleWeather,
            iotSensorData: sampleIoT
        ))
    }
}
