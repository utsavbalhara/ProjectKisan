import SwiftUI

struct HomeView: View {
    @State private var viewModel = CookViewModel()
    
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
                    VStack(spacing: 20) {
                        NewRecipeCard()
                            .frame(height: 200)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Disease Detection")
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

#Preview {
    HomeView()
}
