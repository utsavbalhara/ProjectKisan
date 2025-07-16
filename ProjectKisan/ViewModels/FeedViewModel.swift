import SwiftUI

@Observable
class FeedViewModel {
    var farms: [Farm] = []
    
    init() {
        loadFarms()
    }
    
    private func loadFarms() {
        farms = [
            Farm(typeOfCrop: "Wheat", areaInAcres: 25.5, currentStage: .cropManagement),
            Farm(typeOfCrop: "Rice", areaInAcres: 18.0, currentStage: .irrigation)
        ]
    }
}