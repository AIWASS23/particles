//
//  DetectionEvent.swift
//  PocParticles
//
//  Created by Marcelo de Araújo on 14/08/25.
//


import Foundation

struct DetectionEvent: Sendable, Hashable {
    let id: UUID
    let dateEvent: Date
    let source: String
    let label: String
    let confidence: Double
    let features: [String: Double]

    init(
        source: String,
        label: String,
        confidence: Double,
        features: [String: Double] = [:],
        dateEvent: Date = .init()
    ) {
        self.id = UUID()
        self.dateEvent = dateEvent
        self.source = source
        self.label = label
        self.confidence = confidence
        self.features = features
    }
}
