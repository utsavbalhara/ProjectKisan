import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @StateObject private var productManager = ProductManager.shared
    @State private var showingOrderHistory = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ProfileHeaderSection(
                        profileData: viewModel.profileData,
                        onProfileTap: {
                            viewModel.showAccountDetails()
                        }
                    )
                    
                    VStack(spacing: 16) {
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
                    
                    Button(action: {
                        showingOrderHistory = true
                    }) {
                        IntegratedOrderHistoryCard()
                    }
                    .buttonStyle(GlassButtonStyle())
                    .padding(.horizontal, 20)
                    
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
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $viewModel.isShowingAccountDetails) {
                AccountDetailsSheet(profileData: viewModel.profileData)
            }
            .sheet(isPresented: $showingOrderHistory) {
                OrderHistoryView()
            }
            .onAppear {
                productManager.loadOrderHistory()
            }
        }
    }
}

// MARK: - Profile Header Section
struct ProfileHeaderSection: View {
    let profileData: ProfileData
    let onProfileTap: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
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
            .frame(width: 120, height: 120)
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
            
            // Farmer Info - Plain Text (No Card)
            VStack(spacing: 12) {
                Text(profileData.farmerName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.secondary)
                    
                    Text(profileData.location)
                        .font(.title3)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
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

// MARK: - Integrated Order History Card
struct IntegratedOrderHistoryCard: View {
    @StateObject private var productManager = ProductManager.shared
    
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
                
                HStack(spacing: 8) {
                    if productManager.orderHistory.count > 0 {
                        Text("\(productManager.orderHistory.count)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color.farmColors.primary)
                            .clipShape(Circle())
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.primary)
                }
            }
            
            if productManager.orderHistory.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(Color.farmColors.textSecondary.opacity(0.5))
                    
                    Text("No orders yet")
                        .font(.body)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Text("Your product orders will appear here after checkout")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(productManager.totalOrdersCount) Orders")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.farmColors.textPrimary)
                            
                            Text("Total spent: $\(productManager.totalOrderValue)")
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Recent Order")
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                            
                            if let latestOrder = productManager.orderHistory.sorted(by: { $0.orderDate > $1.orderDate }).first {
                                Text(latestOrder.orderDate, style: .date)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.farmColors.primary)
                            }
                        }
                    }
                    
                    Text("Tap to view full order history")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.vertical, 12)
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
