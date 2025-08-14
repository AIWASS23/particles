//
//  CustomDetection.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation

struct CustomDetection: DetectionSource {
    
    let id: String
    private let producer: @Sendable () async -> AsyncStream<DetectionEvent>
    private var task: Task<Void, Never>? = nil

    init(
        id: String,
        producer: @escaping @Sendable () async -> AsyncStream<DetectionEvent>
    ) {
        self.id = id
        self.producer = producer
    }

    func start() async {
        guard task == nil else { return }
        let stream = await producer()
        let t = Task {
            for await ev in stream { await EventBus.shared.post(ev) }
        }
        task = t
    }

    func stop() async {
        task?.cancel()
    }
}
