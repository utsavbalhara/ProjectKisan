import SwiftUI

struct FullScreenImageView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var expandedCards: Set<String> = []
    @State private var classification: PlantClassification?
    @State private var isClassifying = true

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Plant Image
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 2)
                        .padding(.horizontal, 20)

                    // Plant and Disease Information
                    VStack(spacing: 16) {
                        if isClassifying {
                            VStack(alignment: .leading) {
                                Text("Analyzing...")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text("Please wait")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                ProgressView()
                                    .padding(.top, 8)
                            }
                        } else if let classification = classification {
                            VStack(alignment: .leading) {
                                Text(classification.cropName)
                                    .font(.system(.largeTitle, design: .rounded))
                                    .fontWeight(.bold)
                                
                                if classification.isHealthy {
                                    Text("Healthy")
                                        .font(.system(.title, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                } else {
                                    Text(classification.diseaseName)
                                        .font(.system(.title, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.orange)
                                    Text("Scientific name placeholder")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .italic()
                                }
                                
                                Text("(\(classification.confidencePercentage) Confidence)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)

                    // Quick Summary
                    Text("Late blight detected on leaves. Immediate treatment recommended to prevent spread to fruits and neighboring plants.")
                        .font(.body)
                        .padding(.horizontal, 20)
                        .foregroundColor(.secondary)
                    // Treatment Steps Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Treatment Steps")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .top) {
                                Text("1.")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Remove infected leaves")
                                        .fontWeight(.medium)
                                    Text("Dispose safely - do not compost")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }

                            HStack(alignment: .top) {
                                Text("2.")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Apply fungicide")
                                        .fontWeight(.medium)
                                    Text("Copper-based, every 7-10 days")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }

                            HStack(alignment: .top) {
                                Text("3.")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Improve air circulation")
                                        .fontWeight(.medium)
                                    Text("Prune lower branches, space plants")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }

                            HStack(alignment: .top) {
                                Text("4.")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Water management")
                                        .fontWeight(.medium)
                                    Text("Water at soil level, avoid wetting leaves")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal, 20)

                    // Recommended Products Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recommended Products")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Copper Fungicide Spray")
                                        .fontWeight(.medium)
                                    Text("Mix 2 tbsp per gallon")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("$12-18")
                                    .fontWeight(.medium)
                            }

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Neem Oil Solution")
                                        .fontWeight(.medium)
                                    Text("Apply weekly as prevention")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("$8-15")
                                    .fontWeight(.medium)
                            }

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Potassium Bicarbonate")
                                        .fontWeight(.medium)
                                    Text("1 tsp per quart water")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("$5-10")
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal, 20)

                    // About This Disease Card
                    VStack(alignment: .leading, spacing: 16) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if expandedCards.contains("about") {
                                    expandedCards.remove("about")
                                } else {
                                    expandedCards.insert("about")
                                }
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("About This Disease")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                Spacer()
                                Image(systemName: expandedCards.contains("about") ? "chevron.down" : "chevron.forward")
                                    .foregroundColor(Color(uiColor: UIColor.tertiaryLabel))
                                    .font(.system(size: 14, weight: .semibold))
                            }

                        Text("Late blight is one of the most destructive diseases of tomatoes and potatoes. It can destroy entire crops within days under favorable conditions.")
                            .font(.body)
                            .foregroundColor(.secondary)

                        if expandedCards.contains("about") {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Type")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("Fungal-like pathogen")
                                        .foregroundColor(.secondary)
                                }

                                HStack {
                                    Text("Spreads By")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("Wind, water, infected soil")
                                        .foregroundColor(.secondary)
                                }

                                HStack {
                                    Text("Favorable Conditions")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("Cool, wet (60-70°F)")
                                        .foregroundColor(.secondary)
                                }

                            }
                        }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, maxHeight: expandedCards.contains("about") ? nil : 400)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal, 20)

                    // Prevention Tips Card
                    VStack(alignment: .leading, spacing: 16) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if expandedCards.contains("prevention") {
                                    expandedCards.remove("prevention")
                                } else {
                                    expandedCards.insert("prevention")
                                }
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Prevention Tips")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                Spacer()
                                Image(systemName: expandedCards.contains("prevention") ? "chevron.down" : "chevron.forward")
                                    .foregroundColor(Color(uiColor: UIColor.tertiaryLabel))
                                    .font(.system(size: 14, weight: .semibold))
                            }

                        if expandedCards.contains("prevention") {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(alignment: .top) {
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(.blue)
                                        .frame(width: 20)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Proper Watering")
                                            .fontWeight(.medium)
                                        Text("Water at soil level, avoid wetting leaves especially in evening")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }

                                HStack(alignment: .top) {
                                    Image(systemName: "wind")
                                        .foregroundColor(.mint)
                                        .frame(width: 20)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Air Circulation")
                                            .fontWeight(.medium)
                                        Text("Space plants adequately and prune lower branches")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }

                                HStack(alignment: .top) {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.green)
                                        .frame(width: 20)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Crop Rotation")
                                            .fontWeight(.medium)
                                        Text("Rotate crops yearly to break disease cycles")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }

                                HStack(alignment: .top) {
                                    Image(systemName: "checkmark.shield.fill")
                                        .foregroundColor(.purple)
                                        .frame(width: 20)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Regular Inspection")
                                            .fontWeight(.medium)
                                        Text("Check plants weekly for early disease signs")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                            }
                        }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal, 20)


                    // Need More Help List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Need More Help?")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 0) {
                            Button(action: {}) {
                                HStack {
                                    Label {
                                        Text("Ask Plant Expert")
                                    } icon: {
                                        Image(systemName: "message.fill")
                                            .foregroundColor(.blue)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.forward")
                                        .foregroundColor(Color(uiColor: UIColor.tertiaryLabel))
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Divider()

                            Button(action: {}) {
                                HStack {
                                    Label {
                                        Text("Call Agricultural Support")
                                    } icon: {
                                        Image(systemName: "phone.fill")
                                            .foregroundColor(.blue)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.forward")
                                        .foregroundColor(Color(uiColor: UIColor.tertiaryLabel))
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(PlainButtonStyle())

                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(classification?.isHealthy == false ? "Disease Analysis" : "Plant Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    }
                    label: {
                        Image(systemName: "checkmark")
                    }
                    .tint(.primary)
                }
                .sharedBackgroundVisibility(. visible)
            }
            .onAppear {
                classifyImage()
            }
        }
    }
    
    private func classifyImage() {
        PlantClassificationService.shared.classifyImage(image) { result in
            DispatchQueue.main.async {
                isClassifying = false
                switch result {
                case .success(let plantClassification):
                    classification = plantClassification
                case .failure(let error):
                    print("Classification failed: \(error.localizedDescription)")
                    // Fallback to sample data for demo
                    classification = PlantClassification(
                        cropName: "Tomato Plant",
                        diseaseName: "Late Blight", 
                        confidence: 0.87
                    )
                }
            }
        }
    }
}

#Preview {
    let placeholderImage = UIImage(systemName: "leaf.fill") ?? UIImage()
    return FullScreenImageView(image: placeholderImage)
}
