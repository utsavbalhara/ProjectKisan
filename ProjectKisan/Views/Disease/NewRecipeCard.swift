import SwiftUI

struct NewRecipeCard: View {
    var body: some View {
        // Semi-transparent overlay card
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Identify Crop Disease")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1)
                
                Text("Point camera at any crop leaf.\nAI will analyze it instantly.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.3), radius: 1)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Decorative plant icon
            Image(systemName: "leaf.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.8))
                .shadow(color: .black.opacity(0.3), radius: 2)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .glassEffect(.regular ,in: .rect(cornerRadius: 24))
                .environment(\.colorScheme, .dark)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    NewRecipeCard()
}
