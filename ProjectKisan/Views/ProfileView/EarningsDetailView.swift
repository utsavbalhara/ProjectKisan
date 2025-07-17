import SwiftUI

struct EarningsDetailView: View {
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Earnings Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.textPrimary)
                    .padding(.horizontal, 20)

                LineChartView(
                    data: viewModel.selectedEarningsBreakdown.map { $0.estimatedEarnings },
                    title: "Earnings Trend",
                    subtitle: "Last 3 months",
                    accentColor: Color.farmColors.primary
                )
                .frame(height: 250)
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Earnings Breakdown")
                        .font(.headline)
                        .foregroundColor(Color.farmColors.textPrimary)
                        .padding(.horizontal, 20)
                    
                    ForEach(viewModel.selectedEarningsBreakdown) { breakdown in
                        FarmEarningRow(breakdown: breakdown)
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .background(Color.farmColors.backgroundLight.ignoresSafeArea())
        .navigationTitle("Earnings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FarmEarningRow: View {
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
            
            Text(breakdown.formattedEarnings)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.farmColors.primary)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
}

#Preview {
    EarningsDetailView()
}