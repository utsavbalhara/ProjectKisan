import Foundation
import FoundationModels

enum CropInsightsError: Error {
    case modelUnavailable(String)
    case generationFailed(String)
    case invalidFarmData
    
    var localizedDescription: String {
        switch self {
        case .modelUnavailable(let reason):
            return "AI model unavailable: \(reason)"
        case .generationFailed(let reason):
            return "Failed to generate insights: \(reason)"
        case .invalidFarmData:
            return "Invalid farm data provided"
        }
    }
}

@Observable
class CropInsightsService {
    private let model = SystemLanguageModel.default
    private var session: LanguageModelSession?
    
    var isGenerating = false
    var lastError: CropInsightsError?
    
    init() {
        setupSession()
    }
    
    private func setupSession() {
        let instructions = Instructions("""
        You are an expert agricultural advisor with deep knowledge of crop management, pest control, disease prevention, and farming best practices. 
        
        Analyze the provided farm data including:
        - Crop type and growth stage
        - Weather conditions (temperature, humidity, precipitation, wind)
        - Soil sensor data (moisture, temperature, pH, nutrients)
        - Farm area and location factors
        
        Provide specific, actionable recommendations with:
        1. Daily task priorities based on current conditions
        2. Pest and disease risk assessments
        3. Optimal fertilizer application timing
        4. Maintenance insights for crop health
        5. Product recommendations with realistic market prices
        
        Be practical, specific, and consider real-world farming constraints.
        """)
        
        session = LanguageModelSession(instructions: instructions)
    }
    
    func generateInsights(for farm: Farm) async throws -> CropInsights {
        guard case .available = model.availability else {
            let reason = getUnavailabilityReason()
            throw CropInsightsError.modelUnavailable(reason)
        }
        
        guard let session = session else {
            throw CropInsightsError.generationFailed("Session not initialized")
        }
        
        isGenerating = true
        lastError = nil
        
        do {
            let prompt = buildPrompt(for: farm)
            let response = try await session.respond(to: prompt, generating: CropInsights.self)
            
            isGenerating = false
            return response.content
            
        } catch {
            isGenerating = false
            lastError = .generationFailed(error.localizedDescription)
            throw lastError!
        }
    }
    
    private func buildPrompt(for farm: Farm) -> Prompt {
        let promptText = """
        Please analyze the following farm data and provide comprehensive crop insights:

        **Farm Information:**
        - Crop: \(farm.typeOfCrop)
        - Area: \(String(format: "%.1f", farm.areaInAcres)) acres
        - Current Growth Stage: \(farm.currentStage.rawValue)

        **Weather Conditions:**
        - Temperature: \(String(format: "%.1f", farm.weatherData.temperature))°C
        - Precipitation: \(String(format: "%.1f", farm.weatherData.precipitation))mm
        - Wind Speed: \(String(format: "%.1f", farm.weatherData.windSpeed)) km/h
        - Wind Direction: \(farm.weatherData.windDirection)
        - Humidity: \(String(format: "%.1f", farm.weatherData.humidity))%
        - Hours of Sunshine: \(String(format: "%.1f", farm.weatherData.hoursOfSunshine)) hours

        **Soil & Environmental Sensors:**
        - Soil Moisture: \(String(format: "%.1f", farm.iotSensorData.soilMoisture))%
        - Soil Temperature: \(String(format: "%.1f", farm.iotSensorData.soilTemperature))°C
        - Soil pH: \(String(format: "%.1f", farm.iotSensorData.soilPH))
        - Air Temperature: \(String(format: "%.1f", farm.iotSensorData.airTemperature))°C
        - Air Humidity: \(String(format: "%.1f", farm.iotSensorData.humidity))%
        - Nutrient Levels: \(farm.iotSensorData.nutrientLevels)

        Based on this data, provide:
        1. 2-3 specific daily task recommendations with priority levels
        2. Pest/disease risk assessment for current conditions
        3. Fertilizer application advice considering weather and soil data
        4. General maintenance insights for \(farm.typeOfCrop) at \(farm.currentStage.rawValue) stage
        5. 3-5 product recommendations with realistic market prices ($10-$500 range)
        
        Focus on actionable advice that considers the current weather patterns and crop vulnerability.
        """
        
        return Prompt(promptText)
    }
    
    private func getUnavailabilityReason() -> String {
        switch model.availability {
        case .unavailable(let reason):
            switch reason {
            case .deviceNotEligible:
                return "This device is not compatible with Apple Intelligence"
            case .appleIntelligenceNotEnabled:
                return "Apple Intelligence is not enabled in Settings"
            case .modelNotReady:
                return "AI model is downloading or initializing"
            default:
                return "AI model is temporarily unavailable"
            }
        default:
            return "Unknown availability issue"
        }
    }
    
    func prewarmSession() async {
        await session?.prewarm()
    }
}
