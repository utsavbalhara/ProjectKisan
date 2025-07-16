//
//  FeatureSlideView.swift
//  ProjectKisan
//
//  Created by Utsav Balhara on 7/17/25.
//

import SwiftUI

struct FeatureSlideView: View {
    let systemImageName: String
    let title: String
    let description: String
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Enhanced icon with glass effect and animation
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 180, height: 180)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.farmColors.primary.opacity(0.3), Color.farmColors.primaryLight.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color.farmColors.primary.opacity(0.2), radius: 20, x: 0, y: 10)
                
                Image(systemName: systemImageName)
                    .font(.system(size: 64, weight: .medium))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.farmColors.primary, Color.farmColors.primaryLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        Color.farmColors.surface
                    )
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(
                .easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )

            VStack(spacing: 16) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.farmColors.textPrimary, Color.farmColors.primary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .multilineTextAlignment(.center)

                Text(description)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(Color.farmColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 20)
            }
            .padding(.horizontal)
            
            Spacer()
            Spacer()
        }
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    FeatureSlideView(
        systemImageName: "leaf.circle.fill",
        title: "Farms",
        description: "See what's up with your yield and buy products accordingly."
    )
}
