//
//  ParticleImmersiveView.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import SwiftUI
import RealityKit

struct ParticleImmersiveView: View {
    var mode: ParticleEnvironmentMode
    
    init(mode: ParticleEnvironmentMode) {
        self.mode = mode
    }
    
    var body: some View {
        switch mode {
        case .twoD:
            Particle2DView()
            
        case .windowed, .mixed, .full:
            #if os(visionOS)
            ImmersiveEnvironmentView(mode: mode)
            #else
            Text("\(mode.rawValue) requires visionOS")
                .foregroundStyle(.secondary)
            #endif
        }
    }
}
