//
//  RateLimitedTrigger.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Foundation


struct RateLimitedTrigger: TriggerPredicate {
    let base: TriggerPredicate
    let minimumInterval: TimeInterval
    var lastFire: Date? = nil
    
    init(
        _ base: TriggerPredicate,
        minimumInterval: TimeInterval
    ) {
        self.base = base
        self.minimumInterval = minimumInterval
    }
    
    mutating func evaluateMutable(_ e: DetectionEvent) -> Bool {
        guard base.evaluate(e) else { return false }
        let now = Date()
        if let last = lastFire, now.timeIntervalSince(last) < minimumInterval { return false }
        lastFire = now; return true
    }
    
    func evaluate(_ e: DetectionEvent) -> Bool {
        fatalError("Use evaluateMutable in a var context")
    }
}
