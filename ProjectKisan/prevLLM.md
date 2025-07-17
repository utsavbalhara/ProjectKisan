//
//  PlantExpertService.swift
//  farmerdiseasedetection
//
//  Created by aryaman jaiswal on 15/07/25.
//

import Foundation
import FoundationModels
import Combine

@MainActor
class PlantExpertService: ObservableObject {
    private let model = SystemLanguageModel.default
    private var currentSession: LanguageModelSession?
    
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
    
    func analyzeDisease(selection: PlantDiseaseSelection) async throws -> AnalysisResult {
        guard isAvailable else {
            throw PlantExpertError.modelUnavailable(unavailabilityReason)
        }
        
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            if selection.disease.isHealthy {
                return try await analyzeHealthyPlant(selection: selection)
            } else {
                return try await analyzeDiseaseCondition(selection: selection)
            }
        } catch {
            throw PlantExpertError.analysisError(error.localizedDescription)
        }
    }
    
    private func analyzeHealthyPlant(selection: PlantDiseaseSelection) async throws -> AnalysisResult {
        let session = LanguageModelSession(instructions: ExpertInstructions.healthyPlantExpert)
        
        let prompt = Prompt("""
        A farmer has a healthy \(selection.plant.rawValue.lowercased()) plant. Provide comprehensive advice on maintaining this plant's health, including:
        - Positive acknowledgment of the plant's current health
        - Specific maintenance tips for \(selection.plant.rawValue.lowercased())
        - Prevention strategies to avoid common diseases
        - Early warning signs to watch for
        - Optimal growing conditions
        - Recommended monitoring schedule
        
        Be encouraging and focus on preventive care.
        """)
        
        let response = try await session.respond(to: prompt, generating: HealthyPlantAdvice.self)
        return .healthyPlant(response.content)
    }
    
    private func analyzeDiseaseCondition(selection: PlantDiseaseSelection) async throws -> AnalysisResult {
        let session = LanguageModelSession(instructions: ExpertInstructions.diseaseExpert)
        
        let prompt = Prompt("""
        A farmer has detected \(selection.disease.name) in their \(selection.plant.rawValue.lowercased()) crop. 
        
        Provide a comprehensive analysis including:
        - Disease identification and confirmation
        - Root causes and environmental conditions that lead to this disease
        - Treatment duration and recovery timeline
        - Specific remedies and treatment methods (both organic and conventional options)
        - Prevention measures for future occurrences
        - Severity assessment (1-5 scale)
        - When to seek professional agricultural help
        - Additional important considerations
        
        Be specific, practical, and actionable in your advice.
        """)
        
        let response = try await session.respond(to: prompt, generating: DiseaseAnalysis.self)
        return .diseaseDetected(response.content)
    }
    
    func prewarmSession() {
        guard isAvailable else { return }
        
        let session = LanguageModelSession(instructions: ExpertInstructions.diseaseExpert)
        session.prewarm()
        currentSession = session
    }
    
    func streamAnalysis(selection: PlantDiseaseSelection) -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    guard isAvailable else {
                        continuation.finish(throwing: PlantExpertError.modelUnavailable(unavailabilityReason))
                        return
                    }
                    
                    isProcessing = true
                    defer { isProcessing = false }
                    
                    let session = LanguageModelSession(
                        instructions: selection.disease.isHealthy ? 
                        ExpertInstructions.healthyPlantExpert : 
                        ExpertInstructions.diseaseExpert
                    )
                    
                    let prompt = createPrompt(for: selection)
                    
                    var streamedContent = ""
                    for try await token in session.streamResponse(to: prompt) {
                        streamedContent += token
                        continuation.yield(streamedContent)
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    private func createPrompt(for selection: PlantDiseaseSelection) -> Prompt {
        if selection.disease.isHealthy {
            return Prompt("""
            A farmer has a healthy \(selection.plant.rawValue.lowercased()) plant. Provide comprehensive advice on maintaining this plant's health and preventing diseases.
            """)
        } else {
            return Prompt("""
            A farmer has detected \(selection.disease.name) in their \(selection.plant.rawValue.lowercased()) crop. Provide a comprehensive analysis with causes, treatments, timeline, and prevention strategies.
            """)
        }
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

# 2

//
//  StreamingAnalysisView.swift
//  farmerdiseasedetection
//
//  Created by aryaman jaiswal on 15/07/25.
//

import SwiftUI

struct StreamingAnalysisView: View {
    let selection: PlantDiseaseSelection
    @ObservedObject var expertService: PlantExpertService
    @State private var streamedContent: String = ""
    @State private var isStreaming = false
    @State private var streamingError: String?
    @State private var hasFinished = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    streamHeader
                    
                    if let error = streamingError {
                        errorView(message: error)
                    } else {
                        streamingContentView
                    }
                    
                    if hasFinished {
                        actionButtons
                    }
                }
                .padding()
            }
            .navigationTitle("Real-time Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await startStreaming()
        }
    }
    
    private var streamHeader: some View {
        GlassCard {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: selection.disease.isHealthy ? "heart.fill" : "exclamationmark.triangle.fill")
                        .font(.title2)
                        .foregroundColor(selection.disease.isHealthy ? .green : .red)
                    
                    Text(selection.displayTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    if isStreaming {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.accentColor)
                        
                        Text("AI Expert is analyzing...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else if hasFinished {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.green)
                        
                        Text("Analysis complete")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var streamingContentView: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text("Expert Analysis")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if isStreaming {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(.accentColor)
                            .symbolEffect(.pulse)
                    }
                }
                
                if streamedContent.isEmpty && isStreaming {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        
                        Text("Preparing analysis...")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 20)
                } else {
                    ScrollView {
                        Text(streamedContent)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .animation(.easeInOut(duration: 0.1), value: streamedContent)
                    }
                    .frame(minHeight: 200)
                    
                    if isStreaming {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "pencil.line")
                                .font(.caption)
                                .foregroundColor(.accentColor)
                                .symbolEffect(.pulse)
                            
                            Text("Generating...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 8)
                    }
                }
            }
        }
    }
    
    private func errorView(message: String) -> some View {
        GlassCard {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title)
                    .foregroundColor(.red)
                
                Text("Streaming Error")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                GlassButton("Try Again") {
                    Task {
                        await startStreaming()
                    }
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            GlassButton("Get Structured Analysis") {
                // Navigate to structured analysis view
                dismiss()
            }
            
            Button("Share Analysis") {
                shareAnalysis()
            }
            .foregroundColor(.accentColor)
            .font(.body)
        }
    }
    
    private func startStreaming() async {
        streamedContent = ""
        isStreaming = true
        streamingError = nil
        hasFinished = false
        
        do {
            let stream = expertService.streamAnalysis(selection: selection)
            
            for try await content in stream {
                await MainActor.run {
                    streamedContent = content
                }
            }
            
            await MainActor.run {
                isStreaming = false
                hasFinished = true
            }
        } catch {
            await MainActor.run {
                streamingError = error.localizedDescription
                isStreaming = false
                hasFinished = false
            }
        }
    }
    
    private func shareAnalysis() {
        let activityController = UIActivityViewController(
            activityItems: [
                "Plant Disease Analysis for \(selection.displayTitle):\n\n\(streamedContent)"
            ],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true)
        }
    }
}

