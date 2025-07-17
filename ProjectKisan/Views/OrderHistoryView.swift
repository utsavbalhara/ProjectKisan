import SwiftUI

struct OrderHistoryView: View {
    @StateObject private var productManager = ProductManager.shared
    @Environment(\.dismiss) private var dismiss
    
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
                
                if productManager.orderHistory.isEmpty {
                    // Empty Order History State
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(Color.farmColors.textSecondary)
                        
                        Text("No Orders Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.farmColors.textPrimary)
                        
                        Text("Your order history will appear here after you make your first purchase")
                            .font(.body)
                            .foregroundColor(Color.farmColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    // Order History List
                    ScrollView {
                        VStack(spacing: 16) {
                            // Order Stats
                            OrderStatsCard()
                            
                            // Orders List
                            LazyVStack(spacing: 16) {
                                ForEach(productManager.orderHistory.sorted(by: { $0.orderDate > $1.orderDate })) { order in
                                    OrderCard(order: order)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 16)
                    }
                }
            }
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(Color.farmColors.primary)
                }
            }
        }
        .onAppear {
            productManager.loadOrderHistory()
        }
    }
}

struct OrderStatsCard: View {
    @StateObject private var productManager = ProductManager.shared
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(Color.farmColors.primary)
                
                Text("Order Statistics")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.farmColors.textPrimary)
                
                Spacer()
            }
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("\(productManager.totalOrdersCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.primary)
                    
                    Text("Total Orders")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
                
                Divider()
                    .frame(height: 30)
                    .background(Color.farmColors.primary.opacity(0.3))
                
                VStack(spacing: 4) {
                    Text("$\(productManager.totalOrderValue)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.successGreen)
                    
                    Text("Total Spent")
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.farmColors.primary.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct OrderCard: View {
    let order: Order
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Order Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.orderNumber)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    Text(order.orderDate, style: .date)
                        .font(.caption)
                        .foregroundColor(Color.farmColors.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(order.totalAmount)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.farmColors.primary)
                    
                    OrderStatusBadge(status: order.status)
                }
            }
            
            // Quick Order Info
            HStack {
                Image(systemName: "bag.fill")
                    .foregroundColor(Color.farmColors.primary)
                    .frame(width: 16)
                
                Text("\(order.products.count) items")
                    .font(.subheadline)
                    .foregroundColor(Color.farmColors.textSecondary)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Text(isExpanded ? "Hide Details" : "View Details")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                    }
                    .foregroundColor(Color.farmColors.primary)
                }
            }
            
            // Expandable Order Details
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .background(Color.farmColors.primary.opacity(0.2))
                    
                    Text("Order Items:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.farmColors.textPrimary)
                    
                    ForEach(Array(order.products.enumerated()), id: \.element.id) { index, product in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(product.name)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.farmColors.textPrimary)
                                
                                Text(product.category)
                                    .font(.caption2)
                                    .foregroundColor(Color.farmColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Text("$\(product.price)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.farmColors.primary)
                        }
                        .padding(.vertical, 4)
                        
                        if index < order.products.count - 1 {
                            Divider()
                                .background(Color.farmColors.primary.opacity(0.1))
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
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

struct OrderStatusBadge: View {
    let status: OrderStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color)
            .cornerRadius(8)
    }
}

#Preview {
    OrderHistoryView()
}
