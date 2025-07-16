//
//  ContentView.swift
//  sizzle.ai
//
//  Created by Utsav Balhara on 7/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Farms", systemImage: "leaf.fill") {
                FeedView()
            }
            Tab("Disease", systemImage: "cross.case.fill") {
                HomeView()
            }
            Tab("Marketplace", systemImage: "storefront.fill") {
                MarketplaceView()
            }
            Tab("Profile", systemImage: "person.fill") {
                RecipesView()
            }
        }
        .tint(Color.farmColors.primary)
    }
}

#Preview {
    ContentView()
}
