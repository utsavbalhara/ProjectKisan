import SwiftUI

struct RecipesView: View {
    @State private var viewModel = RecipesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Consistent background
                LinearGradient(
                    colors: [
                        Color.farmColors.backgroundLight,
                        Color.farmColors.backgroundMedium.opacity(0.3),
                        Color.farmColors.backgroundLight
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    
                    // Profile Card with glass effect
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.farmColors.primary, Color.farmColors.primaryLight],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Your Profile")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text("Manage your account and preferences")
                            .font(.body)
                            .foregroundColor(Color.farmColors.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Coming Soon")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.primary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.farmColors.primary.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(24)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 15, x: 0, y: 8)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 40)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    RecipesView()
}
