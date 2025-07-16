import SwiftUI

struct FeedView: View {
    @State private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Farms")
                    .font(.largeTitle)
                    .foregroundColor(Color.farmColors.textPrimary)
                    .padding()
                
                Spacer()
            }
            .background(Color.farmColors.backgroundLight)
            .navigationTitle("Farms")
        }
    }
}

#Preview {
    FeedView()
}
