//
//  FireParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 20/08/25.
//


import SwiftUI
import CoreGraphics
import RealityKit

struct FireParticle: ParticleRuntime {
    let id: String = "fire"
    
    init() {}
    
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            let pos = CGPoint(x: rect.midX + CGFloat.random(in: -10...10), y: rect.maxY)
            let vx = CGFloat.random(in: -5...5)
            let vy = CGFloat.random(in: -100 ... -50)
            let life = Double.random(in: config.lifetime)
            return ParticleState(position: pos, velocity: .init(dx: vx, dy: vy), life: life, maxLife: life, opacity: 1)
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
            let t = 1 - p.life / p.maxLife
            let color = Color(red: 1, green: 1-t, blue: 0, opacity: max(0, 1 - t))
            let radius = CGFloat(6 * (1 - t))
            ctx.fill(Path(ellipseIn: CGRect(x: p.position.x - radius/2, y: p.position.y - radius/2, width: radius, height: radius)), with: .color(color))
        }
    }
    
    func spawnEntities(config: ParticleConfig) -> [Entity] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            // esfera pequena como base da chama
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.01),
                materials: [SimpleMaterial(color: .yellow, isMetallic: false)]
            )
            
            // nasce perto da origem no "chão"
            let x = Float.random(in: -0.05...0.05)
            let y: Float = 0
            let z = Float.random(in: -0.05...0.05)
            sphere.position = SIMD3(x, y, z)
            
            // vida e velocidade iniciais
            var comp = LifeComponent()
            comp.life = Double.random(in: config.lifetime)
            comp.maxLife = comp.life
            comp.velocity = SIMD3(
                Float.random(in: -0.05...0.05),
                Float.random(in: 0.2...0.5), // sempre sobe
                Float.random(in: -0.05...0.05)
            )
            sphere.components.set(comp)
            
            return sphere
        }
    }
    
    func updateEntities(dt: Double, entities: inout [Entity]) {
        for entity in entities {
            guard var comp = entity.components[LifeComponent.self],
                  let model = entity as? ModelEntity else { continue }
            
            // atualiza posição
            entity.position += comp.velocity * Float(dt)
            
            // decai vida
            comp.life -= dt
            let t = 1 - comp.life / comp.maxLife
            
            // cor dinâmica: amarelo → laranja → vermelho → cinzas
            let color = UIColor(
                red: 1.0,
                green: CGFloat(max(0, 1 - t)),
                blue: 0,
                alpha: CGFloat(max(0, 1 - t))
            )
            
            // escala aumenta conforme sobe
            let scale = Float(0.01 + 0.03 * t)
            entity.scale = SIMD3(repeating: scale)
            
            // aplica cor no material
            if var material = model.model?.materials.first as? SimpleMaterial {
                material.color = .init(tint: color, texture: nil)
                model.model?.materials = [material]
            }
            
            entity.components.set(comp)
        }
        
        // remove entidades mortas
        entities.removeAll { entity in
            if let comp = entity.components[LifeComponent.self] {
                return comp.life <= 0
            }
            return false
        }
    }
}
