//
//  WelcomeView.swift
//  ProjectKisan
//
//  Created by Utsav Balhara on 7/17/25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isAnimating = false
    @State private var showContent = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Enhanced welcome icon with multiple layers and animation
            ZStack {
                // Background circles for depth
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 200, height: 200)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .opacity(0.3)
                    .animation(
                        .easeInOut(duration: 4.0)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 160, height: 160)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.farmColors.primary.opacity(0.4), Color.farmColors.primaryLight.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .shadow(color: Color.farmColors.primary.opacity(0.3), radius: 25, x: 0, y: 15)
                
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 80, weight: .medium))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.farmColors.surface, Color.farmColors.backgroundLight],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        LinearGradient(
                            colors: [Color.farmColors.primary, Color.farmColors.primaryLight, Color.farmColors.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(isAnimating ? 15 : -5))
                    .animation(
                        .easeInOut(duration: 4.0)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }

            VStack(spacing: 20) {
                Text("Welcome to Project Kisan")
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
                    .scaleEffect(showContent ? 1.0 : 0.8)
                    .opacity(showContent ? 1.0 : 0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3), value: showContent)

                Text("Your all-in-one solution for modern farming.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(Color.farmColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .scaleEffect(showContent ? 1.0 : 0.8)
                    .opacity(showContent ? 1.0 : 0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.6), value: showContent)
            }
            .padding(.horizontal, 24)

            Spacer()
            Spacer()
        }
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isAnimating = true
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                showContent = true
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environment(OnboardingViewModel())
}
