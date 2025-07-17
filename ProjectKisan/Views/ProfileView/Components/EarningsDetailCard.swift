import SwiftUI

struct EarningsDetailCard: View {
    let breakdowns: [EarningsBreakdown]
    let onBackTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: onBackTap) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color.farmColors.primary)
                }
                Text("Earnings Breakdown")
                    .font(.headline)
                    .foregroundColor(Color.farmColors.textPrimary)
                Spacer()
            }
            
            LineChartView(
                data: breakdowns.map { $0.estimatedEarnings },
                title: "Earnings Trend",
                subtitle: "",
                accentColor: Color.farmColors.primary
            )
            
            ForEach(breakdowns) { breakdown in
                VStack(alignment: .leading) {
                    Text(breakdown.farmName)
                        .font(.headline)
                    Text("Crop: \(breakdown.cropType)")
                        .font(.subheadline)
                    Text("Earnings: \(breakdown.formattedEarnings)")
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
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 15, x: 0, y: 8)
    }
}
