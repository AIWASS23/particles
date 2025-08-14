//
//  Particle2DView.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import SwiftUI

struct Particle2DView: View {
    @State private var token: UUID? = nil
    @State private var states: [String: [ParticleState]] = [:] // by config name
    @Environment(\.particleConfigSet) private var configs

    init() {}

    var body: some View {
        TimelineView(.animation) { _ in
            Canvas { ctx, size in
                let rect = CGRect(origin: .zero, size: size)
                for cfg in configs {
                    var arr = states[cfg.name, default: []]
                    // spawn
                    arr += cfg.runtime.spawn(config: cfg, in: rect)
                    // update
                    cfg.runtime.update(dt: 1.0/60.0, state: &arr)
                    states[cfg.name] = arr
                    var c = ctx
                    cfg.runtime.draw(in: &c, state: arr)
                }
            }
        }
        .onAppear {
            Task { @MainActor in
                token = await Animator.shared.addTick { _ in /* TimelineView drives updates */ }
            }
        }
        .onDisappear { Task { await Animator.shared.removeTick(token ?? UUID()) } }
    }
}
