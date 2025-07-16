//
//  DiseaseDetectionFeatureView.swift
//  ProjectKisan
//
//  Created by Utsav Balhara on 7/17/25.
//

import SwiftUI

struct DiseaseDetectionFeatureView: View {
    var body: some View {
        FeatureSlideView(
            systemImageName: "camera.viewfinder",
            title: "Disease Detection",
            description: "Scan the leaf of your crop and get instant remedies and solutions."
        )
    }
}

#Preview {
    DiseaseDetectionFeatureView()
}