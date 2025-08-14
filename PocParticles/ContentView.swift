//
//  ContentView.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @State private var soundOn = true
    @State private var brightnessOn = true
    
    var body: some View {
        VStack(spacing: 16) {
            Text("ARParticlesShowcase").font(.largeTitle).bold()
            Toggle("Enable Sound Triggers", isOn: $soundOn)
            Toggle("Enable Vision Triggers", isOn: $brightnessOn)
            ZStack {
                Rectangle().fill(LinearGradient(colors: [.black, .gray], startPoint: .top, endPoint: .bottom)).ignoresSafeArea()
                Particle2DView()
                    .scope(Set([soundOn ? "sound" : nil, brightnessOn ? "vision" : nil].compactMap { $0 }))
                    .designSystem(.default)
//                    .particles {
//                        [
//                            ParticleBuilder(name: "Rain", runtime: RainParticle())
//                                .style(.rain)
//                                .spawnRate(120)
//                                .lifetime(2.0...3.0)
//                                .opacity(0.6)
//                                .trigger(LabelTrigger(source: "sound", label: "rain", minConfidence: 0.8))
//                                .config,
//                            
//                            ParticleBuilder(name: "Sparkle", runtime: SparkleParticle())
//                                .style(.sparkle)
//                                .spawnRate(100)
//                                .lifetime(0.4...0.8)
//                                .trigger(LabelTrigger(source: "vision", label: "bright", minConfidence: 0.7))
//                                .config
//                        ]
//                    }
                
//                    .particles {
//                        var rain = ParticleBuilder(name: "Rain", runtime: RainParticle())
//                        rain.style(.rain)
//                            .spawnRate(120)
//                            .lifetime(2.0...3.0)
//                            .opacity(0.6)
//                            .trigger(LabelTrigger(source: "sound", label: "rain", minConfidence: 0.8))
//                        
//                        var sparkle = ParticleBuilder(name: "Sparkle", runtime: SparkleParticle())
//                        sparkle.style(.sparkle)
//                            .spawnRate(100)
//                            .lifetime(0.4...0.8)
//                            .trigger(LabelTrigger(source: "vision", label: "bright", minConfidence: 0.7))
//                        
//                        return [rain.config, sparkle.config]
//                    }
                
                    .particles {
                        var particles: [ParticleConfig] = []

                        var rain = ParticleBuilder(name: "Rain", runtime: RainParticle())
                        rain = rain.style(.rain)
                            .spawnRate(120)
                            .lifetime(2.0...3.0)
                            .opacity(0.6)
                            .trigger(LabelTrigger(source: "sound", label: "rain", minConfidence: 0.8))
                        particles.append(rain.config)

                        var sparkle = ParticleBuilder(name: "Sparkle", runtime: SparkleParticle())
                        sparkle = sparkle.style(.sparkle)
                            .spawnRate(100)
                            .lifetime(0.4...0.8)
                            .trigger(LabelTrigger(source: "vision", label: "bright", minConfidence: 0.7))
                        particles.append(sparkle.config)

                        return particles
                    }

            }
            .frame(height: 420)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.2)))
            .padding()
            
            HStack {
                Button("Start") { ARParticles.current.controller.start() }
                Button("Stop") { ARParticles.current.controller.stop() }
            }
        }
        .padding()
    }
    
}


