import SwiftUI

struct ProductDetailView: View {
    let product: MarketplaceProduct
    @StateObject private var productManager = ProductManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    @State private var showingAddedToCart = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    colors: [
                        Color.farmColors.backgroundLight,
                        Color.farmColors.backgroundMedium.opacity(0.1),
                        Color.farmColors.backgroundLight
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Product Image Section
                        ProductImageSection(product: product)
                        
                        // Product Details Section
                        VStack(spacing: 24) {
                            ProductInfoSection(product: product)
                            
                            if !product.features.isEmpty {
                                ProductFeaturesSection(product: product)
                            }
                            
                            QuantityAndCartSection(
                                product: product,
                                quantity: $quantity,
                                showingAddedToCart: $showingAddedToCart
                            )
                            
                            Spacer(minLength: 32)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                    }
                }
                .scrollIndicators(.hidden)
                
                // Header overlay
                VStack {
                    ProductDetailHeader(product: product)
                    Spacer()
                }
                
                // Added to cart notification
                if showingAddedToCart {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            Text("Added to cart!")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.farmColors.successGreen, Color.farmColors.successGreen.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.farmColors.successGreen.opacity(0.3), radius: 12, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showingAddedToCart)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Product Detail Header
struct ProductDetailHeader: View {
    let product: MarketplaceProduct
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    dismiss()
                }
            }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(Color.farmColors.textPrimary)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            
            Spacer()
            
            Button(action: {
                // Add to favorites functionality
            }) {
                Image(systemName: "heart")
                    .font(.title2)
                    .foregroundColor(Color.farmColors.primary)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

// MARK: - Product Image Section
struct ProductImageSection: View {
    let product: MarketplaceProduct
    
    var body: some View {
        ZStack {
            // Main product image
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        colors: [
                            product.category.color.opacity(0.3),
                            product.category.color.opacity(0.1),
                            product.category.color.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 320)
                .overlay(
                    Group {
                        if let imageName = product.imageURL, !imageName.isEmpty {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(40)
                        } else {
                            Image(systemName: product.category.icon)
                                .font(.system(size: 80))
                                .foregroundColor(product.category.color)
                        }
                    }
                )
            
            // Sale badge
            if product.isOnSale {
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("SALE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("-\(product.discountPercentage!)%")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 2)
                    }
                    .padding(.top, 60)
                    .padding(.trailing, 20)
                    
                    Spacer()
                }
            }
            
            // Stock status
            VStack {
                Spacer()
                
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: product.inStock ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(product.inStock ? .green : .red)
                        
                        Text(product.inStock ? "In Stock" : "Out of Stock")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(product.inStock ? .green : .red)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Spacer()
                }
                .padding(.bottom, 20)
                .padding(.leading, 20)
            }
        }
    }
}

// MARK: - Product Info Section
struct ProductInfoSection: View {
    let product: MarketplaceProduct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Product name and brand
            VStack(alignment: .leading, spacing: 12) {
                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                HStack {
                    Text("by \(product.brand)")
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Spacer()
                    
                    // Category badge
                    HStack(spacing: 6) {
                        Image(systemName: product.category.icon)
                            .font(.caption)
                            .foregroundColor(product.category.color)
                        
                        Text(product.category.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(product.category.color)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(product.category.color.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            // Price section
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .bottom, spacing: 12) {
                    Text("₹\(product.price)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.primary)
                    
                    if let originalPrice = product.originalPrice {
                        Text("₹\(originalPrice)")
                            .font(.title2)
                            .foregroundColor(Color.farmColors.textSecondary)
                            .strikethrough()
                    }
                    
                    Spacer()
                    
                    Text(product.unit)
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.farmColors.primary.opacity(0.1))
                        .cornerRadius(12)
                }
                
                // Rating
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                                .font(.subheadline)
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Text(String(format: "%.1f", product.rating))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text("(\(product.reviewCount) reviews)")
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Spacer()
                }
            }
            
            // Description
            VStack(alignment: .leading, spacing: 12) {
                Text("Description")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Text(product.description)
                    .font(.body)
                    .foregroundColor(Color.farmColors.textSecondary)
                    .lineSpacing(4)
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Product Features Section
struct ProductFeaturesSection: View {
    let product: MarketplaceProduct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Features")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.farmColors.textPrimary)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(product.features, id: \.self) { feature in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(Color.farmColors.successGreen)
                            .frame(width: 20, height: 20)
                        
                        Text(feature)
                            .font(.body)
                            .foregroundColor(Color.farmColors.textSecondary)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }
}

// MARK: - Quantity and Cart Section
struct QuantityAndCartSection: View {
    let product: MarketplaceProduct
    @Binding var quantity: Int
    @Binding var showingAddedToCart: Bool
    @StateObject private var productManager = ProductManager.shared
    
    var body: some View {
        VStack(spacing: 24) {
            // Quantity Selector
            VStack(spacing: 16) {
                HStack {
                    Text("Quantity")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        if quantity > 1 {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                quantity -= 1
                            }
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(quantity > 1 ? Color.farmColors.primary : Color.farmColors.textSecondary)
                            .frame(width: 48, height: 48)
                            .background(
                                Circle()
                                    .fill(quantity > 1 ? Color.farmColors.primary.opacity(0.1) : Color.farmColors.textSecondary.opacity(0.1))
                            )
                    }
                    .disabled(quantity <= 1)
                    
                    Text("\(quantity)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.textPrimary)
                        .frame(minWidth: 60)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: quantity)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            quantity += 1
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(Color.farmColors.primary)
                            .frame(width: 48, height: 48)
                            .background(
                                Circle()
                                    .fill(Color.farmColors.primary.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            
            // Price Summary
            VStack(spacing: 16) {
                HStack {
                    Text("Total Price")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Spacer()
                    
                    Text("₹\(product.price * quantity)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.primary)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: quantity)
                }
                
                if quantity > 1 {
                    HStack {
                        Text("Price per unit: ₹\(product.price)")
                            .font(.subheadline)
                            .foregroundColor(Color.farmColors.textSecondary)
                        
                        Spacer()
                    }
                    .transition(.opacity)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            
            // Add to Cart Button
            Button(action: {
                for _ in 0..<quantity {
                    productManager.addToCart(product.toProduct())
                }
                
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showingAddedToCart = true
                }
                
                // Hide the alert after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showingAddedToCart = false
                    }
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "bag.fill")
                        .font(.title2)
                    
                    Text("Add to Cart")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    product.inStock ?
                    LinearGradient(
                        colors: [Color.farmColors.primary, Color.farmColors.successGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        colors: [Color.gray, Color.gray],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(
                    color: product.inStock ? Color.farmColors.primary.opacity(0.3) : Color.clear,
                    radius: product.inStock ? 12 : 0,
                    x: 0,
                    y: 4
                )
            }
            .disabled(!product.inStock)
            .scaleEffect(product.inStock ? 1.0 : 0.95)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: product.inStock)
        }
    }
}

#Preview {
    ProductDetailView(product: MarketplaceProduct.sampleProducts[0])
}
