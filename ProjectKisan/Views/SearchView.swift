import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack {
            Text("Search")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Search")
        .searchable(text: $viewModel.searchText)
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}