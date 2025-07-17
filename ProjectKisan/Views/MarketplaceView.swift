import SwiftUI

struct MarketplaceView: View {
    @StateObject private var marketplaceManager = MarketplaceManager.shared
    @StateObject private var productManager = ProductManager.shared
    @State private var showingCart = false
    @State private var showingFilters = false
    @State private var selectedProduct: MarketplaceProduct?
    @State private var searchFocused = false
    
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
                    LazyVStack(spacing: 24) {
                        
                        // Search Bar
                        SearchBarView(searchFocused: $searchFocused)
                            .padding(.horizontal, 20)
                        
                        // Category Filter
                        CategoryFilterView()
                        
                        
                        // Products Grid
                        ProductsGridView(selectedProduct: $selectedProduct)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 8)
                }
                .refreshable {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        marketplaceManager.loadProducts()
                    }
                }
            }
            .navigationTitle("Marketplace")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            showingFilters = true
                        }
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            showingCart = true
                        }
                    }) {
                        ZStack {
                            Image(systemName: "bag")
                            if productManager.cartItemsCount > 0 {
                                Text("\(productManager.cartItemsCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(minWidth: 18, minHeight: 18)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                    .offset(x: 12, y: -12)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingCart) {
            CartView()
        }
        .sheet(isPresented: $showingFilters) {
            SortFilterView()
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
        }
        .onAppear {
            productManager.loadCart()
        }
    }
}


// MARK: - Search Bar View
struct SearchBarView: View {
    @StateObject private var marketplaceManager = MarketplaceManager.shared
    @Binding var searchFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundColor(searchFocused ? Color.farmColors.primary : Color.farmColors.textSecondary)
                .animation(.easeInOut(duration: 0.2), value: searchFocused)
            
            TextField("Search products...", text: Binding(
                get: { marketplaceManager.searchText },
                set: { marketplaceManager.updateSearchText($0) }
            ))
            .textFieldStyle(PlainTextFieldStyle())
            .font(.body)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    searchFocused = true
                }
            }
            
            if !marketplaceManager.searchText.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        marketplaceManager.updateSearchText("")
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
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(
                    color: searchFocused ? Color.farmColors.primary.opacity(0.3) : Color.black.opacity(0.1),
                    radius: searchFocused ? 8 : 4,
                    x: 0,
                    y: 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    searchFocused ? Color.farmColors.primary.opacity(0.5) : Color.clear,
                    lineWidth: 2
                )
        )
        .animation(.easeInOut(duration: 0.2), value: searchFocused)
        .onTapGesture {
            searchFocused = false
        }
    }
}

// MARK: - Category Filter View
struct CategoryFilterView: View {
    @StateObject private var marketplaceManager = MarketplaceManager.shared
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All Categories Button
                CategoryButton(
                    title: "All",
                    icon: "grid.circle.fill",
                    isSelected: marketplaceManager.selectedCategory == nil
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        marketplaceManager.selectCategory(nil)
                    }
                }
                
                // Category Buttons
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: marketplaceManager.selectedCategory == category,
                        color: category.color
                    ) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            marketplaceManager.selectCategory(category)
                        }
                    }
                }
                         
                     }
        .padding(.horizontal, 20)
                 }
             }
}

// MARK: - Category Button
struct CategoryButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    init(title: String, icon: String, isSelected: Bool, color: Color = Color.farmColors.primary, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.color = color
        self.action = action
    }
    
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


// MARK: - Products Grid View
struct ProductsGridView: View {
    @StateObject private var marketplaceManager = MarketplaceManager.shared
    @Binding var selectedProduct: MarketplaceProduct?
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Products")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
                
                Text("\(marketplaceManager.filteredProducts.count) items")
                    .font(.subheadline)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
            
            if marketplaceManager.filteredProducts.isEmpty {
                EmptyStateView()
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(marketplaceManager.filteredProducts) { product in
                        MarketplaceProductCard(product: product) {
                            selectedProduct = product
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Marketplace Product Card
struct MarketplaceProductCard: View {
    let product: MarketplaceProduct
    let onTap: () -> Void
    @StateObject private var productManager = ProductManager.shared
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Product Image
                ZStack {
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
                        .frame(height: 120)
                    
                    Image(systemName: product.category.icon)
                        .font(.system(size: 36))
                        .foregroundColor(product.category.color)
                    
                    // Sale Badge
                    if product.isOnSale {
                        VStack {
                            HStack {
                                Spacer()
                                
                                Text("-\(product.discountPercentage!)%")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(Color.red)
                                    .clipShape(Capsule())
                            }
                            .padding(.top, 8)
                            .padding(.trailing, 8)
                            
                            Spacer()
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
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
                        Text("$\(product.price)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.primary)
                        
                        if let originalPrice = product.originalPrice {
                            Text("$\(originalPrice)")
                                .font(.caption)
                                .foregroundColor(Color.farmColors.textSecondary)
                                .strikethrough()
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
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
                .padding(.horizontal, 12)
                
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
                    .cornerRadius(10)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
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
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
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
