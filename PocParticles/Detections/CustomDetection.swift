//
//  CustomDetection.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation


class CustomDetection: DetectionSource, @unchecked Sendable {
    
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
        task = Task {
            for await ev in stream {
                await EventBus.shared.post(ev)
            }
        }
    }

    func stop() async {
        task?.cancel()
        task = nil
    }
}
