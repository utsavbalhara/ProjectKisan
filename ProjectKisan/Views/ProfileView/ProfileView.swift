import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var scrollOffset: CGFloat = 0
    @Namespace private var profileNamespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background with Liquid Glass inspiration
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
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Profile Header Card
                        ProfileHeaderCard(
                            profileData: viewModel.profileData,
                            onProfileTap: {
                                viewModel.showAccountDetails()
                            }
                        )
                        
                        // Earnings Card
                        if !viewModel.isShowingEarningsDetail {
                            EarningsCard(
                                earnings: viewModel.formattedTotalEarnings,
                                lastUpdated: viewModel.lastUpdatedText,
                                onTap: {
                                    viewModel.showEarningsDetail()
                                }
                            )
                            .matchedGeometryEffect(id: "earnings", in: profileNamespace)
                        } else {
                            EarningsDetailCard(
                                breakdowns: viewModel.selectedEarningsBreakdown,
                                onBackTap: {
                                    viewModel.hideEarningsDetail()
                                }
                            )
                            .matchedGeometryEffect(id: "earnings", in: profileNamespace)
                        }
                        
                        // Revenue Card
                        if !viewModel.isShowingRevenueDetail {
                            RevenueCard(
                                revenue: viewModel.formattedTotalRevenue,
                                lastUpdated: viewModel.lastUpdatedText,
                                onTap: {
                                    viewModel.showRevenueDetail()
                                }
                            )
                            .matchedGeometryEffect(id: "revenue", in: profileNamespace)
                        } else {
                            RevenueDetailCard(
                                breakdowns: viewModel.selectedEarningsBreakdown,
                                onBackTap: {
                                    viewModel.hideRevenueDetail()
                                }
                            )
                            .matchedGeometryEffect(id: "revenue", in: profileNamespace)
                        }
                        
                        // Order History Card
                        OrderHistoryCard(
                            orders: viewModel.profileData.orderHistory
                        )
                        
                        // Bottom spacing for tab bar
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
                .coordinateSpace(name: "scroll")
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $viewModel.isShowingAccountDetails) {
            AccountDetailsSheet(profileData: viewModel.profileData)
        }
    }
}

// MARK: - Profile Header Card
struct ProfileHeaderCard: View {
    let profileData: ProfileData
    let onProfileTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile Picture
            Button(action: onProfileTap) {
                VStack(spacing: 12) {
                    Image(systemName: profileData.profileImageName)
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.farmColors.primary, Color.farmColors.primaryLight],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 90, height: 90)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.farmColors.primary.opacity(0.3), lineWidth: 2)
                                .frame(width: 90, height: 90)
                        )
                    
                    // Farmer Info
                    VStack(spacing: 4) {
                        Text(profileData.farmerName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                            
                            Text(profileData.location)
                                .font(.body)
                                .foregroundColor(Color.farmColors.textSecondary)
                        }
                    }
                }
            }
            .buttonStyle(GlassButtonStyle())
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

// MARK: - Earnings Card
struct EarningsCard: View {
    let earnings: String
    let lastUpdated: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Estimated Earnings")
                            .font(.headline)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text(earnings)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.primary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title2)
                            .foregroundColor(Color.farmColors.successGreen)
                        
                        Button(action: {}) {
                            Image(systemName: "info.circle")
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                        }
                    }
                }
                
                HStack {
                    Text(lastUpdated)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("Tap for details")
                            .font(.caption)
                            .foregroundColor(Color.farmColors.primary)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(Color.farmColors.primary)
                    }
                }
            }
            .padding(24)
        }
        .buttonStyle(GlassButtonStyle())
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 15, x: 0, y: 8)
    }
}

// MARK: - Revenue Card
struct RevenueCard: View {
    let revenue: String
    let lastUpdated: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Revenue Generated")
                            .font(.headline)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text(revenue)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Image(systemName: "banknote")
                            .font(.title2)
                            .foregroundColor(Color.farmColors.secondary)
                        
                        Button(action: {}) {
                            Image(systemName: "info.circle")
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                        }
                    }
                }
                
                HStack {
                    Text(lastUpdated)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("Tap for details")
                            .font(.caption)
                            .foregroundColor(Color.farmColors.secondary)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(Color.farmColors.secondary)
                    }
                }
            }
            .padding(24)
        }
        .buttonStyle(GlassButtonStyle())
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.farmColors.secondary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 15, x: 0, y: 8)
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

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ProfileView()
}
