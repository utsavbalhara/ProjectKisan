import SwiftUI

struct CropInsightsView: View {
    let farm: Farm
    @State private var insights: CropInsights?
    @State private var insightsService = CropInsightsService()
    @State private var showingProductsSheet = false
    
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
                VStack(spacing: 20) {
                    if insightsService.isGenerating {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                                .tint(Color.farmColors.primary)
                            
                            Text("Analyzing farm conditions...")
                                .font(.subheadline)
                                .foregroundColor(Color.farmColors.textSecondary)
                        }
                        .padding(40)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    } else if let insights = insights {
                        insightsContent(insights)
                    } else if let error = insightsService.lastError {
                        errorView(error)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Crop Insights")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadInsights()
        }
        .sheet(isPresented: $showingProductsSheet) {
            if let products = insights?.suggestedProducts {
                SuggestedProductsView(products: products)
            }
        }
    }
    
    @ViewBuilder
    private func insightsContent(_ insights: CropInsights) -> some View {
        // Daily Tasks Section
        insightCard(
            title: "Daily Tasks",
            icon: "checkmark.circle.fill",
            color: Color.farmColors.primary
        ) {
            VStack(spacing: 12) {
                ForEach(Array(insights.taskRecommendations.enumerated()), id: \.offset) { index, task in
                    TaskRecommendationCard(task: task)
                        .background(Color.farmColors.primary.opacity(0.05))
                        .cornerRadius(8)
                }
            }
        }
        
        // Pest & Disease Alerts Section
        if !insights.pestAlerts.isEmpty {
            insightCard(
                title: "Pest & Disease Alerts",
                icon: "exclamationmark.triangle.fill",
                color: .orange
            ) {
                VStack(spacing: 12) {
                    ForEach(Array(insights.pestAlerts.enumerated()), id: \.offset) { index, alert in
                        PestAlertCard(alert: alert)
                            .background(Color.orange.opacity(0.05))
                            .cornerRadius(8)
                    }
                }
            }
        }
        
        // Fertilizer Advice Section
        insightCard(
            title: "Fertilizer Recommendations",
            icon: "leaf.fill",
            color: Color.farmColors.successGreen
        ) {
            FertilizerAdviceCard(advice: insights.fertilizerAdvice)
        }
        
        // Maintenance Insights Section
        insightCard(
            title: "Maintenance Insights",
            icon: "wrench.and.screwdriver.fill",
            color: Color.farmColors.secondary
        ) {
            Text(insights.maintenanceInsights)
                .font(.body)
                .foregroundColor(Color.farmColors.textPrimary)
                .multilineTextAlignment(.leading)
        }
        
        // Suggested Products Button
        Button(action: {
            showingProductsSheet = true
        }) {
            HStack {
                Image(systemName: "cart.fill")
                    .font(.title2)
                
                Text("View Suggested Products")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.farmColors.primary, Color.farmColors.primaryLight],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func insightCard<Content: View>(
        title: String,
        icon: String,
        color: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
            }
            
            content()
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    @ViewBuilder
    private func errorView(_ error: CropInsightsError) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Unable to Generate Insights")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)
            
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(Color.farmColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await loadInsights()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.farmColors.primary)
        }
        .padding(30)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private func loadInsights() async {
        do {
            insights = try await insightsService.generateInsights(for: farm)
        } catch {
            // Error handling is managed by the service's lastError property
        }
    }
}

struct TaskRecommendationCard: View {
    let task: TaskRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task.task)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
                
                priorityBadge(task.priority)
            }
            
            Text(task.reason)
                .font(.caption)
                .foregroundColor(Color.farmColors.textSecondary)
            
            HStack {
                Image(systemName: "clock.fill")
                    .font(.caption2)
                    .foregroundColor(Color.farmColors.primary)
                
                Text("Best time: \(task.timing)")
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
        }
        .padding(12)
    }
    
    @ViewBuilder
    private func priorityBadge(_ priority: Int) -> some View {
        let color: Color = priority >= 4 ? .red : priority >= 3 ? .orange : Color.farmColors.primary
        let text = priority >= 4 ? "Urgent" : priority >= 3 ? "Important" : "Normal"
        
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(8)
    }
}

struct PestAlertCard: View {
    let alert: PestAlert
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(alert.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
                
                riskLevelBadge(alert.riskLevel)
            }
            
            Text(alert.weatherFactors)
                .font(.caption)
                .foregroundColor(Color.farmColors.textSecondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Preventive Actions:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                ForEach(alert.preventiveActions, id: \.self) { action in
                    HStack {
                        Text("•")
                            .foregroundColor(Color.farmColors.primary)
                        Text(action)
                            .font(.caption)
                            .foregroundColor(Color.farmColors.textSecondary)
                    }
                }
            }
        }
        .padding(12)
    }
    
    @ViewBuilder
    private func riskLevelBadge(_ level: Int) -> some View {
        let color: Color = level >= 4 ? .red : level >= 3 ? .orange : .yellow
        let text = level >= 4 ? "Critical" : level >= 3 ? "High" : "Medium"
        
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(8)
    }
}

struct FertilizerAdviceCard: View {
    let advice: FertilizerRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(advice.fertilizerType)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
            }
            
            Text(advice.reasoning)
                .font(.caption)
                .foregroundColor(Color.farmColors.textSecondary)
            
            HStack {
                Image(systemName: "timer")
                    .font(.caption2)
                    .foregroundColor(Color.farmColors.primary)
                
                Text("Timing: \(advice.applicationTiming)")
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
            
            HStack {
                Image(systemName: "drop.fill")
                    .font(.caption2)
                    .foregroundColor(Color.farmColors.primary)
                
                Text("Rate: \(advice.applicationRate)")
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
        }
        .padding(12)
        .background(Color.farmColors.successGreen.opacity(0.05))
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
        CropInsightsView(farm: Farm(
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
