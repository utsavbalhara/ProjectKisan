import SwiftUI

struct RevenueCard: View {
    let revenue: String
    let lastUpdated: String
    
    var body: some View {
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
                
                Image(systemName: "banknote")
                    .font(.title2)
                    .foregroundColor(Color.farmColors.secondary)
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
                .stroke(Color.farmColors.secondary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 6)
    }
}
