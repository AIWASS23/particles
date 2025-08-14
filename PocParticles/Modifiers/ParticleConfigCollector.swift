//
//  ParticleConfigCollector.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import SwiftUI


struct ParticleConfigCollector: ViewModifier {
    
    @State private var configs: [ParticleConfig] = []
    let build: (inout [ParticleConfig]) -> Void
    
    func body(content: Content) -> some View {
        content
            .environment(\.particleConfigSet, configs)
            .task { var tmp: [ParticleConfig] = []; build(&tmp); configs = tmp; tmp.forEach { ARParticles.current.controller.addParticleConfig($0) } }
    }
}