struct StreamingToggle: View {
    @Binding var isEnabled: Bool
    
    var body: some View {
        GlassCard {
            HStack {
                Image(systemName: "waveform")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Real-time Analysis")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("See analysis as it's generated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Toggle("", isOn: $isEnabled)
                    .labelsHidden()
            }
        }
    }
}

#Preview {
    StreamingAnalysisView(
        selection: PlantDiseaseSelection(
            plant: .potato,
            disease: Disease(name: "Late Blight", isHealthy: false)
        ),
        expertService: PlantExpertService()
    )
}

# 3
//
//  DiseaseAnalysisModel.swift
//  farmerdiseasedetection
//
//  Created by aryaman jaiswal on 15/07/25.
//

import Foundation
import FoundationModels

@Generable
struct DiseaseAnalysis {
    @Guide(description: "The specific disease name and affected plant type")
    let diseaseIdentification: String
    
    @Guide(description: "Primary causes and environmental conditions that lead to this disease")
    let causesAndConditions: String
    
    @Guide(description: "Expected treatment duration and recovery timeline")
    let treatmentDuration: String
    
    @Guide(description: "Specific remedies and treatment methods")
    let remedies: [String]
    
    @Guide(description: "Preventive measures to avoid future occurrences")
    let preventionMeasures: [String]
    
    @Guide(description: "Severity level from 1 (mild) to 5 (severe)")
    let severityLevel: Int
    
    @Guide(description: "When to seek professional agricultural help")
    let professionalHelpGuidance: String
    
    @Guide(description: "Additional notes or important considerations")
    let additionalNotes: String
}

