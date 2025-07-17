import SwiftUI

struct CheckoutView: View {
    @StateObject private var productManager = ProductManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessingOrder = false
    @State private var orderCompleted = false
    @State private var createdOrder: Order?
    
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
                
                if orderCompleted {
                    OrderSuccessView(order: createdOrder!)
                } else {
                    CheckoutContentView(isProcessingOrder: $isProcessingOrder)
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.farmColors.primary)
                    .disabled(isProcessingOrder)
                }
            }
        }
        .onChange(of: isProcessingOrder) { processing in
            if processing {
                // Simulate order processing
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        createdOrder = productManager.checkout()
                        isProcessingOrder = false
                        orderCompleted = true
                    }
                    
                    // Auto dismiss after success
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CheckoutContentView: View {
    @StateObject private var productManager = ProductManager.shared
    @Binding var isProcessingOrder: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Order Summary
                OrderSummarySection()
                
                // Payment Method
                PaymentMethodSection()
                
                // Delivery Information
                DeliveryInfoSection()
                
                // Place Order Button
                PlaceOrderButton(isProcessingOrder: $isProcessingOrder)
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
    }
}

struct OrderSummarySection: View {
    @StateObject private var productManager = ProductManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "cart.fill")
                    .foregroundColor(Color.farmColors.primary)
                
                Text("Order Summary")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
                
                Text("\(productManager.cartItemsCount) items")
                    .font(.caption)
                    .foregroundColor(Color.farmColors.textSecondary)
            }
            
            ForEach(Array(productManager.cartProducts.enumerated()), id: \.element.id) { index, product in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text(product.category)
                            .font(.caption)
                            .foregroundColor(Color.farmColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text("$\(product.price)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.primary)
                }
                .padding(.vertical, 8)
                
                if index < productManager.cartProducts.count - 1 {
                    Divider()
                        .background(Color.farmColors.primary.opacity(0.2))
                }
            }
            
            Divider()
                .background(Color.farmColors.primary.opacity(0.3))
            
            HStack {
                Text("Total")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
                
                Text("$\(productManager.totalCartValue)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.farmColors.primary)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct PaymentMethodSection: View {
    @State private var selectedPaymentMethod = "Credit Card"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundColor(Color.farmColors.primary)
                
                Text("Payment Method")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
            }
            
            VStack(spacing: 12) {
                PaymentOptionRow(
                    icon: "creditcard.fill",
                    title: "Credit Card",
                    subtitle: "**** **** **** 1234",
                    isSelected: selectedPaymentMethod == "Credit Card"
                ) {
                    selectedPaymentMethod = "Credit Card"
                }
                
                PaymentOptionRow(
                    icon: "dollarsign.circle.fill",
                    title: "Cash on Delivery",
                    subtitle: "Pay when you receive",
                    isSelected: selectedPaymentMethod == "Cash on Delivery"
                ) {
                    selectedPaymentMethod = "Cash on Delivery"
                }
                
                PaymentOptionRow(
                    icon: "phone.fill",
                    title: "Digital Wallet",
                    subtitle: "UPI/PhonePe/Paytm",
                    isSelected: selectedPaymentMethod == "Digital Wallet"
                ) {
                    selectedPaymentMethod = "Digital Wallet"
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct PaymentOptionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.farmColors.primary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? Color.farmColors.successGreen : Color.farmColors.textSecondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DeliveryInfoSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "truck.box.fill")
                    .foregroundColor(Color.farmColors.primary)
                
                Text("Delivery Information")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(Color.farmColors.primary)
                        .frame(width: 20)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Delivery Address")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text("Farm Address, Village, District\nState - 123456")
                            .font(.caption)
                            .foregroundColor(Color.farmColors.textSecondary)
                    }
                    
                    Spacer()
                }
                
                Divider()
                    .background(Color.farmColors.primary.opacity(0.2))
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(Color.farmColors.primary)
                        .frame(width: 20)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Estimated Delivery")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text("3-5 business days")
                            .font(.caption)
                            .foregroundColor(Color.farmColors.textSecondary)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct PlaceOrderButton: View {
    @StateObject private var productManager = ProductManager.shared
    @Binding var isProcessingOrder: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                isProcessingOrder = true
            }
        }) {
            HStack {
                if isProcessingOrder {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                    
                    Text("Processing Order...")
                        .font(.headline)
                        .fontWeight(.semibold)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.headline)
                    
                    Text("Place Order • $\(productManager.totalCartValue)")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: isProcessingOrder 
                        ? [Color.farmColors.textSecondary, Color.farmColors.textSecondary]
                        : [Color.farmColors.primary, Color.farmColors.successGreen],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
        .disabled(isProcessingOrder || productManager.cartProducts.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: isProcessingOrder)
    }
}

struct OrderSuccessView: View {
    let order: Order
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Large green checkmark with liquid glass effect - Exact copy from original
            ZStack {
                Circle()
                    .fill(Color(UIColor.systemBackground).opacity(0.8))
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.green)
            }
            
            VStack(spacing: 16) {
                Text("Order Confirmed!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Order #\(order.orderNumber)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.primary)
                
                Text("Your order has been placed successfully.\nYou will receive a confirmation email shortly.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "truck.box.fill")
                        .foregroundColor(.green)
                    Text("Estimated delivery: 3-5 business days")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.green)
                    Text("Tracking details will be sent via email")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
            )
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

#Preview {
    CheckoutView()
}
