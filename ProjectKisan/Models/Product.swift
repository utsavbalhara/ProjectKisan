import Foundation
import SwiftUI
import Combine

// MARK: - Product Class
class Product: ObservableObject, Identifiable, Codable {
    let id = UUID()
    @Published var name: String
    @Published var category: String
    @Published var price: Int
    @Published var recommendation: String
    @Published var instructions: String
    @Published var isSelected: Bool = false
    @Published var position: CGPoint = .zero
    
    init(name: String, category: String, price: Int, recommendation: String, instructions: String) {
        self.name = name
        self.category = category
        self.price = price
        self.recommendation = recommendation
        self.instructions = instructions
    }
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case name, category, price, recommendation, instructions, isSelected
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        price = try container.decode(Int.self, forKey: .price)
        recommendation = try container.decode(String.self, forKey: .recommendation)
        instructions = try container.decode(String.self, forKey: .instructions)
        isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(price, forKey: .price)
        try container.encode(recommendation, forKey: .recommendation)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(isSelected, forKey: .isSelected)
    }
    
    // MARK: - Convenience Methods
    func toggleSelection() {
        isSelected.toggle()
    }
    
    func updatePosition(to newPosition: CGPoint) {
        position = newPosition
    }
    
    // Create Product from ProductRecommendation
    static func from(_ productRecommendation: ProductRecommendation) -> Product {
        return Product(
            name: productRecommendation.name,
            category: productRecommendation.category,
            price: productRecommendation.price,
            recommendation: productRecommendation.recommendation,
            instructions: productRecommendation.instructions
        )
    }
}

// MARK: - ProductManager
class ProductManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var selectedProducts: [Product] = []
    
    // MARK: - Product Management
    func updateProducts(from recommendations: [ProductRecommendation]) {
        // Clear existing products
        products.removeAll()
        
        // Convert ProductRecommendations to Product objects
        let newProducts = recommendations.map { Product.from($0) }
        products.append(contentsOf: newProducts)
        
        // Update selected products list
        updateSelectedProducts()
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
        updateSelectedProducts()
    }
    
    func removeProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
        updateSelectedProducts()
    }
    
    func removeProduct(at index: Int) {
        guard index < products.count else { return }
        products.remove(at: index)
        updateSelectedProducts()
    }
    
    func toggleProductSelection(_ product: Product) {
        product.toggleSelection()
        updateSelectedProducts()
    }
    
    func selectAllProducts() {
        products.forEach { $0.isSelected = true }
        updateSelectedProducts()
    }
    
    func deselectAllProducts() {
        products.forEach { $0.isSelected = false }
        updateSelectedProducts()
    }
    
    private func updateSelectedProducts() {
        selectedProducts = products.filter { $0.isSelected }
    }
    
    // MARK: - Product Queries
    func getProducts(by category: String) -> [Product] {
        return products.filter { $0.category.lowercased() == category.lowercased() }
    }
    
    func searchProducts(by name: String) -> [Product] {
        return products.filter { $0.name.lowercased().contains(name.lowercased()) }
    }
    
    func getProductsSortedByPrice(ascending: Bool = true) -> [Product] {
        return products.sorted { ascending ? $0.price < $1.price : $0.price > $1.price }
    }
    
    // MARK: - Data Persistence
    func saveProducts() {
        guard let data = try? JSONEncoder().encode(products) else { return }
        UserDefaults.standard.set(data, forKey: "SavedProducts")
    }
    
    func loadProducts() {
        guard let data = UserDefaults.standard.data(forKey: "SavedProducts"),
              let savedProducts = try? JSONDecoder().decode([Product].self, from: data) else { return }
        
        // Convert decoded products to observable objects
        products = savedProducts.map { product in
            let newProduct = Product(
                name: product.name,
                category: product.category,
                price: product.price,
                recommendation: product.recommendation,
                instructions: product.instructions
            )
            newProduct.isSelected = product.isSelected
            return newProduct
        }
        updateSelectedProducts()
    }
    
    // MARK: - Utility Methods
    var totalProductsCount: Int {
        return products.count
    }
    
    var selectedProductsCount: Int {
        return selectedProducts.count
    }
    
    var totalEstimatedCost: Int {
        return selectedProducts.reduce(0) { $0 + $1.price }
    }
    
    func clearAllProducts() {
        products.removeAll()
        selectedProducts.removeAll()
    }
}

// MARK: - Extensions
extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
