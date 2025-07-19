import SwiftUI

struct HomeView: View {
    @State private var viewModel = CookViewModel()
    @State private var capturedImage: UIImage?
    @State private var showFullScreenImage = false
    @State private var showPhotoLibrary = false
    @StateObject private var cameraController = CameraController()
    
    var body: some View {
        ZStack {
            // Live camera feed background
            CameraPreviewView(capturedImage: $capturedImage, onCapture: {
                // Handle capture
                if capturedImage != nil {
                    showFullScreenImage = true
                }
            }, cameraController: cameraController)
            .ignoresSafeArea()
            .onAppear {
                cameraController.startSession()
            }
            .onDisappear {
                cameraController.stopSession()
            }
            
            // Overlay UI elements
            VStack {
                // Custom title overlay with background
                HStack {
                    Text("Disease Detection")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        colors: [.black.opacity(0.3), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .top)
                )
                
                Spacer()
                

                
                // Camera controls at bottom with gradient background
                VStack(spacing: 0) {
                    Spacer()
                    
                    // NewRecipeCard overlay
                    NewRecipeCard()
                        .frame(height: 180)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)// Space for camera controls
                    
                    HStack {
                    // Image picker button (left)
                    Button(action: {
                        showPhotoLibrary = true
                    }) {
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .environment(\.colorScheme, .dark)
                            )
                            .glassEffect(.regular.tint(.black).interactive())
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    // White capture button (center)
                    Button(action: {
                        cameraController.capturePhoto()
                    }) {
                        Circle()
                            .fill(.clear)
                            .frame(width: 70, height: 70)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .environment(\.colorScheme, .light)
                                    .opacity(0.1)
                            )
                            .glassEffect(.clear.tint(.white.opacity(0.5)).interactive())
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 0.1), value: capturedImage)
                    
                    Spacer()
                    
                    // Flash toggle button (right)
                    Button(action: {
                        // Flash toggle functionality can be added later
                    }) {
                        Image(systemName: "bolt.slash")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .environment(\.colorScheme, .dark)
                            )
                            .glassEffect(.regular.tint(.black).interactive())
                    }
                    .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
                .background(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePickerView(selectedImage: $capturedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showFullScreenImage) {
            if let image = capturedImage {
                FullScreenImageView(image: image)
            }
        }
        .onChange(of: capturedImage) { _, newImage in
            if newImage != nil && !showPhotoLibrary {
                showFullScreenImage = true
            }
        }
    }
}

#Preview {
    HomeView()
}
