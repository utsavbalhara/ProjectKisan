import SwiftUI

struct AccountDetailsSheet: View {
    let profileData: ProfileData
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background with glass effect
                LinearGradient(
                    colors: [
                        Color.farmColors.backgroundLight,
                        Color.farmColors.backgroundMedium.opacity(0.2),
                        Color.farmColors.backgroundLight
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Section
                        ProfileSection(profileData: profileData)
                        
                        // Account Information
                        AccountInformationSection()
                        
                        // Farm Details
                        FarmDetailsSection(farms: profileData.farms)
                        
                        // Settings
                        SettingsSection()
                        
                        // Bottom spacing
                        Spacer()
                            .frame(height: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Account Details")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.farmColors.primary)
                }
            }
        }
    }
}

// MARK: - Profile Section
struct ProfileSection: View {
    let profileData: ProfileData
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile Picture
            Image(systemName: profileData.profileImageName)
                .font(.system(size: 100))
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
                        .frame(width: 120, height: 120)
                )
                .overlay(
                    Circle()
                        .stroke(Color.farmColors.primary.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                )
            
            VStack(spacing: 8) {
                Text(profileData.farmerName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Text(profileData.location)
                        .font(.body)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
            }
            
            Button("Edit Profile") {
                // TODO: Implement edit profile functionality
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.farmColors.primary)
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 6)    }
}

// MARK: - Account Information Section
struct AccountInformationSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account Information")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)
            
            VStack(spacing: 12) {
                AccountInfoRow(
                    icon: "phone.fill",
                    title: "Phone Number",
                    value: "+91 98765 43210"
                )
                
                AccountInfoRow(
                    icon: "envelope.fill",
                    title: "Email",
                    value: "raj.kumar@farmer.com"
                )
                
                AccountInfoRow(
                    icon: "calendar",
                    title: "Member Since",
                    value: "January 2024"
                )
                
                AccountInfoRow(
                    icon: "shield.checkered",
                    title: "Verification Status",
                    value: "Verified"
                )
            }
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 6)
    }
}

// MARK: - Farm Details Section
struct FarmDetailsSection: View {
    let farms: [Farm]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Farm Details")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(farms.indices, id: \.self) { index in
                    FarmInfoRow(
                        farmName: "Farm \(index + 1)",
                        farm: farms[index]
                    )
                }
            }
            
            let totalAcres = farms.reduce(0) { $0 + $1.areaInAcres }
            
            HStack {
                Text("Total Area:")
                    .font(.body)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Spacer()
                
                Text("\(totalAcres, specifier: "%.1f") acres")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color.farmColors.primary)
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 6)
    }
}

// MARK: - Settings Section
struct SettingsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    action: {}
                )
                
                SettingsRow(
                    icon: "globe",
                    title: "Language",
                    action: {}
                )
                
                SettingsRow(
                    icon: "lock.fill",
                    title: "Privacy & Security",
                    action: {}
                )
                
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    action: {}
                )
            }
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 6)
    }
}

// MARK: - Supporting Views
struct AccountInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(Color.farmColors.primary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(Color.farmColors.textPrimary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct FarmInfoRow: View {
    let farmName: String
    let farm: Farm
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "leaf.fill")
                .font(.body)
                .foregroundColor(Color.farmColors.successGreen)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(farmName)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Text("\(farm.typeOfCrop) • \(farm.areaInAcres, specifier: "%.1f") acres")
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
            
            Spacer()
            
            Text(farm.currentStage.rawValue)
                .font(.caption)
                .foregroundColor(Color.farmColors.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.farmColors.primary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(.vertical, 4)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(Color.farmColors.primary)
                    .frame(width: 20)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AccountDetailsSheet(
        profileData: ProfileData()
    )
}
