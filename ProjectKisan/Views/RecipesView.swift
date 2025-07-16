import SwiftUI

struct RecipesView: View {
    @State private var viewModel = RecipesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    RecipesView()
}
