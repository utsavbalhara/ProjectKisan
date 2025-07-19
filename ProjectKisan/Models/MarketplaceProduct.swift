import Foundation
import SwiftUI
import Combine

// MARK: - Product Category Enum
enum ProductCategory: String, CaseIterable, Codable {
    case farmicides = "Farmicides"
    case pesticides = "Pesticides"
    case manures = "Manures"
    case tools = "Tools"
    
    var icon: String {
        switch self {
        case .farmicides:
            return "drop.fill"
        case .pesticides:
            return "shield.fill"
        case .manures:
            return "leaf.fill"
        case .tools:
            return "wrench.and.screwdriver.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .farmicides:
            return .blue
        case .pesticides:
            return .red
        case .manures:
            return .green
        case .tools:
            return .orange
        }
    }
    
    var description: String {
        switch self {
        case .farmicides:
            return "Crop protection chemicals"
        case .pesticides:
            return "Pest control solutions"
        case .manures:
            return "Organic fertilizers"
        case .tools:
            return "Farming equipment"
        }
    }
}

// MARK: - Marketplace Product
struct MarketplaceProduct: Identifiable, Codable {
    var id = UUID()
    let name: String
    let category: ProductCategory
    let price: Int
    let originalPrice: Int?
    let description: String
    let imageURL: String?
    let rating: Double
    let reviewCount: Int
    let inStock: Bool
    let features: [String]
    let brand: String
    let unit: String // e.g., "per liter", "per kg", "per piece"
    
    init(name: String, category: ProductCategory, price: Int, originalPrice: Int? = nil, description: String, imageURL: String? = nil, rating: Double = 4.5, reviewCount: Int = 0, inStock: Bool = true, features: [String] = [], brand: String, unit: String) {
        self.name = name
        self.category = category
        self.price = price
        self.originalPrice = originalPrice
        self.description = description
        self.imageURL = imageURL
        self.rating = rating
        self.reviewCount = reviewCount
        self.inStock = inStock
        self.features = features
        self.brand = brand
        self.unit = unit
    }
    
    var discountPercentage: Int? {
        guard let originalPrice = originalPrice, originalPrice > price else { return nil }
        return Int(((Double(originalPrice - price) / Double(originalPrice)) * 100).rounded())
    }
    
    var isOnSale: Bool {
        return originalPrice != nil && originalPrice! > price
    }
    
    // Convert to Product for cart/order system
    func toProduct() -> Product {
        return Product(
            name: name,
            category: category.rawValue,
            price: price,
            recommendation: description,
            instructions: features.joined(separator: "\n• ")
        )
    }
}

