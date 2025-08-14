//
//  RealityViewAdaptor.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation
#if os(visionOS)
import SwiftUI

@available(visionOS 1.0, *)
struct RealityViewAdaptor: View {
    
    init() {}
    
    var body: some View {
        // Placeholder: integrate with RealityView / RealityKit and map ParticleRuntime to Entities
        Color.clear
            .overlay(Text("RealityViewAdaptor placeholder").font(.caption))
    }
}
#endif
