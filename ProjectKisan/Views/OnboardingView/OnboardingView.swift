//
//  OnboardingView.swift
//  ProjectKisan
//
//  Created by Utsav Balhara on 7/17/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(OnboardingViewModel.self) private var envViewModel
    @Namespace private var animation

    var body: some View {
        @Bindable var viewModel = envViewModel
        ZStack {
            // Enhanced background with gradient
            LinearGradient(
                colors: [
                    Color.farmColors.backgroundLight,
                    Color.farmColors.backgroundMedium,
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            GlassEffectContainer {
                TabView(selection: $viewModel.currentOnboardingPage) {
                    WelcomeView()
                        .tag(0)
                        .glassEffectID("page_0", in: animation)

                    LanguageSelectionView()
                        .tag(1)
                        .glassEffectID("page_1", in: animation)

                    FarmsFeatureView()
                        .tag(2)
                        .glassEffectID("page_2", in: animation)

                    DiseaseDetectionFeatureView()
                        .tag(3)
                        .glassEffectID("page_3", in: animation)

                    SupportFeatureView()
                        .tag(4)
                        .glassEffectID("page_4", in: animation)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.currentOnboardingPage)
            }
            
            VStack {
                Spacer()
                OnboardingControl(
                    pageCount: 5,
                    currentPage: $viewModel.currentOnboardingPage,
                    onComplete: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            envViewModel.hasCompletedOnboarding = true
                        }
                    }
                )
            }
        }
    }
}

struct OnboardingControl: View {
    let pageCount: Int
    @Binding var currentPage: Int
    let onComplete: () -> Void
    @Environment(OnboardingViewModel.self) private var viewModel
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

    private var isNextButtonDisabled: Bool {
        currentPage == 1 && viewModel.selectedLanguage == nil
    }

    var body: some View {
        HStack(spacing: 16) {
            PageIndicator(pageCount: pageCount, currentPage: $currentPage)
            Spacer()
            
            Button(action: {
                hapticGenerator.impactOccurred()
                if currentPage == pageCount - 1 {
                    onComplete()
                } else {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        currentPage += 1
                    }
                }
            }) {
                HStack(spacing: 8) {
                    Text(currentPage == pageCount - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Image(systemName: currentPage == pageCount - 1 ? "checkmark" : "arrow.right")
                        .font(.title3.bold())
                }
                .foregroundColor(Color.farmColors.surface)
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color.farmColors.primary, Color.farmColors.primaryLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 25, style: .continuous)
                )
                .glassEffect(.regular.tint(Color.farmColors.primary).interactive())
                .shadow(color: Color.farmColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .scaleEffect(currentPage == pageCount - 1 ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentPage)
            .disabled(isNextButtonDisabled)
            .opacity(isNextButtonDisabled ? 0.6 : 1.0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30.0, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 30.0, style: .continuous)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct PageIndicator: View {
    let pageCount: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(index == currentPage ? Color.farmColors.primary : Color.farmColors.textSecondary.opacity(0.5))
                    .frame(
                        width: index == currentPage ? 24 : 8,
                        height: 8
                    )
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environment(OnboardingViewModel())
}
