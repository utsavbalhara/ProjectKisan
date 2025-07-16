import SwiftUI

struct NewRecipeCard: View {
    var body: some View {
        // New Recipe Card
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Identify Crop Disease")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text("Take a photo of any crop leaf.\nAn advanced ML model will analyze it on device instantly.")
                            .font(.subheadline)
                            .foregroundColor(Color.farmColors.textSecondary)
                            .multilineTextAlignment(.leading)
                            .frame(width:250, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            
                    }
                    Spacer()
                }
                Spacer()
                
                HStack {
                    // Start sizzling button
                    Button(action: {
                        
                    }) {
                        HStack(alignment: .center, spacing: 6) {
                            Image(systemName: "camera.fill")
                                .foregroundColor(.white)
                                .frame(width: 28, height: 26, alignment: .center)

                            Text("Take Photo")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            Spacer()
                        }
                        .padding(.leading, 16)
                        .frame(width: 150, height: 41)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color.farmColors.primary, location: 0.00),
                                    Gradient.Stop(color: Color.farmColors.primaryLight, location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.06, y: 0.2),
                                endPoint: UnitPoint(x: 1, y: 0.78)
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 999))
                        .glassEffect(.regular.tint(.accentColor).interactive())
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
            }
            .padding()
            
            HStack {
                Spacer()
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 93.6, height: 149.6)
                    .background(
                        Image("Unknown")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 93.6, height: 149.6)
                            .clipped()
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 180)
        .background(Color.farmColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .padding(.horizontal)
    }
}

#Preview {
    NewRecipeCard()
}
