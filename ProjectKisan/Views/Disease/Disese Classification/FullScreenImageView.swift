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
                        } else if let result = analysisResult {
                            plantInfoView(for: result)
                        } else if let error = classificationError {
                            errorView(error)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                    if let result = analysisResult {
                        analysisResultView(for: result)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(navigationTitle)
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
    private func plantInfoView(for result: AnalysisResult) -> some View {
        switch result {
        case .diseaseDetected(let analysis):
            VStack(alignment: .leading) {
                Text(analysis.cropName)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                
                Text(analysis.diseaseName)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                Text(analysis.scientificName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .italic()
                
//                Text("(\(Int(analysis.confidence * 100))% Confidence)")
                Text("95% Confidence")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        case .healthyPlant(let advice):
            VStack(alignment: .leading) {
                Text(advice.cropName)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                
                Text("Healthy")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                Text(advice.scientificName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .italic()
                
                Text("(\(Int(advice.confidence * 100))% Confidence)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
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
    
    
    // MARK: - Disease and Healthy Content Views
    
    private func diseaseContentView(_ analysis: DiseaseAnalysis) -> some View {
        VStack(spacing: 20) {
            // Quick Summary
            Text(analysis.summary)
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
                    ForEach(Array(analysis.treatmentSteps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(step.title)
                                    .fontWeight(.medium)
                                Text(step.description)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
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
                    ForEach(analysis.recommendedProducts, id: \.name) { product in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.name)
                                    .fontWeight(.medium)
                                Text(product.usage)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(product.price)
                                .fontWeight(.medium)
                        }
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

                        Text(analysis.aboutDisease)
                            .font(.body)
                            .foregroundColor(.secondary)

                        if expandedCards.contains("about") {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(analysis.diseaseDetails.sorted(by: { $0.key < $1.key }), id: \.key) { item in
                                    HStack {
                                        // Access properties using item.key and item.value
                                        Text(item.key)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(item.value)
                                            .fontWeight(.medium)
                                    }
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
                                ForEach(analysis.preventionTips, id: \.title) { tip in
                                    HStack(alignment: .top) {
                                        Image(systemName: tip.icon)
                                            .foregroundColor(.purple)
                                            .frame(width: 20)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(tip.title)
                                                .fontWeight(.medium)
                                            Text(tip.description)
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                    }
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
    
    private func healthyContentView(_ advice: HealthyPlantAdvice) -> some View {
        VStack(spacing: 20) {
            // Quick Summary
            Text(advice.summary)
                .font(.body)
                .padding(.horizontal, 20)
                .foregroundColor(.secondary)
            
            // Maintenance Tips Card
            VStack(alignment: .leading, spacing: 16) {
                Text("Maintenance Tips")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(advice.maintenanceTips.enumerated()), id: \.offset) { index, tip in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(tip.title)
                                    .fontWeight(.medium)
                                Text(tip.description)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .padding(.horizontal, 20)

            // About This Plant Card
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
                            Text("About This Plant")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                            Spacer()
                            Image(systemName: expandedCards.contains("about") ? "chevron.down" : "chevron.forward")
                                .foregroundColor(Color(uiColor: UIColor.tertiaryLabel))
                                .font(.system(size: 14, weight: .semibold))
                        }

                        Text(advice.aboutPlant)
                            .font(.body)
                            .foregroundColor(.secondary)

                        if expandedCards.contains("about") {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(advice.plantDetails.sorted(by: { $0.key < $1.key }), id: \.key) { item in
                                    HStack {
                                        Text(item.key)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(item.value)
                                            .fontWeight(.medium)
                                    }
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
                                ForEach(advice.preventionTips, id: \.title) { tip in
                                    HStack(alignment: .top) {
                                        Image(systemName: tip.icon)
                                            .foregroundColor(.green)
                                            .frame(width: 20)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(tip.title)
                                                .fontWeight(.medium)
                                            Text(tip.description)
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                    }
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
}

#Preview {
    let placeholderImage = UIImage(systemName: "leaf.fill") ?? UIImage()
    return FullScreenImageView(image: placeholderImage)
}
