//
//  RuleEngine.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Foundation


actor RuleEngine {
    var rules: [Rule] = []
    var lastFire: [String: Date] = [:]
    var streamTask: Task<Void, Never>? = nil

    func add(_ rule: Rule) {
        rules.append(rule)
    }
    
    func removeAll() {
        rules.removeAll()
        lastFire.removeAll()
    }

    func start() {
        guard streamTask == nil else { return }
        streamTask = Task {
            let stream = await EventBus.shared.stream()
            for await e in stream { await handle(e) }
        }
    }

    func stop() {
        streamTask?.cancel()
        streamTask = nil
    }

    func handle(_ e: DetectionEvent) async {
        for r in rules {
            if r.predicate.evaluate(e) {
                if let d = r.debounce {
                    let last = lastFire[r.name] ?? .distantPast
                    let now = Date()
                    guard now.timeIntervalSince(last) >= d else { continue }
                    lastFire[r.name] = now
                }
                r.action(e)
            }
        }
    }
}
