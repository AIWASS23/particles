//
//  DustParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import CoreGraphics
import SwiftUI
import RealityKit

struct DustParticle: ParticleRuntime {
    let id: String = "dust"
    
    init() {}
    
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            let x = CGFloat.random(in: rect.minX...rect.maxX)
            let y = CGFloat.random(in: rect.minY...rect.maxY)
            let vx = CGFloat.random(in: -10...10)
            let vy = CGFloat.random(in: -10...10)
            let life = Double.random(in: config.lifetime)
            return ParticleState(position: CGPoint(x: x, y: y), velocity: .init(dx: vx, dy: vy), life: life, maxLife: life, opacity: config.opacity)
        }
    }
    func update(dt: Double, state: inout [ParticleState]) {
        for i in state.indices {
            state[i].position.x += state[i].velocity.dx * dt
            state[i].position.y += state[i].velocity.dy * dt
            state[i].life -= dt
        }
        state.removeAll { $0.life <= 0 }
    }
    
    func draw(in ctx: inout GraphicsContext, state: [ParticleState]) {
        for p in state {
            let alpha = p.opacity * max(0, p.life / p.maxLife)
            let rect = CGRect(x: p.position.x, y: p.position.y, width: 2, height: 2)
            ctx.fill(Path(ellipseIn: rect), with: .color(.yellow.opacity(alpha)))
        }
    }
    
    // MARK: - 3D (visionOS)
    func spawnEntities(config: ParticleConfig) -> [Entity] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            // Cria uma pequena esfera representando poeira
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.005),
                materials: [SimpleMaterial(color: .yellow.withAlphaComponent(CGFloat(config.opacity)),
                                           isMetallic: false)]
            )
            
            // Posição inicial aleatória perto da origem
            let x = Float.random(in: -0.2...0.2)
            let y = Float.random(in: -0.2...0.2)
            let z = Float.random(in: -0.2...0.2)
            sphere.position = SIMD3(x, y, z)
            
            // Guarda "vida" no componente de entidade
            var comp = LifeComponent()
            comp.life = Double.random(in: config.lifetime)
            comp.maxLife = comp.life
            comp.velocity = SIMD3(
                Float.random(in: -0.05...0.05),
                Float.random(in: -0.05...0.05),
                Float.random(in: -0.05...0.05)
            )
            sphere.components.set(comp)
            
            return sphere
        }
    }
    
    func updateEntities(dt: Double, entities: inout [Entity]) {
        for entity in entities {
            if var comp = entity.components[LifeComponent.self] {
                // Atualiza posição com base na velocidade
                entity.position += comp.velocity * Float(dt)
                
                // Decai a vida
                comp.life -= dt
                
                // Ajusta opacidade proporcional ao tempo de vida
                let alpha = max(0, comp.life / comp.maxLife)
                if var material = (entity as? ModelEntity)?.model?.materials.first as? SimpleMaterial {
                    material.color = .init(tint: .yellow.withAlphaComponent(alpha), texture: nil)
                    (entity as? ModelEntity)?.model?.materials = [material]
                }
                
                entity.components.set(comp)
            }
        }
        
        // Remove os mortos
        entities.removeAll { entity in
            if let comp = entity.components[LifeComponent.self] {
                return comp.life <= 0
            }
            return false
        }
    }
}
