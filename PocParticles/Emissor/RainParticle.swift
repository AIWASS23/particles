//
//  RainParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import CoreGraphics
import SwiftUI
import RealityKit

struct RainParticle: ParticleRuntime {
    let id: String = "rain"
    
    init() {}
    
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0) // roughly per frame @ 30fps
        return (0..<count).map { _ in
            let x = CGFloat.random(in: rect.minX...rect.maxX)
            let y = rect.minY - 10
            let speed = Double.random(in: config.speed)
            let angle = Double.random(in: config.angle)
            let vx = CGFloat(cos(angle) * speed)
            let vy = CGFloat(sin(angle) * speed)
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
            var path = Path()
            path.move(to: p.position)
            path.addLine(to: CGPoint(x: p.position.x, y: p.position.y + 8))
            ctx.stroke(path, with: .color(.white.opacity(alpha)), lineWidth: 1)
        }
    }
    
    func spawnEntities(config: ParticleConfig) -> [Entity] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            // cria um "traço" como um cilindro bem fino
            let drop = ModelEntity(
                mesh: .generateCylinder(height: 0.08, radius: 0.003),
                materials: [UnlitMaterial(color: .white.withAlphaComponent(CGFloat(config.opacity)))]
            )
            
            // posição inicial (em X aleatório, altura no topo da caixa)
            let x = Float.random(in: -0.5...0.5)
            let z = Float.random(in: -0.5...0.5)
            drop.position = [x, 0.5, z]
            
            // direção/velocidade (com leve ângulo)
            let angle = Float.random(in: Float(config.angle.lowerBound)...Float(config.angle.upperBound))
            let speed = Float.random(in: Float(config.speed.lowerBound)...Float(config.speed.upperBound))
            let vx = cos(angle) * speed
            let vy = -abs(speed)    // sempre para baixo
            let vz = sin(angle) * speed
            
            var comp = LifeComponent()
            comp.life = Double.random(in: config.lifetime)
            comp.maxLife = comp.life
            comp.velocity = SIMD3(vx, vy, vz)
            drop.components.set(comp)
            
            return drop
        }
    }
    
    func updateEntities(dt: Double, entities: inout [Entity]) {
        for entity in entities {
            guard var comp = entity.components[LifeComponent.self],
                  let model = entity as? ModelEntity else { continue }
            
            // movimento
            entity.position += comp.velocity * Float(dt)
            
            // decrementa vida
            comp.life -= dt
            let alpha = CGFloat(max(0, comp.life / comp.maxLife))
            
            // atualiza transparência
            if var material = model.model?.materials.first as? UnlitMaterial {
                material.color = .init(tint: .white.withAlphaComponent(alpha))
                model.model?.materials = [material]
            }
            
            entity.components.set(comp)
        }
        
        // remove gotas mortas
        entities.removeAll { e in
            if let c = e.components[LifeComponent.self] {
                return c.life <= 0
            }
            return false
        }
    }
}
