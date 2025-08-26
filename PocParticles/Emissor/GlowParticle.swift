//
//  GlowParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import SwiftUI
import CoreGraphics
import RealityKit

struct GlowParticle: ParticleRuntime {
    let id: String = "glow"
    
    init() {}
    
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            // Spawn no centro do retângulo
            let pos = CGPoint(x: rect.midX, y: rect.midY)
            
            // Velocidade aleatória em ângulo radial
            let angle = CGFloat.random(in: 0..<2*CGFloat.pi)
            let speed = CGFloat.random(in: 20...60)
            let vx = cos(angle) * speed
            let vy = sin(angle) * speed
            
            let life = Double.random(in: config.lifetime)
            let opacity = Double.random(in: 0.5...1.0)
            
            return ParticleState(position: pos, velocity: .init(dx: vx, dy: vy), life: life, maxLife: life, opacity: opacity)
        }
    }
    
    func update(dt: Double, state: inout [ParticleState]) {
        for i in state.indices {
            state[i].position.x += state[i].velocity.dx * dt
            state[i].position.y += state[i].velocity.dy * dt
            state[i].life -= dt
        }
        // Remove partículas mortas
        state.removeAll { $0.life <= 0 }
    }
    
    func draw(in ctx: inout GraphicsContext, state: [ParticleState]) {
        for p in state {
            let baseAlpha = p.opacity * max(0, p.life / p.maxLife)
            let center = p.position
            
            // Desenha 3 camadas de gradiente radial para efeito glow
            for i in 0..<3 {
                let radius = CGFloat(6 + i*4)
                let alpha = baseAlpha * pow(0.6, Double(i))
                
                let gradient = Gradient(stops: [
                    .init(color: Color.blue.opacity(alpha), location: 0),
                    .init(color: Color.blue.opacity(0), location: 1)
                ])
                
                let radial = GraphicsContext.Shading.radialGradient(
                    gradient,
                    center: center,
                    startRadius: 0,
                    endRadius: radius
                )
                
                ctx.fill(Path(ellipseIn: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                )), with: radial)
            }
        }
    }
    
    func spawnEntities(config: ParticleConfig) -> [Entity] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.01),
                materials: [UnlitMaterial(color: .blue.withAlphaComponent(0.8))]
            )
            
            // nasce no centro
            sphere.position = [0, 0, 0]
            
            // define velocidade radial aleatória
            let theta = Float.random(in: 0...(2 * .pi))
            let phi = Float.random(in: 0...(Float.pi)) // espalha em 3D
            let speed = Float.random(in: 0.2...0.6)
            let vx = cos(theta) * sin(phi) * speed
            let vy = cos(phi) * speed
            let vz = sin(theta) * sin(phi) * speed
            
            // adiciona componente de vida
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
            
            // move na direção radial
            entity.position += comp.velocity * Float(dt)
            
            // reduz vida
            comp.life -= dt
            let t = 1 - comp.life / comp.maxLife
            
            // aumenta escala suavemente
            let scale = Float(0.01 + 0.05 * t)
            entity.scale = SIMD3(repeating: scale)
            
            // diminui alpha com o tempo
            let alpha = CGFloat(max(0, 1 - t))
            if var material = model.model?.materials.first as? UnlitMaterial {
                material.color = .init(tint: .blue.withAlphaComponent(alpha))
                model.model?.materials = [material]
            }
            
            entity.components.set(comp)
        }
        
        // remove partículas mortas
        entities.removeAll { entity in
            if let comp = entity.components[LifeComponent.self] {
                return comp.life <= 0
            }
            return false
        }
    }
}

