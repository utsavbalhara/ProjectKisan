import SwiftUI

struct FullScreenImageView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var expandedCards: Set<String> = []
    @State private var analysisResult: AnalysisResult?
    @State private var isClassifying = true
    @State private var classificationError: String?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 2)
                        .padding(.horizontal, 20)

                    if isClassifying {
                        analysisInProgressView
                    } else if let result = analysisResult {
                        analysisResultView(for: result)
                    } else if let error = classificationError {
                        errorView(error)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "checkmark")
                    }
                    .tint(.primary)
                }
            }
            .onAppear(perform: classifyImage)
        }
    }

    private var navigationTitle: String {
        guard let result = analysisResult else { return "Analysis" }
        switch result {
        case .diseaseDetected:
            return "Disease Analysis"
        case .healthyPlant:
            return "Plant Analysis"
        }
    }

    private var analysisInProgressView: some View {
        VStack(alignment: .leading) {
            Text("Analyzing...")
                .font(.largeTitle).fontWeight(.bold)
            Text("Please wait")
                .font(.title).fontWeight(.bold).foregroundColor(.secondary)
            ProgressView().padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }

    private func errorView(_ error: String) -> some View {
        VStack {
            Text("Analysis Failed")
                .font(.title).bold()
            Text(error)
                .font(.body).foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            Button("Try Again", action: classifyImage)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    @ViewBuilder
    private func analysisResultView(for result: AnalysisResult) -> some View {
        switch result {
        case .diseaseDetected(let analysis):
            diseaseContentView(analysis)
        case .healthyPlant(let advice):
            healthyContentView(advice)
        }
    }

    private func classifyImage() {
        isClassifying = true
        classificationError = nil
        PlantClassificationService.shared.classifyImage(image) { result in
            DispatchQueue.main.async {
                isClassifying = false
                switch result {
                case .success(let analysis):
                    self.analysisResult = analysis
                case .failure(let error):
                    self.classificationError = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Reusable Card Views
    
    @ViewBuilder
    private func infoCard<Content: View>(title: String, content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.subheadline).fontWeight(.semibold).foregroundColor(.secondary)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity, alignment: .leading)
            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func expandableCard<Content: View>(title: String, cardId: String, content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: {
                withAnimation(.easeInOut) {
                    if expandedCards.contains(cardId) {
                        expandedCards.remove(cardId)
                    } else {
                        expandedCards.insert(cardId)
                    }
                }
            }) {
                HStack {
                    Text(title)
                        .font(.subheadline).fontWeight(.semibold).foregroundColor(.secondary)
                        .textCase(.uppercase)
                    Spacer()
                    Image(systemName: expandedCards.contains(cardId) ? "chevron.down" : "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(.plain)
            
            if expandedCards.contains(cardId) {
                content()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .padding(.horizontal, 20)
    }
    
    // MARK: - Disease and Healthy Content Views
    
    private func diseaseContentView(_ analysis: DiseaseAnalysis) -> some View {
        VStack(spacing: 20) {
            Text(analysis.summary)
                .font(.body)
                .padding(.horizontal, 20)
                .foregroundColor(.secondary)

            infoCard(title: "Treatment Steps") {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(analysis.treatmentSteps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .fontWeight(.bold).foregroundColor(.blue)
                            Text(step)
                                .fontWeight(.medium)
                        }
                    }
                }
            }

            infoCard(title: "Recommended Products") {
                VStack(spacing: 12) {
                    ForEach(analysis.recommendedProducts, id: \.name) { product in
                        HStack {
                            Text(product.name).fontWeight(.medium)
                            Spacer()
                            Text(product.price).fontWeight(.medium)
                        }
                    }
                }
            }

            expandableCard(title: "About This Disease", cardId: "about") {
                Text(analysis.aboutDisease)
                    .font(.body).foregroundColor(.secondary)
            }

            expandableCard(title: "Prevention Tips", cardId: "prevention") {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(analysis.preventionTips, id: \.self) { tip in
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(.purple)
                            Text(tip)
                        }
                    }
                }
            }
        }
    }
    
    private func healthyContentView(_ advice: HealthyPlantAdvice) -> some View {
        VStack(spacing: 20) {
            Text(advice.summary)
                .font(.body)
                .padding(.horizontal, 20)
                .foregroundColor(.secondary)

            infoCard(title: "Maintenance Tips") {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(advice.maintenanceTips.enumerated()), id: \.offset) { index, tip in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .fontWeight(.bold).foregroundColor(.green)
                            Text(tip)
                                .fontWeight(.medium)
                        }
                    }
                }
            }

            expandableCard(title: "About This Plant", cardId: "about") {
                Text(advice.aboutPlant)
                    .font(.body).foregroundColor(.secondary)
            }

            expandableCard(title: "Prevention Tips", cardId: "prevention") {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(advice.preventionTips, id: \.self) { tip in
                        HStack(alignment: .top) {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.green)
                            Text(tip)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let placeholderImage = UIImage(systemName: "leaf.fill") ?? UIImage()
    return FullScreenImageView(image: placeholderImage)
}
