import Foundation
import FoundationModels

@Generable
struct TaskRecommendation {
    @Guide(description: "Specific task to perform today")
    let task: String
    
    @Guide(description: "Why this task is recommended based on current conditions")
    let reason: String
    
    @Guide(description: "Best time of day to perform this task")
    let timing: String
    
    @Guide(description: "Priority level from 1 (low) to 5 (urgent)")
    let priority: Int
}

@Generable
struct PestAlert {
    @Guide(description: "Name of the pest or disease")
    let name: String
    
    @Guide(description: "Risk level from 1 (low) to 5 (critical)")
    let riskLevel: Int
    
    @Guide(description: "Preventive actions to take immediately")
    let preventiveActions: [String]
    
    @Guide(description: "Weather conditions contributing to this risk")
    let weatherFactors: String
}

@Generable
struct FertilizerRecommendation {
    @Guide(description: "Type of fertilizer recommended")
    let fertilizerType: String
    
    @Guide(description: "Best timing for application based on weather and soil conditions")
    let applicationTiming: String
    
    @Guide(description: "Recommended application rate")
    let applicationRate: String
    
    @Guide(description: "Specific reasons for this recommendation")
    let reasoning: String
}

@Generable
struct ProductRecommendation {
    @Guide(description: "Product name")
    let name: String
    
    @Guide(description: "Product category (pesticide, fertilizer, equipment, etc.)")
    let category: String
    
    @Guide(description: "Estimated price in USD (between 1 and 1000)")
    let price: Int
    
    @Guide(description: "Why this product is recommended for current conditions")
    let recommendation: String
    
    @Guide(description: "Application or usage instructions")
    let instructions: String
}

@Generable
struct CropInsights {
    @Guide(description: "Daily task recommendations based on current weather and crop stage")
    let taskRecommendations: [TaskRecommendation]
    
    @Guide(description: "Pest and disease alerts based on weather vulnerability analysis")
    let pestAlerts: [PestAlert]
    
    @Guide(description: "Fertilizer application recommendations based on soil and weather data")
    let fertilizerAdvice: FertilizerRecommendation
    
    @Guide(description: "General crop maintenance insights and tips based on current conditions")
    let maintenanceInsights: String
    
    @Guide(description: "Suggested products with realistic market prices")
    let suggestedProducts: [ProductRecommendation]
}
