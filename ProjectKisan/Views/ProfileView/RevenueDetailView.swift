import SwiftUI

struct RevenueDetailView: View {
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Revenue Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.textPrimary)
                    .padding(.horizontal, 20)

                LineChartView(
                    data: viewModel.selectedEarningsBreakdown.map { $0.estimatedEarnings * 1.15 }, // Sample revenue calculation
                    title: "Revenue Trend",
                    subtitle: "Last 3 months",
                    accentColor: Color.farmColors.secondary
                )
                .frame(height: 250)
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Revenue Breakdown")
                        .font(.headline)
                        .foregroundColor(Color.farmColors.textPrimary)
                        .padding(.horizontal, 20)
                    
                    ForEach(viewModel.selectedEarningsBreakdown) { breakdown in
                        FarmRevenueRow(breakdown: breakdown)
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .background(Color.farmColors.backgroundLight.ignoresSafeArea())
        .navigationTitle("Revenue")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FarmRevenueRow: View {
    let breakdown: EarningsBreakdown
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(breakdown.farmName)
                    .font(.headline)
                    .foregroundColor(Color.farmColors.textPrimary)
                Text("Crop: \(breakdown.cropType)")
                    .font(.subheadline)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
            
            Spacer()
            
            Text("₹\(Int(breakdown.estimatedEarnings * 1.15).formatted())")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.farmColors.secondary)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
}


#Preview {
    RevenueDetailView()
}