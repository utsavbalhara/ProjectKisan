import SwiftUI

struct SuggestedProductsView: View {
    let products: [ProductRecommendation]
    @Environment(\.dismiss) private var dismiss
    @StateObject private var productManager = ProductManager.shared
    @State private var showingCart = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.farmColors.backgroundLight,
                        Color.farmColors.backgroundMedium.opacity(0.3),
                        Color.farmColors.backgroundLight
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        
                        // Products List
                        LazyVStack(spacing: 16) {
                            ForEach(Array(products.enumerated()), id: \.offset) { index, product in
                                ProductCard(product: product)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Footer
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(Color.farmColors.primary)
                                
                                Text("Prices are estimated based on current market conditions")
                                    .font(.caption)
                                    .foregroundColor(Color.farmColors.textSecondary)
                            }
                            
                            Button(action: {
                                // TODO: Navigate to marketplace
                            }) {
                                HStack {
                                    Image(systemName: "storefront.fill")
                                        .font(.subheadline)
                                    
                                    Text("Browse Full Marketplace")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(Color.farmColors.primary)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                .background(Color.farmColors.primary.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Suggested Products")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.farmColors.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCart = true
                    }) {
                        HStack {
                            ZStack {
                                Image(systemName: "cart.fill")
                                    .font(.subheadline)
                                
                                if productManager.cartItemsCount > 0 {
                                    Text("\(productManager.cartItemsCount)")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(width: 16, height: 16)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 8, y: -8)
                                }
                            }
                            Text("Cart")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(Color.farmColors.primary)
                    }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .onAppear {
            // Update ProductManager with current recommendations when view appears
            productManager.updateProducts(from: products)
        }
        .sheet(isPresented: $showingCart) {
            CartView()
        }
    }
}

struct ProductCard: View {
    let product: ProductRecommendation
    @StateObject private var productManager = ProductManager.shared
    @State private var isAdded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Product Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text(product.category)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.farmColors.primary.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(product.price)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.primary)
                    
                    Text("Est. Price")
                        .font(.caption2)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
            }
            
            // Recommendation
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.primary)
                    
                    Text("Why this product?")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.farmColors.textPrimary)
                }
                
                Text(product.recommendation)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 8)
            
            // Instructions
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.primary)
                    
                    Text("Usage Instructions")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.farmColors.textPrimary)
                }
                
                Text(product.instructions)
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 8)
            
            // Add to Cart Button
            HStack {
                Spacer()
                
                Button(action: {
                    let productToAdd = Product.from(product)
                    productManager.addToCart(productToAdd)
                    
                    // Visual feedback
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isAdded = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isAdded = false
                        }
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            LinearGradient(
                                colors: [Color.farmColors.primary, Color.farmColors.successGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .shadow(color: Color.farmColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                }
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 0.1), value: false)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    let sampleProducts = [
        ProductRecommendation(
            name: "Organic Neem Oil Spray",
            category: "Pesticide",
            price: 45,
            recommendation: "Excellent for preventing aphids and whiteflies in current humid conditions. Safe for beneficial insects.",
            instructions: "Dilute 2 tablespoons per gallon of water. Apply in early morning or evening. Reapply every 7-14 days."
        ),
        ProductRecommendation(
            name: "Balanced NPK Fertilizer 10-10-10",
            category: "Fertilizer",
            price: 32,
            recommendation: "Perfect for crop management stage. Provides balanced nutrition for healthy growth.",
            instructions: "Apply 1-2 pounds per 100 square feet. Water immediately after application. Best applied before rain."
        ),
        ProductRecommendation(
            name: "Soil pH Test Kit",
            category: "Equipment",
            price: 18,
            recommendation: "Monitor soil pH levels to optimize nutrient uptake. Current pH of 6.8 is good but should be monitored.",
            instructions: "Collect soil samples from 3-4 locations. Mix with testing solution and compare to color chart."
        )
    ]
    
    SuggestedProductsView(products: sampleProducts)
}
