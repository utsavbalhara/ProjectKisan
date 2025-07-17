import SwiftUI

struct EarningsDetailCard: View {
    let breakdowns: [EarningsBreakdown]
    let onBackTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with back button
            HStack {
                Button(action: onBackTap) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.body)
                            .foregroundColor(Color.farmColors.primary)
                        
                        Text("Back")
                            .font(.body)
                            .foregroundColor(Color.farmColors.primary)
                    }
                }
                .buttonStyle(GlassButtonStyle())
                
                Spacer()
                
                Text("Earnings by Farm")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
            }
            
            // Total earnings summary
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Estimated Earnings")
                    .font(.subheadline)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                let totalEarnings = breakdowns.reduce(0) { $0 + $1.estimatedEarnings }
                Text("₹\(Int(totalEarnings).formatted())")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.primary)
            }
            .padding(.bottom, 8)
            
            // Farm breakdowns
            LazyVStack(spacing: 12) {
                ForEach(breakdowns) { breakdown in
                    FarmEarningsRow(breakdown: breakdown)
                }
            }
            
            // Info section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Text("Market Data Information")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
                
                Text("Estimated earnings are updated from current market data and may vary based on actual harvest quality, weather conditions, and market fluctuations.")
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary.opacity(0.8))
                    .lineLimit(nil)
            }
            .padding(.top, 8)
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

struct FarmEarningsRow: View {
    let breakdown: EarningsBreakdown
    
    var body: some View {
        HStack(spacing: 16) {
            // Farm icon and info
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    cropIconView(for: breakdown.cropType)
                        .font(.title3)
                        .foregroundColor(cropColor(for: breakdown.cropType))
                        .frame(width: 24, height: 24)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(breakdown.farmName)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text(breakdown.cropType)
                            .font(.caption)
                            .foregroundColor(Color.farmColors.textSecondary)
                    }
                }
                
                HStack(spacing: 16) {
                    Text(breakdown.formattedArea)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Text(breakdown.currentStage.rawValue)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.successGreen)
                }
            }
            
            Spacer()
            
            // Earnings info
            VStack(alignment: .trailing, spacing: 4) {
                Text(breakdown.formattedEarnings)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.primary)
                
                Text("₹\(Int(breakdown.earningsPerAcre).formatted())/acre")
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.farmColors.primary.opacity(0.1), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func cropIconView(for cropType: String) -> some View {
        switch cropType.lowercased() {
        case "wheat":
            Image("wheat")
                .resizable()
                .aspectRatio(contentMode: .fit)
        case "rice":
            Image("rice")
                .resizable()
                .aspectRatio(contentMode: .fit)
        case "sugarcane":
            Image(systemName: "leaf.fill")
        default:
            Image(systemName: "leaf.fill")
        }
    }
    
    private func cropColor(for cropType: String) -> Color {
        switch cropType.lowercased() {
        case "wheat": return Color.orange
        case "rice": return Color.green
        case "sugarcane": return Color.purple
        default: return Color.farmColors.primary
        }
    }
}

#Preview {
    EarningsDetailCard(
        breakdowns: [
            EarningsBreakdown(
                farmName: "North Field",
                cropType: "Wheat",
                areaInAcres: 2.5,
                estimatedEarnings: 45000,
                earningsPerAcre: 18000,
                currentStage: .harvesting,
                lastUpdated: Date()
            ),
            EarningsBreakdown(
                farmName: "South Field",
                cropType: "Rice",
                areaInAcres: 1.8,
                estimatedEarnings: 39600,
                earningsPerAcre: 22000,
                currentStage: .irrigation,
                lastUpdated: Date()
            )
        ],
        onBackTap: {}
    )
    .padding()
}
