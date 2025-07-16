import SwiftUI

struct FarmCard: View {
    let farm: Farm
    
    var body: some View {
        NavigationLink(destination: FarmDetailView(farm: farm)) {
            ZStack {
                Image(farm.typeOfCrop.lowercased())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.7)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(farm.typeOfCrop)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("\(String(format: "%.1f", farm.areaInAcres)) acres")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Current Stage")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text(farm.currentStage.rawValue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        
                        
                    }
                    .padding(20)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(16)
        .shadow(color: Color.farmColors.shadow, radius: 8, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 16) {
            FarmCard(farm: Farm(typeOfCrop: "Wheat", areaInAcres: 25.5, currentStage: .cropManagement))
            FarmCard(farm: Farm(typeOfCrop: "Rice", areaInAcres: 18.0, currentStage: .irrigation))
        }
        .padding()
    }
}
