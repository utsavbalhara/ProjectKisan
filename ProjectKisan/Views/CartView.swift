import SwiftUI

struct CartView: View {
    @StateObject private var productManager = ProductManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showingCheckout = false
    
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
                
                if productManager.cartProducts.isEmpty {
                    // Empty Cart State
                    VStack(spacing: 20) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(Color.farmColors.textSecondary)
                        
                        Text("Your cart is empty")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text("Add some products to get started")
                            .font(.body)
                            .foregroundColor(Color.farmColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    // Cart with Products
                    VStack(spacing: 0) {
                        // Cart Items
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(Array(productManager.cartProducts.enumerated()), id: \.element.id) { index, product in
                                    CartProductCard(product: product, index: index)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 16)
                        }
                        
                        // Cart Summary
                        CartSummaryView(showingCheckout: $showingCheckout)
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color.farmColors.primary)
                }
                
                if !productManager.cartProducts.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            productManager.clearCart()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .onAppear {
            productManager.loadCart()
        }
        .sheet(isPresented: $showingCheckout) {
            CheckoutView()
        }
    }
}

struct CartProductCard: View {
    @ObservedObject var product: Product
    @StateObject private var productManager = ProductManager.shared
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("$\(product.price)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.primary)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            productManager.removeFromCart(at: index)
                        }
                    }) {
                        Image(systemName: "trash.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(width: 32, height: 32)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            
            // Product Details (Collapsible)
            DisclosureGroup("Product Details") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recommendation:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text(product.recommendation)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Text("Instructions:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.farmColors.textPrimary)
                        .padding(.top, 4)
                    
                    Text(product.instructions)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
                .padding(.top, 8)
            }
            .font(.caption)
            .foregroundColor(Color.farmColors.primary)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.farmColors.shadow.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CartSummaryView: View {
    @StateObject private var productManager = ProductManager.shared
    @Binding var showingCheckout: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Divider()
                .background(Color.farmColors.primary.opacity(0.3))
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Items: \(productManager.cartItemsCount)")
                        .font(.subheadline)
                        .foregroundColor(Color.farmColors.textSecondary)
                    
                    Text("Total: $\(productManager.totalCartValue)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.primary)
                }
                
                Spacer()
                
                Button(action: {
                    showingCheckout = true
                }) {
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .font(.subheadline)
                        
                        Text("Checkout")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(
                        LinearGradient(
                            colors: [Color.farmColors.primary, Color.farmColors.successGreen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(.ultraThinMaterial)
    }
}

#Preview {
    CartView()
}
