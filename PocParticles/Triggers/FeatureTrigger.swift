//
//  FeatureTrigger.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Foundation

struct FeatureTrigger: TriggerPredicate {
    let key: String
    let op: Op
    let value: Double
    
    init(_ key: String,
         _ op: Op,
         _ value: Double
    ) {
        self.key = key
        self.op = op
        self.value = value
    }
    
    func evaluate(_ e: DetectionEvent) -> Bool {
        guard let v = e.features[key] else { return false }
        switch op {
        case .greater:
            return v > value
        case .less:
            return v < value
        case .equal:
            return v == value
        }
    }
}
