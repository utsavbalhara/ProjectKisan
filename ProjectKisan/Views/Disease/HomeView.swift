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
                            .shadow(color: Color.black.opacity(0.05), radius: 6)
                    }
                    .padding(.vertical, 0)
                }
            }
            .navigationTitle("Disease Detection")
        }
    }
}

#Preview {
    HomeView()
}
