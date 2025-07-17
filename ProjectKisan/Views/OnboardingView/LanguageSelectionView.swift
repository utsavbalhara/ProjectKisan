//
//  LanguageSelectionView.swift
//  ProjectKisan
//
//  Created by Utsav Balhara on 7/17/25.
//

import SwiftUI

struct LanguageSelectionView: View {
    @Environment(OnboardingViewModel.self) private var viewModel
    @State private var selectedLanguage: String?
    @Namespace private var animation

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Choose Your Language\nभाषा चुने")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.farmColors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            VStack(spacing: 20) {
                LanguageButton(language: "English", namespace: animation, isSelected: selectedLanguage == "English") {
                    selectLanguage("English")
                }
                LanguageButton(language: "हिंदी", namespace: animation, isSelected: selectedLanguage == "हिंदी") {
                    selectLanguage("हिंदी")
                }
            }
            .padding()

            Spacer()
            Spacer()
        }
        .padding()
    }

    private func selectLanguage(_ language: String) {
        withAnimation(.spring()) {
            selectedLanguage = language
            viewModel.selectedLanguage = language
        }
    }
}

struct LanguageButton: View {
    let language: String
    let namespace: Namespace.ID
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(language)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .primary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        if isSelected {
                            Color.farmColors.primary
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .matchedGeometryEffect(id: "selectionBackground", in: namespace)
                        } else {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.farmColors.primary.opacity(0.5), lineWidth: 1)
                                )
                        }
                    }
                )
        }
        .accentColor(Color.farmColors.textPrimary)
    }
}

#Preview {
    LanguageSelectionView()
        .environment(OnboardingViewModel())
}
