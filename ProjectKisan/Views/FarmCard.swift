import SwiftUI

struct FarmCard: View {
    let farm: Farm
    
    var body: some View {
        NavigationLink(destination: FarmDetailView(farm: farm)) {
            ZStack {
                Group {
                    if let farmImage = farm.farmImage {
                        Image(uiImage: farmImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Image(farm.typeOfCrop.lowercased())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .frame(height: 200)
                .clipped()
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.7)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(farm.typeOfCrop)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("\(String(format: "%.1f", farm.areaInAcres)) acres")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Current Stage")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text(farm.currentStage.rawValue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        
                        
                    }
                    .padding(20)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(16)
        .shadow(color: Color.farmColors.shadow, radius: 8, x: 0, y: 4)
    }
}

#Preview {
    let sampleWeatherWheat = WeatherData(
        temperature: 22.5,
        precipitation: 2.3,
        windSpeed: 12.4,
        windDirection: "NW",
        humidity: 68.2,
        hoursOfSunshine: 7.5
    )
    
    let sampleIoTWheat = IoTSensorData(
        soilMoisture: 45.8,
        soilTemperature: 18.7,
        soilPH: 6.8,
        airTemperature: 21.3,
        humidity: 65.4,
        nutrientLevels: "Nitrogen: Good, Phosphorus: Moderate, Potassium: High"
    )
    
    let sampleWeatherRice = WeatherData(
        temperature: 28.1,
        precipitation: 15.7,
        windSpeed: 8.9,
        windDirection: "SE",
        humidity: 82.5,
        hoursOfSunshine: 6.2
    )
    
    let sampleIoTRice = IoTSensorData(
        soilMoisture: 78.3,
        soilTemperature: 25.4,
        soilPH: 6.2,
        airTemperature: 27.8,
        humidity: 80.1,
        nutrientLevels: "Nitrogen: High, Phosphorus: Good, Potassium: Moderate"
    )
    
    NavigationStack {
        VStack(spacing: 16) {
            FarmCard(farm: Farm(
                farmName: "Wheat Farm Alpha",
                typeOfCrop: "Wheat",
                areaInAcres: 25.5,
                currentStage: .cropManagement,
                iotSensorId: "WF-001",
                weatherData: sampleWeatherWheat,
                iotSensorData: sampleIoTWheat
            ))
            FarmCard(farm: Farm(
                farmName: "Rice Farm Beta",
                typeOfCrop: "Rice",
                areaInAcres: 18.0,
                currentStage: .irrigation,
                iotSensorId: "RF-002",
                weatherData: sampleWeatherRice,
                iotSensorData: sampleIoTRice
            ))
        }
        .padding()
    }
}
