//
//  GlowParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import SwiftUI
import CoreGraphics

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
}