// MARK: - Sample Data
extension MarketplaceProduct {
    static let sampleProducts: [MarketplaceProduct] = [
        // Farmicides
        MarketplaceProduct(
            name: "GrowMax Plant Nutrient",
            category: .farmicides,
            price: 1450,
            originalPrice: 1550,
            description: "Advanced plant nutrition formula for healthy crop growth",
            imageURL: "growmax_nutrient",
            rating: 4.8,
            reviewCount: 124,
            features: ["Balanced NPK formula", "Improves soil health", "Organic certified"],
            brand: "GrowMax",
            unit: "per liter"
        ),
        MarketplaceProduct(
            name: "CropBoost Fertilizer",
            category: .farmicides,
            price: 1350,
            description: "Premium fertilizer for enhanced crop yield",
            imageURL: "cropboost_fertilizer",
            rating: 4.6,
            reviewCount: 89,
            features: ["Fast-acting formula", "Suitable for all crops", "Weather resistant"],
            brand: "CropBoost",
            unit: "per kg"
        ),
        
        // Pesticides
        MarketplaceProduct(
            name: "BugAway Insect Control",
            category: .pesticides,
            price: 1280,
            originalPrice: 1350,
            description: "Effective insect control solution for crops",
            imageURL: "bugaway_insecticide",
            rating: 4.7,
            reviewCount: 156,
            features: ["Broad spectrum control", "Safe for beneficial insects", "Long-lasting protection"],
            brand: "BugAway",
            unit: "per bottle"
        ),
        MarketplaceProduct(
            name: "PestShield Pro",
            category: .pesticides,
            price: 1420,
            description: "Professional grade pest control solution",
            imageURL: "pestshield_pro",
            rating: 4.9,
            reviewCount: 67,
            features: ["Systemic action", "Prevents resistance", "Eco-friendly"],
            brand: "PestShield",
            unit: "per liter"
        ),
        
        // Manures
        MarketplaceProduct(
            name: "OrganicGrow Compost",
            category: .manures,
            price: 1220,
            description: "Premium organic compost for soil enrichment",
            imageURL: "organicgrow_compost",
            rating: 4.5,
            reviewCount: 98,
            features: ["100% organic", "Improves soil structure", "Rich in nutrients"],
            brand: "OrganicGrow",
            unit: "per 25kg bag"
        ),
        MarketplaceProduct(
            name: "FarmFresh Manure",
            category: .manures,
            price: 1180,
            originalPrice: 1250,
            description: "Natural farm manure for healthy soil",
            imageURL: "farmfresh_manure",
            rating: 4.4,
            reviewCount: 142,
            features: ["Natural and organic", "Improves water retention", "Slow-release nutrients"],
            brand: "FarmFresh",
            unit: "per 20kg bag"
        ),
        
        // Tools
        MarketplaceProduct(
            name: "ProFarm Sprayer",
            category: .tools,
            price: 2125,
            originalPrice: 2150,
            description: "Professional grade crop sprayer",
            imageURL: "profarm_sprayer",
            rating: 4.8,
            reviewCount: 45,
            features: ["Adjustable nozzle", "Ergonomic design", "Leak-proof tank"],
            brand: "ProFarm",
            unit: "per piece"
        ),
        MarketplaceProduct(
            name: "SmartTill Cultivator",
            category: .tools,
            price: 1890,
            description: "Efficient soil cultivation tool",
            imageURL: "smarttill_cultivator",
            rating: 4.6,
            reviewCount: 73,
            features: ["Lightweight design", "Durable construction", "Easy to maintain"],
            brand: "SmartTill",
            unit: "per piece"
        )
    ]
}

// MARK: - Marketplace Manager
class MarketplaceManager: ObservableObject {
    @Published var products: [MarketplaceProduct] = []
    @Published var filteredProducts: [MarketplaceProduct] = []
    @Published var selectedCategory: ProductCategory? = nil
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .name
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case priceAsc = "Price: Low to High"
        case priceDesc = "Price: High to Low"
        case rating = "Rating"
        case popularity = "Popularity"
        
        var sortDescriptor: (MarketplaceProduct, MarketplaceProduct) -> Bool {
            switch self {
            case .name:
                return { $0.name < $1.name }
            case .priceAsc:
                return { $0.price < $1.price }
            case .priceDesc:
                return { $0.price > $1.price }
            case .rating:
                return { $0.rating > $1.rating }
            case .popularity:
                return { $0.reviewCount > $1.reviewCount }
            }
        }
    }
    
    init() {
        loadProducts()
        filterProducts()
    }
    
    func loadProducts() {
        products = MarketplaceProduct.sampleProducts
    }
    
    func filterProducts() {
        var filtered = products
        
        // Filter by category
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.description.localizedCaseInsensitiveContains(searchText) ||
                product.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Sort products
        filtered.sort(by: sortOption.sortDescriptor)
        
        filteredProducts = filtered
    }
    
    func selectCategory(_ category: ProductCategory?) {
        selectedCategory = category
        filterProducts()
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        filterProducts()
    }
    
    func updateSortOption(_ option: SortOption) {
        sortOption = option
        filterProducts()
    }
    
    func getProductsByCategory(_ category: ProductCategory) -> [MarketplaceProduct] {
        return products.filter { $0.category == category }
    }
    
}

// MARK: - Shared Instance
extension MarketplaceManager {
    static let shared = MarketplaceManager()
}
