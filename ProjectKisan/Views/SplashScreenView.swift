//
//  SplashScreenView.swift
//  ProjectKisan
//
//  Created by Roo on 7/17/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5

    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image(systemName: "leaf.circle.fill")
                        .font(.system(size: 120))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.farmColors.surface, Color.farmColors.primary)
                    Text("Project Kisan")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.textPrimary)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.farmColors.backgroundLight)
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}