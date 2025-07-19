import SwiftUI

struct MarketplaceView: View {
    @StateObject private var marketplaceManager = MarketplaceManager.shared
    @StateObject private var productManager = ProductManager.shared
    @State private var showingCart = false
    @State private var selectedProduct: MarketplaceProduct?
    @State private var searchText = ""
    @State private var selectedCategory: ProductCategory? = nil
    
    // Limited to 8 products for better UX
    var limitedProducts: [MarketplaceProduct] {
        return Array(MarketplaceProduct.sampleProducts.prefix(8))
    }
    
    var filteredProducts: [MarketplaceProduct] {
        var products = limitedProducts
        
        if let category = selectedCategory {
            products = products.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            products = products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return products
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Consistent background gradient like other views
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
                    LazyVStack(spacing: 24) {
                        
                        // Search Bar
                        ConsistentSearchBar(text: $searchText)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        // Category Pills
                        ConsistentCategoryView(selectedCategory: $selectedCategory)
                        
                        // Products Section
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("All Products")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.farmColors.textPrimary)
                                
                                Spacer()
                                
                                Text("\(filteredProducts.count) items")
                                    .font(.subheadline)
                                    .foregroundColor(Color.farmColors.textSecondary)
                            }
                            .padding(.horizontal, 20)
                            
                            ConsistentProductGrid(
                                products: filteredProducts,
                                onProductTap: { product in
                                    selectedProduct = product
                                }
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Marketplace")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ConsistentCartButton(
                        cartCount: productManager.cartItemsCount,
                        action: { showingCart = true }
                    )
                }
            }
        }
        .sheet(isPresented: $showingCart) {
            CartView()
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
        }
        .onAppear {
            productManager.loadCart()
        }
    }
}


// MARK: - Consistent Search Bar
struct ConsistentSearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundColor(isEditing ? Color.farmColors.primary : Color.farmColors.textSecondary)
                .animation(.easeInOut(duration: 0.2), value: isEditing)
            
            TextField("Search products...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEditing = true
                    }
                }
            
            if !text.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        text = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isEditing ? Color.farmColors.primary.opacity(0.5) : Color.farmColors.primary.opacity(0.2),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.farmColors.shadow, radius: isEditing ? 8 : 4, x: 0, y: 2)
        .animation(.easeInOut(duration: 0.2), value: isEditing)
        .onTapGesture {
            if isEditing {
                isEditing = false
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

// MARK: - Consistent Category View
struct ConsistentCategoryView: View {
    @Binding var selectedCategory: ProductCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All category
                ConsistentCategoryPill(
                    title: "All",
                    icon: "grid.circle.fill",
                    isSelected: selectedCategory == nil,
                    color: Color.farmColors.primary
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        selectedCategory = nil
                    }
                }
                
                // Individual categories
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    ConsistentCategoryPill(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Consistent Category Pill
struct ConsistentCategoryPill: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : color)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(isSelected ? color : color.opacity(0.1))
                    .shadow(
                        color: isSelected ? color.opacity(0.3) : Color.clear,
                        radius: isSelected ? 8 : 0,
                        x: 0,
                        y: 2
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}


// MARK: - Consistent Product Grid
struct ConsistentProductGrid: View {
    let products: [MarketplaceProduct]
    let onProductTap: (MarketplaceProduct) -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        if products.isEmpty {
            ConsistentEmptyState()
        } else {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(products) { product in
                    ConsistentProductCard(product: product) {
                        onProductTap(product)
                    }
                }
            }
        }
    }
}

// MARK: - Consistent Product Card
struct ConsistentProductCard: View {
    let product: MarketplaceProduct
    let onTap: () -> Void
    @StateObject private var productManager = ProductManager.shared
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            isPressed = true
            onTap()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isPressed = false
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Product Image
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    product.category.color.opacity(0.3),
                                    product.category.color.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .aspectRatio(1, contentMode: .fit) // Make it a square
                    
                    if let imageName = product.imageURL, !imageName.isEmpty {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Image(systemName: product.category.icon)
                            .font(.system(size: 48))
                            .foregroundColor(product.category.color.opacity(0.7))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    // Sale Badge
                    if product.isOnSale {
                        Text("-\(product.discountPercentage!)%")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .clipShape(Capsule())
                            .padding(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(product.brand)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    HStack {
                        Text("₹\(product.price)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.primary)
                        
                        if let originalPrice = product.originalPrice {
                            Text("₹\(originalPrice)")
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                                .strikethrough()
                        }
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                        }
                        
                        Text("(\(product.reviewCount))")
                            .font(.caption2)
                            .foregroundColor(Color.farmColors.textSecondary)
                        
                        Spacer()
                    }
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        productManager.addToCart(product.toProduct())
                    }
                }) {
                    HStack {
                        Image(systemName: "bag.fill")
                            .font(.caption)
                        
                        Text("Add to Cart")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.farmColors.primary)
                    .cornerRadius(12) // Slightly more rounded
                }
            }
            .padding(12) // Add padding to the entire card content
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.farmColors.shadow.opacity(0.5), radius: 8, x: 0, y: 4)
        )
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isPressed)
    }
}

// MARK: - Consistent Empty State
struct ConsistentEmptyState: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 64))
                .foregroundColor(Color.farmColors.textSecondary.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No products found")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Text("Try adjusting your search or filters")
                    .font(.body)
                    .foregroundColor(Color.farmColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(60)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.farmColors.shadow.opacity(0.5), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Consistent Cart Button
struct ConsistentCartButton: View {
    let cartCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image(systemName: "bag")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.farmColors.textPrimary)
                
                if cartCount > 0 {
                    Text("\(cartCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 18, height: 18)
                        .background(Color.red)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.farmColors.backgroundLight, lineWidth: 2)
                        )
                        .offset(x: 12, y: -12)
                }
            }
        }
    }
}

// MARK: - Sort Filter View
struct SortFilterView: View {
    @StateObject private var marketplaceManager = MarketplaceManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Sort by")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    ForEach(MarketplaceManager.SortOption.allCases, id: \.self) { option in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                marketplaceManager.updateSortOption(option)
                            }
                        }) {
                            HStack {
                                Text(option.rawValue)
                                    .font(.body)
                                    .foregroundColor(Color.farmColors.textPrimary)
                                
                                Spacer()
                                
                                if marketplaceManager.sortOption == option {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(Color.farmColors.primary)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(marketplaceManager.sortOption == option ? Color.farmColors.primary.opacity(0.1) : Color.clear)
                            )
                        }
                    }
                }
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Sort & Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(Color.farmColors.primary)
                }
            }
        }
    }
}

#Preview {
    MarketplaceView()
}
