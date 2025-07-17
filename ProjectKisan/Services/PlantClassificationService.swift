import CoreML
import Vision
import UIKit

@MainActor
class PlantClassificationService {
    static let shared = PlantClassificationService()
    private let plantExpertService = PlantExpertService()
    
    private init() {}
    
    func classifyImage(_ image: UIImage, completion: @escaping (Result<AnalysisResult, Error>) -> Void) {
        guard let model = try? VNCoreMLModel(for: FasalDiseaseClassifier().model) else {
            completion(.failure(ClassificationError.modelLoadFailed))
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [self] request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                completion(.failure(ClassificationError.noResults))
                return
            }
            
            let identifier = topResult.identifier
            var cropName = ""
            var diseaseName = ""
            
            if identifier.lowercased() == "unknown" {
                cropName = "Unknown"
                diseaseName = "Healthy" // Assume healthy if no crop is detected
            } else {
                if identifier.contains("__") {
                    let components = identifier.components(separatedBy: "__")
                    cropName = components[0]
                    diseaseName = components.count > 1 ? components[1] : "Healthy"
                } else if identifier.contains("_") {
                    let components = identifier.components(separatedBy: "_")
                    cropName = components[0]
                    diseaseName = components.count > 1 ? components[1] : "Healthy"
                } else {
                    cropName = identifier
                    diseaseName = "Healthy"
                }
                
                cropName = self.cleanupName(cropName)
                diseaseName = self.cleanupDiseaseName(diseaseName)
            }
            
            Task {
                do {
                    let analysisResult = try await self.plantExpertService.analyze(cropName: cropName, diseaseName: diseaseName)
                    completion(.success(analysisResult))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        guard let cgImage = image.cgImage else {
            completion(.failure(ClassificationError.imageConversionFailed))
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }
    
    private func cleanupName(_ name: String) -> String {
        // Trim whitespace
        var cleaned = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Add spaces before capital letters for camelCase (e.g., "TomatoPlant" -> "Tomato Plant")
        cleaned = cleaned.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
        
        return cleaned
    }
    
    private func cleanupDiseaseName(_ name: String) -> String {
        var cleaned = name.replacingOccurrences(of: "[^a-zA-Z]", with: " ", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: " +", with: " ", options: .regularExpression)
        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        return cleaned.isEmpty ? "Healthy" : cleaned
    }
}

enum ClassificationError: Error, LocalizedError {
    case modelLoadFailed
    case noResults
    case invalidFormat
    case imageConversionFailed
    
    var errorDescription: String? {
        switch self {
        case .modelLoadFailed:
            return "Failed to load CoreML model"
        case .noResults:
            return "No classification results"
        case .invalidFormat:
            return "Invalid classification format"
        case .imageConversionFailed:
            return "Failed to convert image"
        }
    }
}
