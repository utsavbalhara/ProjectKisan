import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ProfileHeaderCard(
                        profileData: viewModel.profileData,
                        onProfileTap: {
                            viewModel.showAccountDetails()
                        }
                    )
                    
                    HStack(spacing: 16) {
                        NavigationLink(destination: EarningsDetailView()) {
                            EarningsCard(
                                earnings: viewModel.formattedTotalEarnings,
                                lastUpdated: viewModel.lastUpdatedText
                            )
                        }
                        
                        NavigationLink(destination: RevenueDetailView()) {
                            RevenueCard(
                                revenue: viewModel.formattedTotalRevenue,
                                lastUpdated: viewModel.lastUpdatedText
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    OrderHistoryCard(
                        orders: viewModel.profileData.orderHistory
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
            }
            .background(
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
            )
            .navigationTitle("Profile")
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .sheet(isPresented: $viewModel.isShowingAccountDetails) {
                AccountDetailsSheet(profileData: viewModel.profileData)
            }
        }
    }
}

// MARK: - Profile Header Card
struct ProfileHeaderCard: View {
    let profileData: ProfileData
    let onProfileTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile Picture - Tappable
            Button(action: onProfileTap) {
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.farmColors.primary, Color.farmColors.primaryLight],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color.farmColors.primary, Color.farmColors.primaryLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
            )
            .shadow(color: Color.farmColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            
            // Farmer Info
            VStack(spacing: 8) {
                Text(profileData.farmerName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.secondary)
                    
                    Text(profileData.location)
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
            }
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [Color.farmColors.primary.opacity(0.3), Color.farmColors.primaryLight.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
    }
}


// MARK: - Order History Card
struct OrderHistoryCard: View {
    let orders: [OrderItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order History")
                        .font(.headline)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text("Track your purchases")
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "doc.text")
                    .font(.title2)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
            
            if orders.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(Color.farmColors.textSecondary.opacity(0.5))
                    
                    Text("No orders yet")
                        .font(.body)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Text("Your pesticide and fertilizer orders will appear here")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 15, x: 0, y: 8)
    }
}

// MARK: - Custom Button Style
struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: configuration.isPressed)
    }
}


#Preview {
    ProfileView()
}
