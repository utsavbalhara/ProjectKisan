import Foundation

struct PlantClassification {
    let cropName: String
    let diseaseName: String // "healthy" or actual disease name
    let confidence: Double
    
    var isHealthy: Bool {
        return diseaseName.lowercased() == "healthy"
    }
    
    var confidencePercentage: String {
        return "\(Int(confidence * 100))%"
    }
}