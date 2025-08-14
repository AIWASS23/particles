//
//  ParticlesController.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation

class ParticlesController: @unchecked Sendable {
    var scope: Set<String> = ["sound", "vision"]
    var budget: ParticleBudget = .init(policy: .unlimited)
    var accessibility: AccessibilityPolicy = .init()

    let rules = RuleEngine()
    var configs: [String: ParticleConfig] = [:] // by name

    init() {}

//    func start() {
//        Task { await rules.start() }
//        Task { await DetectionRegistry.shared.all().forEach { _ = await $0.start() } }
//    }
    
    func start() {
        Task {
            await rules.start()
            for detector in await DetectionRegistry.shared.all() {
                await detector.start()
            }
        }
    }
    
//    func stop() {
//        Task { await rules.stop() }
//        Task { await DetectionRegistry.shared.all().forEach { _ = await $0.stop() } }
//    }
    
    func stop() {
        Task {
            await rules.stop()
            for detector in await DetectionRegistry.shared.all() {
                await detector.stop()
            }
        }
    }

    func registerDetector(_ source: DetectionSource) { Task { await DetectionRegistry.shared.register(source) } }

//    func addParticleConfig(_ config: ParticleConfig) {
//        configs[config.name] = config
//        if let trig = config.trigger {
//            rules.add(.init(name: "spawn_\(config.name)", predicate: trig, debounce: 0.1) { [weak self] _ in
//                // For now, the 2D view continuously spawns; triggers can raise spawn rate later.
//                // Hook for imperative effects if needed.
//                _ = self // keep reference
//            })
//        }
//    }
    
    func addParticleConfig(_ config: ParticleConfig) {
        configs[config.name] = config
        if let trig = config.trigger {
            Task { // garante contexto async
                await rules.add(.init(name: "spawn_\(config.name)",
                                      predicate: trig,
                                      debounce: 0.1) { [weak self] _ in
                    _ = self // hook para efeitos futuros
                })
            }
        }
    }

    func allConfigs() -> [ParticleConfig] { Array(configs.values) }
}
