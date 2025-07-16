//
//  ContentView.swift
//  sizzle.ai
//
//  Created by Utsav Balhara on 7/13/25.
//

import SwiftUI

struct ContentView: View {
    @State private var search = ""
    
    var body: some View {
        TabView {
            Tab("Disease", systemImage: "cross.case.fill") {
                HomeView()
            }
            Tab("Farms", systemImage: "leaf.fill") {
                FeedView()
            }
            Tab("Profile", systemImage: "person.fill") {
                RecipesView()
            }
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    SearchView()
                }
            }
        }
        .searchable(text: $search)
    }
}

#Preview {
    ContentView()
}
