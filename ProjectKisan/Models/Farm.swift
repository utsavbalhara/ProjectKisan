import Foundation

enum CropStage: String, CaseIterable {
    case preparation = "Preparation"
    case sowingPlanting = "Sowing/Planting"
    case cropManagement = "Crop Management"
    case irrigation = "Irrigation"
    case weeding = "Weeding"
    case harvesting = "Harvesting"
    case postHarvestStorage = "Post-Harvest/Storage"
    
    var progressValue: Double {
        switch self {
        case .preparation: return 1.0/7.0
        case .sowingPlanting: return 2.0/7.0
        case .cropManagement: return 3.0/7.0
        case .irrigation: return 4.0/7.0
        case .weeding: return 5.0/7.0
        case .harvesting: return 6.0/7.0
        case .postHarvestStorage: return 7.0/7.0
        }
    }
}

class Farm: Identifiable {
    let id = UUID()
    let typeOfCrop: String
    let areaInAcres: Double
    let currentStage: CropStage
    
    init(typeOfCrop: String, areaInAcres: Double, currentStage: CropStage) {
        self.typeOfCrop = typeOfCrop
        self.areaInAcres = areaInAcres
        self.currentStage = currentStage
    }
}
