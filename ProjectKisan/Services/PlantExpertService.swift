//
//  PlantExpertService.swift
//  ProjectKisan
//
//  Created by Cline on 7/17/25.
//

import Foundation
import FoundationModels
import Combine

@MainActor
class PlantExpertService: ObservableObject {
    private let model = SystemLanguageModel.default
    
    @Published var isAvailable: Bool = false
    @Published var unavailabilityReason: String = ""
    @Published var isProcessing: Bool = false
    
    init() {
        checkAvailability()
    }
    
    func checkAvailability() {
        switch model.availability {
        case .available:
            isAvailable = true
            unavailabilityReason = ""
        case .unavailable(let reason):
            isAvailable = false
            unavailabilityReason = getUnavailabilityMessage(reason)
        }
    }
    
    private func getUnavailabilityMessage(_ reason: SystemLanguageModel.Availability.UnavailableReason) -> String {
        switch reason {
        case .deviceNotEligible:
            return "This device is not eligible for Apple Intelligence. Foundation Models require a physical iPhone 15 Pro/Pro Max or iPhone 16 series with iOS 18.1+. iOS Simulator is not supported."
        case .appleIntelligenceNotEnabled:
            return "Apple Intelligence is not enabled. Please enable it in Settings > Apple Intelligence & Siri."
        case .modelNotReady:
            return "The AI model is still downloading or initializing. Please wait a moment and try again."
        @unknown default:
            return "The AI model is currently unavailable. Foundation Models are not supported on iOS Simulator - please test on a physical device with Apple Intelligence enabled."
        }
    }
    
    func analyze(cropName: String, diseaseName: String) async throws -> AnalysisResult {
        guard isAvailable else {
            throw PlantExpertError.modelUnavailable(unavailabilityReason)
        }
        
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            if diseaseName.lowercased() == "healthy" {
                return try await analyzeHealthyPlant(cropName: cropName)
            } else {
                return try await analyzeDiseaseCondition(cropName: cropName, diseaseName: diseaseName)
            }
        } catch {
            throw PlantExpertError.analysisError(error.localizedDescription)
        }
    }
    
    private func analyzeHealthyPlant(cropName: String) async throws -> AnalysisResult {
        let session = LanguageModelSession(instructions: ExpertInstructions.healthyPlantExpert)
        
        let prompt = Prompt("""
        A farmer has a healthy \(cropName.lowercased()) plant. Provide comprehensive advice on maintaining this plant's health, including:
        - A brief, positive acknowledgment of the plant's current health.
        - 4 to 6 specific, actionable maintenance tips for a \(cropName.lowercased()) plant.
        - A detailed "About this Plant" section.
        - A list of prevention tips to avoid common diseases for \(cropName.lowercased()).
        
        Be encouraging and focus on preventive care.
        """)
        
        let response = try await session.respond(to: prompt, generating: HealthyPlantAdvice.self)
        return .healthyPlant(response.content)
    }
    
    private func analyzeDiseaseCondition(cropName: String, diseaseName: String) async throws -> AnalysisResult {
        let session = LanguageModelSession(instructions: ExpertInstructions.diseaseExpert)
        
        let prompt = Prompt("""
        A farmer has detected \(diseaseName) in their \(cropName.lowercased()) crop. 
        
        Provide a comprehensive, real-world analysis including:
        - A brief, informative summary of the disease.
        - 4 to 6 specific, actionable treatment steps.
        - A list of 3 to 4 real, recommended products with their approximate prices in INR (e.g., "Product Name - ₹XXX").
        - A detailed "About this Disease" section.
        - A list of prevention tips for the future.
        
        Be specific, practical, and actionable in your advice. Ensure the product prices are realistic for the Indian market.
        """)
        
        let response = try await session.respond(to: prompt, generating: DiseaseAnalysis.self)
        return .diseaseDetected(response.content)
    }
}

enum PlantExpertError: LocalizedError {
    case modelUnavailable(String)
    case analysisError(String)
    
    var errorDescription: String? {
        switch self {
        case .modelUnavailable(let reason):
            return "AI Model Unavailable: \(reason)"
        case .analysisError(let message):
            return "Analysis Error: \(message)"
        }
    }
}
