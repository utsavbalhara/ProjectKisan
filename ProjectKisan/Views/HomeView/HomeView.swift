import SwiftUI

struct HomeView: View {
    @State private var viewModel = CookViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    NewRecipeCard()
                        .frame(height: 180)
                }
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "e6ebe7"))
            .navigationTitle("Disease")
        }
    }
}

#Preview {
    HomeView()
}
