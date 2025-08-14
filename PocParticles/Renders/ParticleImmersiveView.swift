//
//  ParticleImmersiveView.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import SwiftUI

struct ParticleImmersiveView: View {
    init() {}
    var body: some View {
        #if os(visionOS)
        RealityViewAdaptor()
        #else
        Particle2DView()
        #endif
    }
}