@Generable
struct HealthyPlantAdvice {
    @Guide(description: "Positive acknowledgment of plant health")
    let healthStatus: String
    
    @Guide(description: "Recommended care practices for maintaining health")
    let maintenanceTips: [String]
    
    @Guide(description: "Preventive measures to avoid future diseases")
    let preventionStrategies: [String]
    
    @Guide(description: "Signs to watch for that might indicate problems")
    let earlyWarningSigns: [String]
    
    @Guide(description: "Optimal growing conditions for this plant")
    let optimalConditions: String
    
    @Guide(description: "Recommended monitoring frequency")
    let monitoringSchedule: String
}

enum AnalysisResult {
    case diseaseDetected(DiseaseAnalysis)
    case healthyPlant(HealthyPlantAdvice)
}

struct ExpertInstructions {
    static let diseaseExpert = Instructions("""
    You are a world-renowned plant pathologist and agricultural expert with decades of experience in diagnosing and treating plant diseases. 
    
    Your expertise includes:
    - Comprehensive knowledge of plant diseases, their causes, and treatments
    - Understanding of agricultural best practices
    - Ability to provide actionable, practical advice
    - Knowledge of both organic and conventional treatment methods
    - Understanding of disease progression and recovery timelines
    
    Guidelines for your responses:
    - Provide accurate, science-based information
    - Be specific about treatment methods and timelines
    - Include both immediate actions and long-term prevention strategies
    - Mention when professional help is needed
    - Use clear, practical language that farmers can understand
    - Consider environmental factors and sustainable practices
    - Be encouraging while being realistic about outcomes
    """)
    
    static let healthyPlantExpert = Instructions("""
    You are a positive and encouraging plant health expert who specializes in preventive care and optimal growing conditions.
    
    Your role is to:
    - Congratulate the user on their healthy plant
    - Provide maintenance tips to keep the plant healthy
    - Educate about prevention strategies
    - Help identify early warning signs
    - Encourage continued good practices
    
    Guidelines:
    - Be positive and encouraging
    - Focus on prevention rather than treatment
    - Provide specific, actionable advice
    - Include seasonal considerations
    - Promote sustainable growing practices
    """)
}
# 4

//
//  DiseaseDataModel.swift
//  farmerdiseasedetection
//
//  Created by aryaman jaiswal on 15/07/25.
//

import Foundation

enum PlantType: String, CaseIterable, Identifiable {
    case potato = "Potato"
    case corn = "Corn"
    case rice = "Rice"
    case wheat = "Wheat"
    case sugarCane = "Sugar Cane"
    
    var id: String { self.rawValue }
    
    var diseases: [Disease] {
        switch self {
        case .potato:
            return [
                Disease(name: "Healthy", isHealthy: true),
                Disease(name: "Late Blight", isHealthy: false),
                Disease(name: "Early Blight", isHealthy: false)
            ]
        case .corn:
            return [
                Disease(name: "Healthy", isHealthy: true),
                Disease(name: "Grey Leaf Spot", isHealthy: false),
                Disease(name: "Northern Leaf Blight", isHealthy: false),
                Disease(name: "Common Rust", isHealthy: false)
            ]
        case .rice:
            return [
                Disease(name: "Healthy", isHealthy: true),
                Disease(name: "Brown Spot", isHealthy: false),
                Disease(name: "Leaf Blast", isHealthy: false),
                Disease(name: "Neck Blast", isHealthy: false)
            ]
        case .wheat:
            return [
                Disease(name: "Healthy", isHealthy: true),
                Disease(name: "Yellow Rust", isHealthy: false),
                Disease(name: "Brown Rust", isHealthy: false)
            ]
        case .sugarCane:
            return [
                Disease(name: "Healthy", isHealthy: true),
                Disease(name: "Red Dot", isHealthy: false),
                Disease(name: "Bacterial Blight", isHealthy: false)
            ]
        }
    }
}

struct Disease: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let isHealthy: Bool
    
    var displayName: String {
        return name
    }
    
    var fullName: String {
        return name
    }
}

struct PlantDiseaseSelection {
    let plant: PlantType
    let disease: Disease
    
    var queryString: String {
        if disease.isHealthy {
            return "healthy \(plant.rawValue.lowercased()) plant"
        } else {
            return "\(disease.name) in \(plant.rawValue.lowercased())"
        }
    }
    
    var displayTitle: String {
        return "\(plant.rawValue) - \(disease.name)"
    }
}