import SwiftUI

struct LineChartView: View {
    let data: [Double]
    let title: String
    let subtitle: String
    let accentColor: Color

    @State private var isAnimating = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.farmColors.textPrimary)
                Text(subtitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(accentColor)
            }

            ZStack {
                LineShape(data: data, isAnimating: isAnimating)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [accentColor.opacity(0.5), .clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                LineShape(data: data, isAnimating: isAnimating)
                    .stroke(accentColor, lineWidth: 3)
                
                DataPointIndicators(data: data)
                    .foregroundColor(accentColor)
            }
            .frame(height: 150)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).delay(0.2)) {
                    isAnimating = true
                }
            }
        }
    }
}

struct LineShape: Shape {
    var data: [Double]
    var isAnimating: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard data.count > 1, let min = data.min(), let max = data.max(), min != max else { return path }

        let stepX = rect.width / CGFloat(data.count - 1)
        let stepY = rect.height / CGFloat(max - min)

        for i in data.indices {
            let x = CGFloat(i) * stepX
            let y = rect.height - (CGFloat(data[i] - min) * stepY)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path.trimmedPath(from: 0, to: isAnimating ? 1 : 0)
    }
}

struct DataPointIndicators: View {
    let data: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(data.indices, id: \.self) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .position(
                        x: (geometry.size.width / CGFloat(data.count - 1)) * CGFloat(index),
                        y: geometry.size.height - (geometry.size.height / CGFloat(data.max()! - data.min()!)) * CGFloat(data[index] - data.min()!)
                    )
            }
        }
    }
}
