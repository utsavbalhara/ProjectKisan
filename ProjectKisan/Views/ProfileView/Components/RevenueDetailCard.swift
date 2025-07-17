import SwiftUI

struct RevenueDetailCard: View {
    let breakdowns: [EarningsBreakdown] // Using EarningsBreakdown for now, can be changed
    let onBackTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: onBackTap) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color.farmColors.secondary)
                }
                Text("Revenue Breakdown")
                    .font(.headline)
                    .foregroundColor(Color.farmColors.textPrimary)
                Spacer()
            }
            
            LineChartView(
                data: breakdowns.map { $0.estimatedEarnings * 1.15 }, // Sample revenue calculation
                title: "Revenue Trend",
                subtitle: "",
                accentColor: Color.farmColors.secondary
            )
            
            ForEach(breakdowns) { breakdown in
                VStack(alignment: .leading) {
                    Text(breakdown.farmName)
                        .font(.headline)
                    Text("Crop: \(breakdown.cropType)")
                        .font(.subheadline)
                    Text("Revenue: ₹\(Int(breakdown.estimatedEarnings * 1.15).formatted())")
                        .font(.subheadline)
                }
                .padding()
                .background(Color.farmColors.surface)
                .cornerRadius(10)
            }
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.farmColors.secondary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 15, x: 0, y: 8)
    }
}
