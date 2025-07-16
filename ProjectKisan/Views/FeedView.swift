import SwiftUI

struct FeedView: View {
    @State private var viewModel = FeedViewModel()
    
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
                    VStack(spacing: 16) {
                        ForEach(viewModel.farms) { farm in
                            FarmCard(farm: farm)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Farms")
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

#Preview {
    FeedView()
}
