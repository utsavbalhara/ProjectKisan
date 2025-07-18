//
//  DiseaseAnalysisModel.swift
//  ProjectKisan
//
//  Created by Cline on 7/17/25.
//

import Foundation
import FoundationModels

@Generable
struct TreatmentStep {
    @Guide(description: "A concise title for the treatment step (2-5 words max).")
    let title: String
    
    @Guide(description: "A brief description of the treatment step (1-2 lines max).")
    let description: String
}

@Generable
struct ProductRecommendation2 {
    @Guide(description: "The name of the recommended product (2-5 words max).")
    let name: String
    
    @Guide(description: "Brief usage instructions (1-2 lines max).")
    let usage: String
    
    @Guide(description: "The approximate price of the product in INR (e.g., '₹100-150').")
    let price: String
}

@Generable
struct PreventionTip {
    @Guide(description: "A concise title for the prevention tip (2-5 words max).")
    let title: String
    
    @Guide(description: "A brief description of the prevention tip (1-2 lines max).")
    let description: String
    
    @Guide(description: "An SF Symbol icon name for the tip, (e.g., drop.fill, wind, leaf.fill, checkmark.shield.fill)")
    let icon: String
}

// FIX 1: Define a new struct for key-value pairs
@Generable
struct DetailItem {
    @Guide(description: "The key or label for the detail, e.g., 'Type', 'Spreads By'.")
    let key: String

    @Guide(description: "The value for the detail, e.g., 'Fungal Disease', 'Wind and Rain'.")
    let value: String
}

@Generable
struct DiseaseAnalysis {
    @Guide(description: "The name of the crop/plant.")
    let cropName: String
    
    @Guide(description: "The name of the disease.")
    let diseaseName: String
    
    @Guide(description: "The scientific name of the disease.")
    let scientificName: String
    
    @Guide(description: "The confidence percentage from the model (0.0 to 1.0).")
    let confidence: Double
    
    @Guide(description: "A brief, informative summary of the disease (1-2 lines).")
    let summary: String
    
    @Guide(description: "Exactly 4 structured treatment steps.")
    let treatmentSteps: [TreatmentStep]
    
    @Guide(description: "Exactly 3 product recommendations with usage instructions.")
    let recommendedProducts: [ProductRecommendation2]
    
    @Guide(description: "A detailed 'About this Disease' section (2-3 lines).")
    let aboutDisease: String
    
    // FIX 2: Change the Dictionary to an array of the new DetailItem struct
    @Guide(description: "Exactly 3 disease details (e.g., Type, Spreads By, Favorable Conditions) as key-value pairs.")
    let diseaseDetails: [DetailItem]
    
    @Guide(description: "Exactly 4 prevention tips with icons.")
    let preventionTips: [PreventionTip]
}

@Generable
struct HealthyPlantAdvice {
    @Guide(description: "The name of the crop/plant.")
    let cropName: String
    
    @Guide(description: "The scientific name of the plant.")
    let scientificName: String
    
    @Guide(description: "The confidence percentage from the model (0.0 to 1.0).")
    let confidence: Double
    
    @Guide(description: "A brief, positive acknowledgment of the plant's current health (1-2 lines), non technical.")
    let summary: String
    
    @Guide(description: "Exactly 4 structured maintenance tips.")
    let maintenanceTips: [TreatmentStep]
    
    @Guide(description: "A detailed 'About this Plant' section (2-3 lines).")
    let aboutPlant: String
    
    // FIX 3: Change the Dictionary here as well
    @Guide(description: "Exactly 3 plant details (e.g., Type, Growth Pattern, Optimal Conditions) as key-value pairs.")
    let plantDetails: [DetailItem]
    
    @Guide(description: "Exactly 4 prevention tips with icons.")
    let preventionTips: [PreventionTip]
}


enum AnalysisResult {
    case diseaseDetected(DiseaseAnalysis)
    case healthyPlant(HealthyPlantAdvice)
}

struct ExpertInstructions {
    static let diseaseExpert = Instructions("""
    You are a world-renowned plant pathologist and agricultural expert for Indian farmers. Provide CONCISE, structured analysis.
    
    CRITICAL CONSTRAINTS:
    - Titles: 2-5 words maximum
    - Descriptions: 1-2 lines maximum (under 100 characters)
    - Summary: 1-2 lines maximum
    - About Disease: 2-3 lines maximum
    - Be specific and actionable
    - Use simple, farmer-friendly language
    - Include INR prices realistic for Indian market
    - Provide accurate scientific names
    - Use appropriate SF Symbol icons for prevention tips
    """)
    
    static let healthyPlantExpert = Instructions("""
    You are a positive and encouraging plant health expert for Indian farmers. Provide CONCISE, structured advice.
    
    CRITICAL CONSTRAINTS:
    - Titles: 2-5 words maximum
    - Descriptions: 1-2 lines maximum (under 100 characters)
    - Summary: 1-2 lines maximum
    - About Plant: 2-3 lines maximum
    - Be positive and encouraging
    - Focus on preventive care and actionable maintenance tips
    - Use simple, farmer-friendly language
    - Provide accurate scientific names
    - Use SF Symbol icons for prevention tips
    """)
}
