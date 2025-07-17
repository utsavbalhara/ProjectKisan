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
    
    func analyze(cropName: String, diseaseName: String, confidence: Double = 0.85) async throws -> AnalysisResult {
        guard isAvailable else {
            throw PlantExpertError.modelUnavailable(unavailabilityReason)
        }
        
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            if diseaseName.lowercased() == "healthy" {
                return try await analyzeHealthyPlant(cropName: cropName, confidence: confidence)
            } else {
                return try await analyzeDiseaseCondition(cropName: cropName, diseaseName: diseaseName, confidence: confidence)
            }
        } catch {
            throw PlantExpertError.analysisError(error.localizedDescription)
        }
    }
    
    private func analyzeHealthyPlant(cropName: String, confidence: Double) async throws -> AnalysisResult {
        let session = LanguageModelSession(instructions: ExpertInstructions.healthyPlantExpert)
        
        let prompt = Prompt("""
        A farmer has a healthy \(cropName.lowercased()) plant with \(Int(confidence * 100))% classification confidence.
        
        Provide CONCISE, structured advice:
        
        PLANT INFORMATION:
        - cropName: \(cropName)
        - scientificName: Provide accurate scientific name
        - confidence: \(confidence)
        
        MAINTENANCE TIPS (exactly 4 tips):
        - title: 2-5 words max
        - description: 1-2 lines max, actionable
        
        ABOUT PLANT:
        - summary: 1-2 lines max, positive acknowledgment
        - aboutPlant: 2-3 lines max, detailed plant information
        - plantDetails: Type, Growth Pattern, Optimal Conditions (each 3-8 words)
        
        PREVENTION TIPS (exactly 4 tips):
        - title: 2-5 words max
        - description: 1-2 lines max
        - icon: SF Symbol name (e.g., drop.fill, wind, leaf.fill, checkmark.shield.fill)
        
        Be encouraging and focus on preventive care. Keep all text concise and farmer-friendly.
        """)
        
        let response = try await session.respond(to: prompt, generating: HealthyPlantAdvice.self)
        return .healthyPlant(response.content)
    }
    
    private func analyzeDiseaseCondition(cropName: String, diseaseName: String, confidence: Double) async throws -> AnalysisResult {
        let session = LanguageModelSession(instructions: ExpertInstructions.diseaseExpert)
        
        let prompt = Prompt("""
        A farmer has detected \(diseaseName) in their \(cropName.lowercased()) crop with \(Int(confidence * 100))% classification confidence.
        
        Provide CONCISE, structured analysis:
        
        DISEASE INFORMATION:
        - cropName: \(cropName)
        - diseaseName: \(diseaseName)
        - scientificName: Provide accurate scientific name of the disease
        - confidence: \(confidence)
        
        TREATMENT STEPS (exactly 4 steps):
        - title: 2-5 words max
        - description: 1-2 lines max, actionable and specific
        
        RECOMMENDED PRODUCTS (exactly 3 products):
        - name: 2-5 words max
        - usage: 1-2 lines max, specific instructions
        - price: INR range (e.g., ₹100-150)
        
        ABOUT DISEASE:
        - summary: 1-2 lines max, informative summary
        - aboutDisease: 2-3 lines max, detailed disease information
        - diseaseDetails: Type, Spreads By, Favorable Conditions (each 3-8 words)
        
        PREVENTION TIPS (exactly 4 tips):
        - title: 2-5 words max
        - description: 1-2 lines max
        - icon: SF Symbol name (e.g., drop.fill, wind, leaf.fill, checkmark.shield.fill)
        
        Be specific, practical, and actionable. Ensure INR prices are realistic for Indian market.
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
