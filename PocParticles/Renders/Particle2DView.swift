//
//  Particle2DView.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


//import SwiftUI
//
//struct Particle2DView: View {
//    @State private var token: UUID? = nil
//    @State private var states: [String: [ParticleState]] = [:] // by config name
//    @Environment(\.particleConfigSet) private var configs
//
//    init() {}
//
//    var body: some View {
//        TimelineView(.animation) { _ in
//            Canvas { ctx, size in
//                let rect = CGRect(origin: .zero, size: size)
//                for cfg in configs {
//                    var arr = states[cfg.name, default: []]
//                    // spawn
//                    arr += cfg.runtime.spawn(config: cfg, in: rect)
//                    // update
//                    cfg.runtime.update(dt: 1.0/60.0, state: &arr)
//                    states[cfg.name] = arr
//                    var c = ctx
//                    cfg.runtime.draw(in: &c, state: arr)
//                }
//            }
//        }
//        .onAppear {
//            Task { @MainActor in
//                token = await Animator.shared.addTick { _ in /* TimelineView drives updates */ }
//            }
//        }
//        .onDisappear { Task { await Animator.shared.removeTick(token ?? UUID()) } }
//    }
//}

import SwiftUI

struct Particle2DView: View {
    @State private var token: UUID? = nil
    @State private var states: [String: [ParticleState]] = [:] // por nome de config
    @Environment(\.particleConfigSet) private var configs

    init() {}

    var body: some View {
        TimelineView(.animation) { _ in
            Canvas { ctx, size in
                let rect = CGRect(origin: .zero, size: size)
                
                // Criar cópia local dos estados
                var newStates: [String: [ParticleState]] = [:]
                
                for cfg in configs {
                    var arr = states[cfg.name, default: []]
                    
                    // Spawn e update local
                    arr += cfg.runtime.spawn(config: cfg, in: rect)
                    cfg.runtime.update(dt: 1.0/60.0, state: &arr)
                    
                    // Desenhar partículas
                    var c = ctx
                    cfg.runtime.draw(in: &c, state: arr)
                    
                    // Guardar resultado na cópia
                    newStates[cfg.name] = arr
                }
                
                // Atualizar @State **fora do ciclo de render**
                DispatchQueue.main.async {
                    self.states = newStates
                }
            }
        }
        .onAppear {
            Task { @MainActor in
                token = await Animator.shared.addTick { _ in
                    // TimelineView já dirige as atualizações
                }
            }
        }
        .onDisappear {
            Task { await Animator.shared.removeTick(token ?? UUID()) }
        }
    }
}

