//
//  ParticleRuntime.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import SwiftUI
import RealityKit


protocol ParticleRuntime: Sendable {
    var id: String { get }
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState]
    func update(dt: Double, state: inout [ParticleState])
    func draw(in ctx: inout GraphicsContext, state: [ParticleState])
    
    func spawnEntities(config: ParticleConfig) -> [Entity]
    func updateEntities(dt: Double, entities: inout [Entity])
}
