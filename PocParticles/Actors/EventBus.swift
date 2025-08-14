//
//  EventBus.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Foundation

actor EventBus {
    static let shared = EventBus()
    private var continuations: [UUID: AsyncStream<DetectionEvent>.Continuation] = [:]

    func stream() -> AsyncStream<DetectionEvent> {
        let key = UUID()
        return AsyncStream { continuation in
            continuations[key] = continuation
            continuation.onTermination = { [weak self] _ in
                Task { await self?.removeContinuation(key) }
            }
        }
    }

    private func removeContinuation(_ key: UUID) { continuations.removeValue(forKey: key) }

    func post(_ event: DetectionEvent) {
        for (_, c) in continuations { c.yield(event) }
    }
}
