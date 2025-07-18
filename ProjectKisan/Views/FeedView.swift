import SwiftUI

struct FeedView: View {
    @State private var viewModel = FeedViewModel()
    @State private var comprehensiveWeather = ComprehensiveWeather.sampleData
    @State private var showingAddFarmView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Consistent background
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
                    VStack(spacing: 24) {
                        // Weather Dashboard Section
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Weather")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.farmColors.textPrimary)
                                    
                                    Text("Real-time conditions for optimal farming")
                                        .font(.subheadline)
                                        .foregroundColor(Color.farmColors.textSecondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    // Refresh weather data
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        // In a real app, this would refresh the weather data
                                    }
                                }) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.title3)
                                        .foregroundColor(Color.farmColors.primary)
                                }
                            }
                            .padding(.horizontal, 16)
                            
                            CompactWeatherDashboard(weather: comprehensiveWeather)
                        }
                        
                        // My Farms Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("My Farms")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.farmColors.textPrimary)
                                    
                                    Text("\(viewModel.farms.count) farms • \(String(format: "%.1f", viewModel.farms.map { $0.areaInAcres }.reduce(0, +))) acres total")
                                        .font(.subheadline)
                                        .foregroundColor(Color.farmColors.textSecondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    showingAddFarmView = true
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(Color.farmColors.primary)
                                }
                            }
                            .padding(.horizontal, 16)
                            
                            VStack(spacing: 16) {
                                ForEach(viewModel.farms) { farm in
                                    FarmCard(farm: farm)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .refreshable {
                    // Refresh both weather and farm data
                    await refreshData()
                }
            }
            .navigationTitle("Smart Farming")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingAddFarmView) {
            AddFarmView(feedViewModel: viewModel)
        }
    }
    
    @MainActor
    private func refreshData() async {
        // In a real app, this would fetch fresh weather and farm data
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay for demo
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Update weather data (in real app, this would come from an API)
            comprehensiveWeather = ComprehensiveWeather.sampleData
        }
    }
}

#Preview {
    FeedView()
}
