import SwiftUI

struct CartView: View {
    @StateObject private var productManager = ProductManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingCheckout = false
    
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
                
                if productManager.cartProducts.isEmpty {
                    // Empty Cart State
                    EmptyCartView()
                } else {
                    // Cart with Products
                    VStack(spacing: 0) {
                        // Cart Header
                        CartHeaderView()
                        
                        // Cart Items
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(Array(productManager.cartProducts.enumerated()), id: \.element.id) { index, product in
                                    CartProductCard(product: product, index: index)
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .move(edge: .trailing).combined(with: .opacity)
                                        ))
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 120) // Space for checkout button
                        }
                        
                        Spacer()
                        
                        // Cart Summary (Fixed at bottom)
                        CartSummaryView(showingCheckout: $showingCheckout)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            productManager.loadCart()
        }
        .sheet(isPresented: $showingCheckout) {
            CheckoutView()
        }
    }
}

// MARK: - Cart Header View
struct CartHeaderView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var productManager = ProductManager.shared
    
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
                    .background(Color.farmColors.primary.opacity(0.1))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("My Cart")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Text("\(productManager.cartItemsCount) items")
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
            
            Spacer()
            
            if !productManager.cartProducts.isEmpty {
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        productManager.clearCart()
                    }
                }) {
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundColor(.red)
                        .frame(width: 44, height: 44)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
            } else {
                // Empty space to maintain balance
                Rectangle()
                    .frame(width: 44, height: 44)
                    .opacity(0)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
}

// MARK: - Empty Cart View
struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 20) {
                Image(systemName: "bag")
                    .font(.system(size: 80))
                    .foregroundColor(Color.farmColors.textSecondary.opacity(0.5))
                
                VStack(spacing: 8) {
                    Text("Your cart is empty")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text("Add some products to get started")
                        .font(.body)
                        .foregroundColor(Color.farmColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: {
                // Handle start shopping action
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                    
                    Text("Start Shopping")
                        .font(.headline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(
                    LinearGradient(
                        colors: [Color.farmColors.primary, Color.farmColors.primary.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.farmColors.primary.opacity(0.3), radius: 12, x: 0, y: 4)
            }
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Cart Product Card
struct CartProductCard: View {
    @ObservedObject var product: Product
    @StateObject private var productManager = ProductManager.shared
    let index: Int
    @State private var isRemoving = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                // Product Icon
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.farmColors.primary.opacity(0.3),
                                Color.farmColors.primary.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 32))
                            .foregroundColor(Color.farmColors.primary)
                    )
                
                // Product Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                        .lineLimit(2)
                    
                    Text(product.category)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.farmColors.primary.opacity(0.1))
                        .cornerRadius(8)
                    
                    HStack {
                        Text("$\(product.price)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.primary)
                        
                        Spacer()
                        
                        // Remove Button
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                isRemoving = true
                                productManager.removeFromCart(at: index)
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .scaleEffect(isRemoving ? 0.8 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isRemoving)
                    }
                }
                
                Spacer()
            }
            
            // Product Details (Expandable)
            DisclosureGroup {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recommendation:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text(product.recommendation)
                            .font(.body)
                            .foregroundColor(Color.farmColors.textSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instructions:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text(product.instructions)
                            .font(.body)
                            .foregroundColor(Color.farmColors.textSecondary)
                    }
                }
                .padding(.vertical, 12)
            } label: {
                HStack {
                    Image(systemName: "info.circle")
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.primary)
                    
                    Text("Product Details")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.farmColors.primary)
                    
                    Spacer()
                }
            }
            .accentColor(Color.farmColors.primary)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 4)
        )
        .scaleEffect(isRemoving ? 0.95 : 1.0)
        .opacity(isRemoving ? 0.8 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isRemoving)
    }
}

// MARK: - Cart Summary View
struct CartSummaryView: View {
    @StateObject private var productManager = ProductManager.shared
    @Binding var showingCheckout: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Summary Card
            VStack(spacing: 20) {
                // Order Summary
                VStack(spacing: 12) {
                    HStack {
                        Text("Order Summary")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("Items (\(productManager.cartItemsCount))")
                            .font(.body)
                            .foregroundColor(Color.farmColors.textSecondary)
                        
                        Spacer()
                        
                        Text("$\(productManager.totalCartValue)")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(Color.farmColors.textPrimary)
                    }
                    
                    HStack {
                        Text("Delivery")
                            .font(.body)
                            .foregroundColor(Color.farmColors.textSecondary)
                        
                        Spacer()
                        
                        Text("FREE")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(Color.farmColors.successGreen)
                    }
                    
                    Divider()
                        .background(Color.farmColors.primary.opacity(0.3))
                    
                    HStack {
                        Text("Total")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Spacer()
                        
                        Text("$\(productManager.totalCartValue)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.primary)
                    }
                }
                
                // Checkout Button
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showingCheckout = true
                    }
                }) {
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .font(.title3)
                        
                        Text("Proceed to Checkout")
                            .font(.headline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color.farmColors.primary, Color.farmColors.successGreen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color.farmColors.primary.opacity(0.3), radius: 12, x: 0, y: 4)
                }
                .scaleEffect(showingCheckout ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingCheckout)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: -4)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .background(
            // Blur background
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    CartView()
}
