//
//  LabelTrigger.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Foundation

struct LabelTrigger: TriggerPredicate {
    let source: String? // nil means any
    let label: String
    let minConfidence: Double
    
    init(
        source: String? = nil,
        label: String,
        minConfidence: Double = 0.0
    ) {
        self.source = source
        self.label = label
        self.minConfidence = minConfidence
    }
    
    func evaluate(_ e: DetectionEvent) -> Bool {
        (source == nil || e.source == source) && e.label == label && e.confidence >= minConfidence
    }
}
