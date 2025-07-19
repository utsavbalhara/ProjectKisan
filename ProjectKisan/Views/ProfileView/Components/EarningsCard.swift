import SwiftUI

struct EarningsCard: View {
    let earnings: String
    let lastUpdated: String
    
    var body: some View {
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
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title2)
                    .foregroundColor(Color.farmColors.successGreen)
            }
            
            HStack {
                Text(lastUpdated)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Spacer()
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
