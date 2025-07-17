//
//  SplashScreenView.swift
//  ProjectKisan
//
//  Created by Roo on 7/17/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var leafTraceProgress: CGFloat = 0.0
    @State private var leafOpacity: Double = 0.0
    @State private var leafScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0.0
    @State private var showFillAnimation: Bool = false
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Simple background
                Color.farmColors.backgroundLight
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Main leaf animation
                    ZStack {
                        // Traced leaf outline
                        LeafShape()
                            .trim(from: 0.0, to: leafTraceProgress)
                            .stroke(
                                Color.farmColors.primary,
                                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                            )
                            .frame(width: 100, height: 100)
                            .scaleEffect(leafScale)
                            .opacity(leafOpacity)
                        
                        // Filled leaf after tracing
                        LeafShape()
                            .fill(Color.farmColors.primary.opacity(0.7))
                            .frame(width: 100, height: 100)
                            .scaleEffect(leafScale)
                            .opacity(showFillAnimation ? leafOpacity : 0)
                        
                        // Simple leaf stem
                        LeafStem()
                            .trim(from: 0.0, to: leafTraceProgress)
                            .stroke(
                                Color.farmColors.primary.opacity(0.8),
                                style: StrokeStyle(lineWidth: 2, lineCap: .round)
                            )
                            .frame(width: 100, height: 100)
                            .scaleEffect(leafScale)
                            .opacity(leafOpacity)
                    }
                    
                    // Simple app title
                    VStack(spacing: 8) {
                        Text("Project Kisan")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.farmColors.textPrimary)
                            .opacity(textOpacity)
                        
                        Text("Growing Together")
                            .font(.subheadline)
                            .foregroundColor(Color.farmColors.textSecondary)
                            .opacity(textOpacity)
                    }
                }
            }
            .onAppear {
                startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        // Leaf appears
        withAnimation(.easeOut(duration: 0.5)) {
            leafOpacity = 1.0
            leafScale = 1.0
        }
        
        // Leaf tracing animation
        withAnimation(.easeInOut(duration: 2.0).delay(0.3)) {
            leafTraceProgress = 1.0
        }
        
        // Fill animation after tracing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showFillAnimation = true
            }
        }
        
        // Text appears
        withAnimation(.easeOut(duration: 0.6).delay(1.5)) {
            textOpacity = 1.0
        }
        
        // Transition to main app
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isActive = true
            }
        }
    }
}

// MARK: - Simple Custom Shapes

struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Simple leaf shape
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.9))
        
        // Left side
        path.addCurve(
            to: CGPoint(x: width * 0.2, y: height * 0.5),
            control1: CGPoint(x: width * 0.3, y: height * 0.8),
            control2: CGPoint(x: width * 0.2, y: height * 0.65)
        )
        
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.1),
            control1: CGPoint(x: width * 0.2, y: height * 0.35),
            control2: CGPoint(x: width * 0.35, y: height * 0.1)
        )
        
        // Right side
        path.addCurve(
            to: CGPoint(x: width * 0.8, y: height * 0.5),
            control1: CGPoint(x: width * 0.65, y: height * 0.1),
            control2: CGPoint(x: width * 0.8, y: height * 0.35)
        )
        
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.9),
            control1: CGPoint(x: width * 0.8, y: height * 0.65),
            control2: CGPoint(x: width * 0.7, y: height * 0.8)
        )
        
        return path
    }
}

struct LeafStem: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Main stem
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.9))
        path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.1))
        
        // Simple side veins
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.4))
        path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.5))
        
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.4))
        path.addLine(to: CGPoint(x: width * 0.65, y: height * 0.5))
        
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.6))
        path.addLine(to: CGPoint(x: width * 0.3, y: height * 0.7))
        
        path.move(to: CGPoint(x: width * 0.5, y: height * 0.6))
        path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.7))
        
        return path
    }
}

#Preview {
    SplashScreenView()
}
