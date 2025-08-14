//
//  Animator.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation

actor Animator {
    static let shared = Animator()
    var lastTime: TimeInterval = Date().timeIntervalSince1970
    var tickHandlers: [UUID: @Sendable (Double) -> Void] = [:]
    var task: Task<Void, Never>? = nil

    func addTick(_ handler: @escaping @Sendable (Double) -> Void) -> UUID {
        let id = UUID()
        tickHandlers[id] = handler; start()
        return id
    }
    
    func removeTick(_ id: UUID) {
        tickHandlers.removeValue(forKey: id)
    }

    func start() {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 16_666_667) // ~60fps
                let now = Date().timeIntervalSince1970
                let dt = await now - lastTime
                lastTime = now
                for (_, h) in await tickHandlers { h(dt) }
            }
        }
    }
}
