# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ProjectKisan is a comprehensive iOS app for Indian farmers that combines AI-powered plant disease detection, farm management, marketplace functionality, and IoT sensor integration. The app leverages Apple's Foundation Models (Apple Intelligence) for on-device AI analysis and CoreML for image classification.

## Build & Development Commands

**Build the project:**
```bash
# Open in Xcode (required for iOS development)
open ProjectKisan.xcodeproj
```

**Testing:**
- Build and run in Xcode using Cmd+R
- Test on physical iOS device (iPhone 15 Pro+ or iPhone 16 series) for Apple Intelligence features
- iOS Simulator does not support Foundation Models/Apple Intelligence

**Important Device Requirements:**
- Foundation Models require physical iPhone 15 Pro/Pro Max or iPhone 16 series with iOS 18.1+
- Apple Intelligence must be enabled in Settings > Apple Intelligence & Siri
- iOS Simulator will show "model unavailable" errors for AI features

## Architecture Overview

### App Structure
ProjectKisan uses a tab-based navigation with four main modules:

1. **Farms (FeedView)** - Farm management and monitoring
2. **Disease Detection (HomeView)** - AI-powered plant disease analysis
3. **Marketplace** - Agricultural product purchasing
4. **Profile** - User profile, earnings, and order history

### Core AI Pipeline (Disease Detection)
1. **Image Capture** → `NewRecipeCard` (camera/photo library)
2. **Classification** → `PlantClassificationService` (CoreML with `FasalDiseaseClassifier.mlmodel`)
3. **AI Analysis** → `PlantExpertService` (Apple Foundation Models)
4. **UI Display** → `FullScreenImageView` (structured disease/health advice)

### Data Flow
```
UIImage → CoreML Classification → Plant Expert Analysis → Structured Output
```

### Key Services

**PlantClassificationService:**
- Uses CoreML model `FasalDiseaseClassifier.mlmodel`
- Extracts crop name, disease name, and confidence from classification results
- Handles identifier parsing (supports `__` and `_` separators)

**PlantExpertService:**
- Leverages Apple's Foundation Models (`SystemLanguageModel.default`)
- Generates structured disease analysis or healthy plant advice
- Uses `@Generable` models with `@Guide` annotations for consistent AI output
- Has availability checks and fallback error handling

**CropInsightsService:**
- Generates AI-powered farming recommendations based on weather and IoT data
- Provides daily tasks, pest alerts, fertilizer advice, and maintenance insights
- Integrates with farm data for contextual recommendations

## Data Models

### Disease Detection Models
**Structured AI Output:**
- `DiseaseAnalysis`: Crop name, disease info, treatment steps, products, prevention tips
- `HealthyPlantAdvice`: Crop name, maintenance tips, plant info, prevention tips
- `TreatmentStep`: Title (2-5 words) + description (1-2 lines)
- `ProductRecommendation2`: Name, usage instructions, INR pricing
- `PreventionTip`: Title, description, SF Symbol icon

**Key Constraints:**
- Titles: 2-5 words maximum
- Descriptions: 1-2 lines maximum (under 100 characters)
- Exactly 4 treatment/maintenance steps
- Exactly 3 product recommendations
- Exactly 4 prevention tips with icons
- Scientific names included for diseases/plants

### Farm Management Models
**Farm System:**
- `Farm`: Core farm entity with crop type, area, current stage
- `CropStage`: Enum representing farming lifecycle (7 stages from preparation to post-harvest)
- `WeatherData`: Temperature, precipitation, wind, humidity, sunshine hours
- `IoTSensorData`: Soil moisture, soil temperature, pH, air temperature, nutrient levels

**Crop Insights:**
- `CropInsights`: AI-generated recommendations combining weather and IoT data
- `TaskRecommendation`: Daily farming tasks with priority and timing
- `PestAlert`: Pest/disease warnings with risk levels and preventive actions
- `FertilizerRecommendation`: Fertilizer type, timing, and application rates

### Marketplace Models
**Product System:**
- `MarketplaceProduct`: Products with categories, pricing, ratings, features
- `ProductCategory`: Farmicides, Pesticides, Manures, Tools (each with icons and colors)
- `Product`: Cart/order system integration
- `OrderItem`: Order history tracking

## UI Architecture

### Navigation Structure
- Tab-based navigation via `MainTabView`
- Onboarding flow for first-time users via `OnboardingView`
- Disease detection is primary feature (center tab)

### Key Views by Module

**Farms Module (Tab 1):**
- `FeedView`: Farm list with weather/IoT preview
- `FarmCard`: Individual farm preview cards
- `FarmDetailView`: Detailed farm information with weather/IoT data, progress tracking
- `CropInsightsView`: AI-powered farming recommendations

**Disease Detection Module (Tab 2):**
- `HomeView`: Disease detection entry point
- `NewRecipeCard`: Camera/photo capture interface
- `FullScreenImageView`: AI analysis results display with expandable cards

**Marketplace Module (Tab 3):**
- `MarketplaceView`: Product browsing with search, filters, categories
- `ProductDetailView`: Individual product information
- `CartView`: Shopping cart management
- `CheckoutView`: Order processing

**Profile Module (Tab 4):**
- `ProfileView`: User profile with earnings and revenue cards
- `EarningsDetailView`/`RevenueDetailView`: Detailed financial information
- `OrderHistoryView`: Purchase history tracking

### UI Design System
- Uses custom farm color palette (`FarmColors.swift`)
- Liquid Glass effects for modern iOS aesthetic (see `LIQUIDGLASS.md`)
- Consistent card-based layouts with `.ultraThinMaterial` backgrounds
- Progressive disclosure with expandable cards and detail views

## Foundation Models Integration

### LLM Prompt System (Three Layers)
1. **System Instructions** (`ExpertInstructions`): Define AI persona and constraints
2. **Task Prompts**: Specific analysis instructions with farm data
3. **Structure Prompts** (`@Guide` annotations): Field-level output formatting

**Expert Instructions:**
- Concise, farmer-friendly language
- Indian market focus (INR pricing)
- Length constraints enforced via system prompts
- SF Symbol icons for prevention tips

**Error Handling:**
- Device eligibility checks
- Apple Intelligence availability validation
- Graceful fallbacks for model unavailability

## Data Management Patterns

### Observable ViewModels
- `FeedViewModel`: Manages farm data and loading
- `ProfileViewModel`: Handles user profile and financial data
- `CookViewModel`: Disease detection workflow state

### Shared Managers
- `MarketplaceManager.shared`: Product filtering, searching, sorting
- `ProductManager.shared`: Cart state, order history management
- `PlantClassificationService.shared`: Disease detection pipeline

### State Management
- Uses `@Observable` for modern SwiftUI state management
- `@StateObject` for service instances
- `@State` for local view state

## Development Notes

**Apple Intelligence Requirements:**
- Always test AI features on physical devices
- Check `PlantExpertService.isAvailable` before using AI features
- Handle model unavailability gracefully

**CoreML Model:**
- `FasalDiseaseClassifier.mlmodel` processes plant images
- Returns classification with confidence scores
- Supports various crop and disease combinations

**IoT Integration:**
- Farm data includes real-time sensor readings
- Weather data integration for farming recommendations
- Combines with AI for contextual insights

**E-commerce Features:**
- Full shopping cart and checkout workflow
- Order history tracking
- Product categorization with filtering/search

**Data Constraints:**
- All AI-generated content has strict length limits
- Prevention tips use curated SF Symbol icon set
- Product pricing in Indian Rupees (₹) and US Dollars ($)
- Scientific names required for accuracy