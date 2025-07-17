import Foundation
import SwiftUI

// MARK: - Profile Data Models
struct ProfileData {
    let farmerName: String
    let location: String
    let profileImageName: String
    let totalEarnings: Double
    let totalRevenue: Double
    let lastUpdated: Date
    let farms: [Farm]
    let orderHistory: [OrderItem]
    
    init(farmerName: String = "Raj Kumar", location: String = "Punjab, India", profileImageName: String = "person.circle.fill") {
        self.farmerName = farmerName
        self.location = location
        self.profileImageName = profileImageName
        self.lastUpdated = Date()
        
        // Sample farm data
        self.farms = [
            Farm(typeOfCrop: "Wheat", areaInAcres: 2.5, currentStage: .harvesting),
            Farm(typeOfCrop: "Rice", areaInAcres: 1.8, currentStage: .irrigation),
            Farm(typeOfCrop: "Sugarcane", areaInAcres: 3.2, currentStage: .cropManagement)
        ]
        
        // Calculate earnings and revenue based on farms
        let wheatEarnings = 2.5 * 18000 // ₹18,000 per acre
        let riceEarnings = 1.8 * 22000 // ₹22,000 per acre
        let sugarcaneEarnings = 3.2 * 24000 // ₹24,000 per acre
        
        self.totalEarnings = wheatEarnings + riceEarnings + sugarcaneEarnings
        self.totalRevenue = self.totalEarnings * 1.15 // 15% markup
        
        // Empty order history for now
        self.orderHistory = []
    }
}

struct EarningsBreakdown: Identifiable {
    let id = UUID()
    let farmName: String
    let cropType: String
    let areaInAcres: Double
    let estimatedEarnings: Double
    let earningsPerAcre: Double
    let currentStage: CropStage
    let lastUpdated: Date
    
    var formattedEarnings: String {
        return "₹\(Int(estimatedEarnings).formatted())"
    }
    
    var formattedArea: String {
        return String(format: "%.1f acres", areaInAcres)
    }
}

struct OrderItem: Identifiable {
    let id = UUID()
    let type: OrderType
    let name: String
    let date: Date
    let amount: Double
    let status: OrderStatus
    
    enum OrderType: String, CaseIterable {
        case pesticide = "Pesticide"
        case fertilizer = "Fertilizer"
        case seeds = "Seeds"
        case equipment = "Equipment"
        
        var icon: String {
            switch self {
            case .pesticide: return "drop.fill"
            case .fertilizer: return "leaf.fill"
            case .seeds: return "seedling.fill"
            case .equipment: return "wrench.fill"
            }
        }
    }
    
    enum OrderStatus: String, CaseIterable {
        case pending = "Pending"
        case delivered = "Delivered"
        case cancelled = "Cancelled"
    }
}

// MARK: - Profile ViewModel
@Observable
class ProfileViewModel {
    var profileData: ProfileData
    var isShowingAccountDetails = false
    var isShowingEarningsDetail = false
    var isShowingRevenueDetail = false
    var selectedEarningsBreakdown: [EarningsBreakdown] = []
    
    init() {
        self.profileData = ProfileData()
        self.generateEarningsBreakdown()
    }
    
    private func generateEarningsBreakdown() {
        let farmNames = ["North Field", "South Field", "East Field"]
        let earningsPerAcre: [String: Double] = [
            "Wheat": 18000,
            "Rice": 22000,
            "Sugarcane": 24000
        ]
        
        selectedEarningsBreakdown = profileData.farms.enumerated().map { index, farm in
            let earnings = farm.areaInAcres * (earningsPerAcre[farm.typeOfCrop] ?? 20000)
            return EarningsBreakdown(
                farmName: farmNames[safe: index] ?? "Farm \(index + 1)",
                cropType: farm.typeOfCrop,
                areaInAcres: farm.areaInAcres,
                estimatedEarnings: earnings,
                earningsPerAcre: earningsPerAcre[farm.typeOfCrop] ?? 20000,
                currentStage: farm.currentStage,
                lastUpdated: profileData.lastUpdated
            )
        }
    }
    
    // MARK: - User Actions
    func showAccountDetails() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            isShowingAccountDetails = true
        }
    }
    
    func showEarningsDetail() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            isShowingEarningsDetail = true
        }
    }
    
    func showRevenueDetail() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            isShowingRevenueDetail = true
        }
    }
    
    func hideEarningsDetail() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            isShowingEarningsDetail = false
        }
    }
    
    func hideRevenueDetail() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            isShowingRevenueDetail = false
        }
    }
    
    // MARK: - Formatted Data
    var formattedTotalEarnings: String {
        return "₹\(Int(profileData.totalEarnings).formatted())"
    }
    
    var formattedTotalRevenue: String {
        return "₹\(Int(profileData.totalRevenue).formatted())"
    }
    
    var lastUpdatedText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "Updated \(formatter.string(from: profileData.lastUpdated))"
    }
}

// MARK: - Array Extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
