import SwiftUI

struct NewRecipeCard: View {
    @State private var showPhotoLibrary = false
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var showFullScreenImage = false
    @State private var showImageSourceActionSheet = false
    
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
                        
                        Text("Take a photo of any crop leaf.\nAn advanced ML model\nwill analyze it on device.")
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
                        showImageSourceActionSheet = true
                    }) {
                        HStack(alignment: .center, spacing: 6) {
                            Image(systemName: "camera.fill")
                                .foregroundColor(Color.farmColors.surface)
                                .frame(width: 28, height: 26, alignment: .center)

                            Text("Take Photo")
                                .foregroundColor(Color.farmColors.surface)
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
                        .glassEffect(.regular.tint(Color.farmColors.primary).interactive())
                    }
                    .buttonStyle(.plain)
                    .confirmationDialog("Select Image", isPresented: $showImageSourceActionSheet, titleVisibility: .hidden) {
                        Button("Camera") {
                            showCamera = true
                        }
                        Button("Photo Library") {
                            showPhotoLibrary = true
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                    
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
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePickerView(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showCamera) {
            ImagePickerView(selectedImage: $selectedImage, sourceType: .camera)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showFullScreenImage) {
            if let image = selectedImage {
                FullScreenImageView(image: image)
            }
        }
        .onChange(of: selectedImage) { _, newImage in
            if newImage != nil {
                showFullScreenImage = true
            }
        }
    }
}

#Preview {
    NewRecipeCard()
}
