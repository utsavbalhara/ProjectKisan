//
//  DiseaseAnalysisModel.swift
//  ProjectKisan
//
//  Created by Cline on 7/17/25.
//

import Foundation
import FoundationModels

@Generable
struct DiseaseAnalysis {
    @Guide(description: "A brief, informative summary of the disease.")
    let summary: String
    
    @Guide(description: "A list of 4 to 6 specific, actionable treatment steps.")
    let treatmentSteps: [String]
    
    @Guide(description: "A list of 3 to 4 real, recommended products with their approximate prices in INR.")
    let recommendedProducts: [RecommendedProduct]
    
    @Guide(description: "A detailed 'About this Disease' section.")
    let aboutDisease: String
    
    @Guide(description: "A list of prevention tips for the future.")
    let preventionTips: [String]
}

@Generable
struct HealthyPlantAdvice {
    @Guide(description: "A brief, positive acknowledgment of the plant's current health.")
    let summary: String
    
    @Guide(description: "4 to 6 specific, actionable maintenance tips.")
    let maintenanceTips: [String]
    
    @Guide(description: "A detailed 'About this Plant' section.")
    let aboutPlant: String
    
    @Guide(description: "A list of prevention tips to avoid common diseases.")
    let preventionTips: [String]
}

@Generable
struct RecommendedProduct {
    @Guide(description: "The name of the recommended product.")
    let name: String
    
    @Guide(description: "The approximate price of the product in INR (e.g., '₹500').")
    let price: String
}

enum AnalysisResult {
    case diseaseDetected(DiseaseAnalysis)
    case healthyPlant(HealthyPlantAdvice)
}

struct ExpertInstructions {
    static let diseaseExpert = Instructions("""
    You are a world-renowned plant pathologist and agricultural expert. Your task is to provide a comprehensive and actionable analysis for a farmer who has identified a plant disease.
    
    Guidelines:
    - Provide accurate, science-based information.
    - Be specific and practical in your recommendations.
    - Ensure all requested fields are populated with high-quality, real-world information.
    - Format product prices clearly in INR (e.g., "Product Name - ₹XXX").
    """)
    
    static let healthyPlantExpert = Instructions("""
    You are a positive and encouraging plant health expert. Your role is to provide comprehensive advice for maintaining a healthy plant.
    
    Guidelines:
    - Be positive and encouraging.
    - Focus on preventive care and actionable maintenance tips.
    - Provide detailed and useful information in all requested fields.
    """)
}
