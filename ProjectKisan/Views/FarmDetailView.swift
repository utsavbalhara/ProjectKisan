import SwiftUI

struct FarmDetailView: View {
    let farm: Farm
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(farm.typeOfCrop)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Area")
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                            Text("\(String(format: "%.1f", farm.areaInAcres)) acres")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.farmColors.textPrimary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Current Stage")
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                            Text(farm.currentStage.rawValue)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.farmColors.primary)
                        }
                    }
                }
                .padding(20)
                .background(Color.farmColors.surface)
                .cornerRadius(16)
                .shadow(color: Color.farmColors.shadow, radius: 8, x: 0, y: 4)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Progress Overview")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    VStack(spacing: 12) {
                        ForEach(CropStage.allCases, id: \.self) { stage in
                            HStack {
                                Circle()
                                    .fill(stageColor(for: stage))
                                    .frame(width: 12, height: 12)
                                
                                Text(stage.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(stageTextColor(for: stage))
                                    .fontWeight(stage == farm.currentStage ? .semibold : .regular)
                                
                                Spacer()
                                
                                if stage == farm.currentStage {
                                    Text("Current")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.farmColors.primary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.farmColors.primary.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    ProgressView(value: farm.currentStage.progressValue)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.farmColors.primary))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
                .padding(20)
                .background(Color.farmColors.surface)
                .cornerRadius(16)
                .shadow(color: Color.farmColors.shadow, radius: 8, x: 0, y: 4)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Farm Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func stageColor(for stage: CropStage) -> Color {
        let currentIndex = CropStage.allCases.firstIndex(of: farm.currentStage) ?? 0
        let stageIndex = CropStage.allCases.firstIndex(of: stage) ?? 0
        
        if stageIndex < currentIndex {
            return Color.farmColors.successGreen
        } else if stageIndex == currentIndex {
            return Color.farmColors.primary
        } else {
            return Color.farmColors.textSecondary.opacity(0.3)
        }
    }
    
    private func stageTextColor(for stage: CropStage) -> Color {
        let currentIndex = CropStage.allCases.firstIndex(of: farm.currentStage) ?? 0
        let stageIndex = CropStage.allCases.firstIndex(of: stage) ?? 0
        
        if stageIndex <= currentIndex {
            return Color.farmColors.textPrimary
        } else {
            return Color.farmColors.textSecondary
        }
    }
}

#Preview {
    NavigationStack {
        FarmDetailView(farm: Farm(typeOfCrop: "Wheat", areaInAcres: 25.5, currentStage: .cropManagement))
    }
}