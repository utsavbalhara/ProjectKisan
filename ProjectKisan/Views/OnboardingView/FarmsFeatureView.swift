//
//  FarmsFeatureView.swift
//  ProjectKisan
//
//  Created by Utsav Balhara on 7/17/25.
//

import SwiftUI

struct FarmsFeatureView: View {
    var body: some View {
        FeatureSlideView(
            systemImageName: "chart.bar.xaxis",
            title: "Farms",
            description: "See what's up with your yield and buy products accordingly."
        )
    }
}

#Preview {
    FarmsFeatureView()
}