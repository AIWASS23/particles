//
//  ContentView.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

//import SwiftUI
//import RealityKit
//import RealityKitContent
//
//struct ContentView: View {
//    
//    @State private var soundOn = true
//    @State private var brightnessOn = true
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("ARParticlesShowcase").font(.largeTitle).bold()
//            Toggle("Enable Sound Triggers", isOn: $soundOn)
//            Toggle("Enable Vision Triggers", isOn: $brightnessOn)
//            ZStack {
//                Rectangle().fill(LinearGradient(colors: [.black, .gray], startPoint: .top, endPoint: .bottom)).ignoresSafeArea()
//                Particle2DView()
//                    .scope(Set([soundOn ? "sound" : nil, brightnessOn ? "vision" : nil].compactMap { $0 }))
//                    .designSystem(.default)
//                    .particles {
//                        var particles: [ParticleConfig] = []
//
//                        var rain = ParticleBuilder(name: "Rain", runtime: RainParticle())
//                        rain = rain.style(.rain)
//                            .spawnRate(120)
//                            .lifetime(2.0...3.0)
//                            .opacity(0.6)
//                            .trigger(LabelTrigger(source: "sound", label: "rain", minConfidence: 0.8))
//                        particles.append(rain.config)
//
//                        var sparkle = ParticleBuilder(name: "Sparkle", runtime: SparkleParticle())
//                        sparkle = sparkle.style(.sparkle)
//                            .spawnRate(100)
//                            .lifetime(0.4...0.8)
//                            .trigger(LabelTrigger(source: "vision", label: "bright", minConfidence: 0.7))
//                        particles.append(sparkle.config)
//                        
//                        var glow = ParticleBuilder(name: "glow", runtime: GlowParticle())
//                        glow = glow.style(.glow)
//                            .spawnRate(100)
//                            .lifetime(0.4...0.8)
//                            .trigger(LabelTrigger(source: "sound", label: "bright", minConfidence: 0.7))
//                        particles.append(glow.config)
//                        
//                        var dust = ParticleBuilder(name: "dust", runtime: DustParticle())
//                        dust = dust.style(.dust)
//                            .spawnRate(100)
//                            .lifetime(0.4...0.8)
//                            .trigger(LabelTrigger(source: "sound", label: "bright", minConfidence: 0.7))
//                        particles.append(dust.config)
//                        
//                        var fire = ParticleBuilder(name: "fire", runtime: FireParticle())
//                        fire = fire
//                            .style(.fire)
//                            .spawnRate(80)
//                            .lifetime(0.5...1.2)
//                            .trigger(LabelTrigger(source: "sound", label: "explosion", minConfidence: 0.6))
//                        particles.append(fire.config)
//
//                        var smoke = ParticleBuilder(name: "smoke", runtime: SmokeParticle())
//                        smoke = smoke
//                            .style(.smoke)
//                            .spawnRate(50)
//                            .lifetime(1.5...2.5)
//                            .trigger(LabelTrigger(source: "sound", label: "explosion", minConfidence: 0.6))
//                        particles.append(smoke.config)
//
//
//                        return particles
//                    }
//
//            }
//            .frame(height: 420)
//            .clipShape(RoundedRectangle(cornerRadius: 24))
//            .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.2)))
//            .padding()
//            
//            HStack {
//                Button("Start") { ARParticles.current.controller.start() }
//                Button("Stop") { ARParticles.current.controller.stop() }
//            }
//        }
//        .padding()
//    }
//    
//}
//
//


import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @State private var soundOn = true
    @State private var brightnessOn = true
    
    #if os(visionOS)
    @State private var selectedEnvironment: ParticleEnvironmentMode = .windowed
    #endif
    
    var body: some View {
        VStack(spacing: 16) {
            Text("ARParticlesShowcase").font(.largeTitle).bold()
            
            Toggle("Enable Sound Triggers", isOn: $soundOn)
            Toggle("Enable Vision Triggers", isOn: $brightnessOn)
            
            #if os(visionOS)
            Picker("Environment", selection: $selectedEnvironment) {
                ForEach(ParticleEnvironmentMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            #endif
            
            ZStack {
                Rectangle()
                    .fill(LinearGradient(colors: [.black, .gray], startPoint: .top, endPoint: .bottom))
                    .ignoresSafeArea()
                
                // Exibe a View correspondente ao ambiente
                Group {
                    #if os(visionOS)
                    switch selectedEnvironment {
                    case .twoD:
                        Particle2DView()
                            .scope(Set([soundOn ? "sound" : nil, brightnessOn ? "vision" : nil].compactMap { $0 }))
                            .designSystem(.default)
                            .particles { createParticles() }
                    default:
                        ImmersiveEnvironmentView(mode: selectedEnvironment)
                    }
                    #else
                    Particle2DView()
                        .scope(Set([soundOn ? "sound" : nil, brightnessOn ? "vision" : nil].compactMap { $0 }))
                        .designSystem(.default)
                        .particles { createParticles() }
                    #endif
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
    
    // Função que retorna todas as configurações de partículas
    private func createParticles() -> [ParticleConfig] {
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
        
        var glow = ParticleBuilder(name: "glow", runtime: GlowParticle())
        glow = glow.style(.glow)
            .spawnRate(100)
            .lifetime(0.4...0.8)
            .trigger(LabelTrigger(source: "sound", label: "bright", minConfidence: 0.7))
        particles.append(glow.config)
        
        var dust = ParticleBuilder(name: "dust", runtime: DustParticle())
        dust = dust.style(.dust)
            .spawnRate(100)
            .lifetime(0.4...0.8)
            .trigger(LabelTrigger(source: "sound", label: "bright", minConfidence: 0.7))
        particles.append(dust.config)
        
        var fire = ParticleBuilder(name: "fire", runtime: FireParticle())
        fire = fire
            .style(.fire)
            .spawnRate(80)
            .lifetime(0.5...1.2)
            .trigger(LabelTrigger(source: "sound", label: "explosion", minConfidence: 0.6))
        particles.append(fire.config)

        var smoke = ParticleBuilder(name: "smoke", runtime: SmokeParticle())
        smoke = smoke
            .style(.smoke)
            .spawnRate(50)
            .lifetime(1.5...2.5)
            .trigger(LabelTrigger(source: "sound", label: "explosion", minConfidence: 0.6))
        particles.append(smoke.config)

        return particles
    }
}
