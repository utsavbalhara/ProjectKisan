import SwiftUI

struct FeedView: View {
    @State private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Farms")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Farms")
        }
    }
}

#Preview {
    FeedView()
}
