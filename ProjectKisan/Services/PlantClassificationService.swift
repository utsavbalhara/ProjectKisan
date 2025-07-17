import CoreML
import Vision
import UIKit

class PlantClassificationService {
    static let shared = PlantClassificationService()
    
    private init() {}
    
    func classifyImage(_ image: UIImage, completion: @escaping (Result<PlantClassification, Error>) -> Void) {
        guard let model = try? VNCoreMLModel(for: FasalDiseaseClassifier().model) else {
            completion(.failure(ClassificationError.modelLoadFailed))
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                completion(.failure(ClassificationError.noResults))
                return
            }
            
            // Parse the classification result
            // Handle various separators: _, __, space, double space
            let identifier = topResult.identifier
            var cropName = ""
            var diseaseName = ""
            
            // Handle "Unknown" class specifically
            if identifier.lowercased() == "unknown" {
                cropName = "No Crop Detected"
                diseaseName = ""
            } else {
                // Try different separators in order of preference
                if identifier.contains("__") {
                    let components = identifier.components(separatedBy: "__")
                    cropName = components[0]
                    diseaseName = components.count > 1 ? components[1] : ""
                } else if identifier.contains("_") {
                    let components = identifier.components(separatedBy: "_")
                    cropName = components[0]
                    diseaseName = components.count > 1 ? components[1] : ""
                } else if identifier.contains("  ") { // double space
                    let components = identifier.components(separatedBy: "  ")
                    cropName = components[0]
                    diseaseName = components.count > 1 ? components[1] : ""
                } else if identifier.contains(" ") {
                    let components = identifier.components(separatedBy: " ")
                    cropName = components[0]
                    diseaseName = components.count > 1 ? components[1] : ""
                } else {
                    // If no separator found, treat whole string as crop name
                    cropName = identifier
                    diseaseName = "Unknown"
                }
                
                // Clean up the names (trim whitespace and add spacing for camelCase)
                cropName = self.cleanupName(cropName)
                diseaseName = self.cleanupName(diseaseName)
            }
            let confidence = Double(topResult.confidence)
            
            let classification = PlantClassification(
                cropName: cropName,
                diseaseName: diseaseName,
                confidence: confidence
            )
            
            completion(.success(classification))
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
        
        // Add spaces before capital letters for camelCase (e.g., "BlackRust" -> "Black Rust")
        cleaned = cleaned.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
        
        return cleaned
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
