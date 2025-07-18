import SwiftUI
import PhotosUI

struct AddFarmView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var feedViewModel: FeedViewModel
    
    @State private var farmName = ""
    @State private var cropType = ""
    @State private var iotSensorId = ""
    @State private var area = ""
    @State private var currentStage: CropStage = .preparation
    @State private var farmImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isAddingFarm = false
    @State private var showImageSourceOptions = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    let cropTypes = ["Wheat", "Rice", "Corn", "Tomato", "Potato", "Cotton", "Sugarcane", "Soybean", "Barley", "Millet"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color.farmColors.primary)
                        
                        Text("Add New Farm")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text("Start your journey with a new farm")
                            .font(.subheadline)
                            .foregroundColor(Color.farmColors.textSecondary)
                    }
                    .padding(.top, 20)
                    
                    // Form
                    VStack(spacing: 16) {
                        // Farm Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Farm Name")
                                .font(.headline)
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            TextField("Enter farm name", text: $farmName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Crop Type
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Crop Type")
                                .font(.headline)
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            Menu {
                                ForEach(cropTypes, id: \.self) { crop in
                                    Button(crop) {
                                        cropType = crop
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(cropType.isEmpty ? "Select crop type" : cropType)
                                        .foregroundColor(cropType.isEmpty ? .gray : Color.farmColors.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                        
                        // Area
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Area (acres)")
                                .font(.headline)
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            TextField("Enter area in acres", text: $area)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        
                        // IoT Sensor ID
                        VStack(alignment: .leading, spacing: 8) {
                            Text("IoT Sensor ID")
                                .font(.headline)
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            TextField("Enter sensor ID", text: $iotSensorId)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Current Stage
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Stage")
                                .font(.headline)
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            Menu {
                                ForEach(CropStage.allCases, id: \.self) { stage in
                                    Button(stage.rawValue) {
                                        currentStage = stage
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(currentStage.rawValue)
                                        .foregroundColor(Color.farmColors.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                        
                        // Photo Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Farm Photo (Optional)")
                                .font(.headline)
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            Button(action: {
                                self.showImageSourceOptions = true
                            }) {
                                HStack {
                                    if let farmImage = farmImage {
                                        Image(uiImage: farmImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        
                                        VStack(alignment: .leading) {
                                            Text("Farm photo selected")
                                                .font(.subheadline)
                                                .foregroundColor(Color.farmColors.textPrimary)
                                            Text("Tap to change photo")
                                                .font(.caption)
                                                .foregroundColor(Color.farmColors.textSecondary)
                                        }
                                    } else {
                                        Image(systemName: "camera.fill")
                                            .font(.title2)
                                            .foregroundColor(Color.farmColors.primary)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Add Farm Photo")
                                                .font(.subheadline)
                                                .foregroundColor(Color.farmColors.textPrimary)
                                            Text("Take or select a photo")
                                                .font(.caption)
                                                .foregroundColor(Color.farmColors.textSecondary)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Add Button
                    Button(action: addFarm) {
                        HStack {
                            if isAddingFarm {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                            }
                            
                            Text(isAddingFarm ? "Adding Farm..." : "Add Farm")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: isFormValid ? [Color.farmColors.primary, Color.farmColors.primaryLight] : [Color.gray],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .disabled(!isFormValid || isAddingFarm)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.farmColors.primary)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(selectedImage: self.$farmImage, sourceType: self.sourceType)
        }
        .actionSheet(isPresented: $showImageSourceOptions) {
            ActionSheet(title: Text("Choose Image Source"), buttons: [
                .default(Text("Camera")) {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        self.sourceType = .camera
                        self.showingImagePicker = true
                    }
                },
                .default(Text("Photo Library")) {
                    self.sourceType = .photoLibrary
                    self.showingImagePicker = true
                },
                .cancel()
            ])
        }
    }
    
    private var isFormValid: Bool {
        !farmName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !cropType.isEmpty &&
        !area.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !iotSensorId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func addFarm() {
        guard isFormValid else { return }
        
        isAddingFarm = true
        
        // Create new farm with random data similar to existing farms
        let newFarm = Farm(
            farmName: farmName.trimmingCharacters(in: .whitespacesAndNewlines),
            typeOfCrop: cropType,
            areaInAcres: Double(area) ?? 0.0,
            currentStage: currentStage,
            iotSensorId: iotSensorId.trimmingCharacters(in: .whitespacesAndNewlines),
            weatherData: generateRandomWeatherData(),
            iotSensorData: generateRandomIoTData(),
            farmImage: farmImage
        )
        
        // Add to feed view model
        feedViewModel.addFarm(newFarm)
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isAddingFarm = false
            dismiss()
        }
    }
    
    private func generateRandomWeatherData() -> WeatherData {
        return WeatherData(
            temperature: Double.random(in: 20...35),
            precipitation: Double.random(in: 0...15),
            windSpeed: Double.random(in: 5...20),
            windDirection: ["N", "NE", "E", "SE", "S", "SW", "W", "NW"].randomElement() ?? "N",
            humidity: Double.random(in: 40...80),
            hoursOfSunshine: Double.random(in: 5...12)
        )
    }
    
    private func generateRandomIoTData() -> IoTSensorData {
        let nitrogenLevels = ["Low", "Moderate", "Good", "High"]
        let phosphorusLevels = ["Low", "Moderate", "Good", "High"]
        let potassiumLevels = ["Low", "Moderate", "Good", "High"]
        
        return IoTSensorData(
            soilMoisture: Double.random(in: 30...70),
            soilTemperature: Double.random(in: 18...28),
            soilPH: Double.random(in: 6.0...7.5),
            airTemperature: Double.random(in: 20...35),
            humidity: Double.random(in: 40...80),
            nutrientLevels: "Nitrogen: \(nitrogenLevels.randomElement()!), Phosphorus: \(phosphorusLevels.randomElement()!), Potassium: \(potassiumLevels.randomElement()!)"
        )
    }
}

#Preview {
    AddFarmView(feedViewModel: FeedViewModel())
}
