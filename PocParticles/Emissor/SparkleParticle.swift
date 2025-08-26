//
//  SparkleParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import CoreGraphics
import SwiftUI
import RealityKit

struct SparkleParticle: ParticleRuntime {
    let id: String = "sparkle"
    
    init() {}
    
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            let pos = CGPoint(x: CGFloat.random(in: rect.minX...rect.maxX), y: CGFloat.random(in: rect.minY...rect.maxY))
            let vx = CGFloat.random(in: -30...30)
            let vy = CGFloat.random(in: -30...30)
            let life = Double.random(in: config.lifetime)
            return ParticleState(position: pos, velocity: .init(dx: vx, dy: vy), life: life, maxLife: life, opacity: config.opacity)
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
            let rect = CGRect(x: p.position.x - 1, y: p.position.y - 1, width: 2, height: 2)
            ctx.fill(Path(ellipseIn: rect), with: .color(.white.opacity(alpha)))
        }
    }
    
    func spawnEntities(config: ParticleConfig) -> [Entity] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            // esfera minúscula
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.01),
                materials: [UnlitMaterial(color: .white)]
            )
            
            // posição inicial em um volume pequeno
            let x = Float.random(in: -0.2...0.2)
            let y = Float.random(in: -0.2...0.2)
            let z = Float.random(in: -0.2...0.2)
            sphere.position = [x, y, z]
            
            // velocidade aleatória
            let vx = Float.random(in: -0.3...0.3)
            let vy = Float.random(in: -0.3...0.3)
            let vz = Float.random(in: -0.3...0.3)
            
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
            
            // vida
            comp.life -= dt
            let lifeRatio = max(0, comp.life / comp.maxLife)
            
            // opacidade fade-out + "flicker" (brilho piscando)
            if var material = model.model?.materials.first as? UnlitMaterial {
                let flicker = CGFloat.random(in: 0.7...1.0)
                material.color = .init(
                    tint: UIColor(
                        white: 1.0,
                        alpha: CGFloat(lifeRatio) * flicker
                    )
                )
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
