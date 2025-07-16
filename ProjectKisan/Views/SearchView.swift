import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack {
            Text("Search")
                .font(.largeTitle)
                .foregroundColor(Color.farmColors.textPrimary)
                .padding()
            
            Spacer()
        }
        .background(Color.farmColors.backgroundLight)
        .navigationTitle("Search")
        .searchable(text: $viewModel.searchText)
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}