//
//  SupportFeatureView.swift
//  ProjectKisan
//
//  Created by Utsav Balhara on 7/17/25.
//

import SwiftUI

struct SupportFeatureView: View {
    var body: some View {
        FeatureSlideView(
            systemImageName: "mic.fill",
            title: "Voice-First Support",
            description: "Get help with the app's features or connect to the Kisan helpline using just your voice."
        )
    }
}

#Preview {
    SupportFeatureView()
}