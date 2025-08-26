//
//  SmokeParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 20/08/25.
//

import SwiftUI
import CoreGraphics
import RealityKit


struct SmokeParticle: ParticleRuntime {
    let id: String = "smoke"
    
    init() {}
    
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            let pos = CGPoint(x: rect.midX + CGFloat.random(in: -10...10), y: rect.maxY)
            let vx = CGFloat.random(in: -20...20)
            let vy = CGFloat.random(in: -60 ... -30)
            let life = Double.random(in: config.lifetime)
            return ParticleState(position: pos, velocity: .init(dx: vx, dy: vy), life: life, maxLife: life, opacity: 0.5)
        }
    }
    
    func update(dt: Double, state: inout [ParticleState]) {
        for i in state.indices {
            state[i].position.x += state[i].velocity.dx * dt
            state[i].position.y += state[i].velocity.dy * dt
            state[i].life -= dt
            state[i].opacity *= 0.99 // fading gradual
        }
        state.removeAll { $0.life <= 0 }
    }
    
    func draw(in ctx: inout GraphicsContext, state: [ParticleState]) {
        for p in state {
            let radius = CGFloat(10 + 10*(1 - p.life / p.maxLife))
            ctx.fill(Path(ellipseIn: CGRect(x: p.position.x - radius/2, y: p.position.y - radius/2, width: radius, height: radius)), with: .color(.gray.opacity(p.opacity)))
        }
    }
    
    func spawnEntities(config: ParticleConfig) -> [Entity] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            // esfera pequena e translúcida
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.05),
                materials: [UnlitMaterial(color: .gray.withAlphaComponent(0.5))]
            )
            
            // posição inicial (próximo ao centro baixo da cena)
            let x = Float.random(in: -0.1...0.1)
            let z = Float.random(in: -0.1...0.1)
            sphere.position = [x, 0, z]
            
            // velocidade aleatória (subindo)
            let vx = Float.random(in: -0.1...0.1)
            let vy = Float.random(in: 0.2...0.5)
            let vz = Float.random(in: -0.1...0.1)
            
            var comp = LifeComponent()
            comp.life = Double.random(in: config.lifetime)
            comp.maxLife = comp.life
            comp.velocity = SIMD3(vx, vy, vz)
            sphere.components.set(comp)
            
            return sphere
        }
    }
    
    func updateEntities(dt: Double, entities: inout [Entity]) {
        for entity in entities {
            guard var comp = entity.components[LifeComponent.self],
                  let model = entity as? ModelEntity else { continue }
            
            // movimento
            entity.position += comp.velocity * Float(dt)
            
            // tempo de vida
            comp.life -= dt
            let lifeRatio = max(0, comp.life / comp.maxLife)
            
            // escala -> fumaça expande
            let scale = Float(0.05 + (1 - lifeRatio) * 0.15)
            entity.scale = [scale, scale, scale]
            
            // opacidade decresce
            if var material = model.model?.materials.first as? UnlitMaterial {
                material.color = .init(tint: .gray.withAlphaComponent(CGFloat(lifeRatio * 0.5)))
                model.model?.materials = [material]
            }
            
            entity.components.set(comp)
        }
        
        // remover partículas mortas
        entities.removeAll { e in
            if let c = e.components[LifeComponent.self] {
                return c.life <= 0
            }
            return false
        }
    }
}
