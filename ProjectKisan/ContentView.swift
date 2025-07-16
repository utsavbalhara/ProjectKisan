//
//  ContentView.swift
//  ProjectKisan
//
//  Created by Utsav Balhara on 7/17/25.
//

import SwiftUI

struct ContentView: View {
    @State private var onboardingViewModel = OnboardingViewModel()

    var body: some View {
        Group {
            if onboardingViewModel.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .environment(onboardingViewModel)
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Farms", systemImage: "leaf.fill")
                }
            
            HomeView()
                .tabItem {
                    Label("Disease", systemImage: "camera.viewfinder")
                }
            
            MarketplaceView()
                .tabItem {
                    Label("Marketplace", systemImage: "storefront.fill")
                }
            
            RecipesView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(Color.farmColors.primary)
        .background(Color.farmColors.backgroundLight)
    }
}

#Preview {
    ContentView()
}
