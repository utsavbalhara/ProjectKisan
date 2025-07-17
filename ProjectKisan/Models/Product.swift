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
    
    // Convert Product to ProductRecommendation
    func toProductRecommendation() -> ProductRecommendation {
        return ProductRecommendation(
            name: name,
            category: category,
            price: price,
            recommendation: recommendation,
            instructions: instructions
        )
    }
}

// MARK: - ProductManager
class ProductManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var cartProducts: [Product] = []
    @Published var orderHistory: [Order] = []
    
    // MARK: - Product Management
    func updateProducts(from recommendations: [ProductRecommendation]) {
        // Clear existing products
        products.removeAll()
        
        // Convert ProductRecommendations to Product objects
        let newProducts = recommendations.map { Product.from($0) }
        products.append(contentsOf: newProducts)
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
    }
    
    func removeProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
    }
    
    func removeProduct(at index: Int) {
        guard index < products.count else { return }
        products.remove(at: index)
    }
    
    // MARK: - Cart Management
    func addToCart(_ product: Product) {
        // Create a copy of the product for the cart
        let cartProduct = Product(
            name: product.name,
            category: product.category,
            price: product.price,
            recommendation: product.recommendation,
            instructions: product.instructions
        )
        cartProducts.append(cartProduct)
        saveCart()
    }
    
    func removeFromCart(_ product: Product) {
        cartProducts.removeAll { $0.id == product.id }
        saveCart()
    }
    
    func removeFromCart(at index: Int) {
        guard index < cartProducts.count else { return }
        cartProducts.remove(at: index)
        saveCart()
    }
    
    func clearCart() {
        cartProducts.removeAll()
        saveCart()
    }
    
    func isInCart(_ product: Product) -> Bool {
        return cartProducts.contains { $0.name == product.name }
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
    }
    
    func saveCart() {
        guard let data = try? JSONEncoder().encode(cartProducts) else { return }
        UserDefaults.standard.set(data, forKey: "CartProducts")
    }
    
    func loadCart() {
        guard let data = UserDefaults.standard.data(forKey: "CartProducts"),
              let savedCart = try? JSONDecoder().decode([Product].self, from: data) else { return }
        
        // Convert decoded cart products to observable objects
        cartProducts = savedCart.map { product in
            let newProduct = Product(
                name: product.name,
                category: product.category,
                price: product.price,
                recommendation: product.recommendation,
                instructions: product.instructions
            )
            return newProduct
        }
    }
    
    // MARK: - Utility Methods
    var totalProductsCount: Int {
        return products.count
    }
    
    var cartItemsCount: Int {
        return cartProducts.count
    }
    
    var totalCartValue: Int {
        return cartProducts.reduce(0) { $0 + $1.price }
    }
    
    func clearAllProducts() {
        products.removeAll()
        cartProducts.removeAll()
        saveProducts()
        saveCart()
    }
    
    // MARK: - Order Management
    func createOrder(from cartProducts: [Product]) -> Order {
        let totalAmount = cartProducts.reduce(0) { $0 + $1.price }
        let order = Order(products: cartProducts, totalAmount: totalAmount)
        orderHistory.append(order)
        saveOrderHistory()
        return order
    }
    
    func checkout() -> Order {
        let order = createOrder(from: cartProducts)
        clearCart()
        return order
    }
    
    func saveOrderHistory() {
        guard let data = try? JSONEncoder().encode(orderHistory) else { return }
        UserDefaults.standard.set(data, forKey: "OrderHistory")
    }
    
    func loadOrderHistory() {
        guard let data = UserDefaults.standard.data(forKey: "OrderHistory"),
              let savedOrders = try? JSONDecoder().decode([Order].self, from: data) else { return }
        orderHistory = savedOrders
    }
    
    var totalOrdersCount: Int {
        return orderHistory.count
    }
    
    var totalOrderValue: Int {
        return orderHistory.reduce(0) { $0 + $1.totalAmount }
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

// MARK: - Order Model
class Order: ObservableObject, Identifiable, Codable {
    let id: UUID
    let products: [Product]
    let totalAmount: Int
    let orderDate: Date
    let orderNumber: String
    let status: OrderStatus
    
    init(products: [Product], totalAmount: Int, orderDate: Date = Date(), status: OrderStatus = .processing) {
        self.id = UUID()
        self.products = products
        self.totalAmount = totalAmount
        self.orderDate = orderDate
        self.orderNumber = "ORD-\(Int.random(in: 100000...999999))"
        self.status = status
    }
    
    enum CodingKeys: String, CodingKey {
        case id, products, totalAmount, orderDate, orderNumber, status
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        products = try container.decode([Product].self, forKey: .products)
        totalAmount = try container.decode(Int.self, forKey: .totalAmount)
        orderDate = try container.decode(Date.self, forKey: .orderDate)
        orderNumber = try container.decode(String.self, forKey: .orderNumber)
        status = try container.decode(OrderStatus.self, forKey: .status)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(products, forKey: .products)
        try container.encode(totalAmount, forKey: .totalAmount)
        try container.encode(orderDate, forKey: .orderDate)
        try container.encode(orderNumber, forKey: .orderNumber)
        try container.encode(status, forKey: .status)
    }
}

enum OrderStatus: String, CaseIterable, Codable {
    case processing = "Processing"
    case shipped = "Shipped"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    
    var color: Color {
        switch self {
        case .processing:
            return .orange
        case .shipped:
            return .blue
        case .delivered:
            return .green
        case .cancelled:
            return .red
        }
    }
}

// MARK: - Shared ProductManager Instance
extension ProductManager {
    static let shared = ProductManager()
}
