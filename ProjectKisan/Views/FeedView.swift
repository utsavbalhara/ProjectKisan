import SwiftUI

struct FeedView: View {
    @State private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.farms) { farm in
                        FarmCard(farm: farm)
                    }
                }
                .padding()
            }
            .navigationTitle("Farms")
        }
    }
}

#Preview {
    FeedView()
}
