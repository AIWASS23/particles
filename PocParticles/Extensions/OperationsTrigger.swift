//
//  AndTrigger.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation

struct AndTrigger: TriggerPredicate {
    let a: TriggerPredicate
    let b: TriggerPredicate
    
    func evaluate(_ e: DetectionEvent) -> Bool {
        a.evaluate(e) && b.evaluate(e)
    }
}

struct OrTrigger: TriggerPredicate {
    let a: TriggerPredicate
    let b: TriggerPredicate
    
    func evaluate(_ e: DetectionEvent) -> Bool {
        a.evaluate(e) || b.evaluate(e)
    }
}

struct NotTrigger: TriggerPredicate {
    let t: TriggerPredicate
    func evaluate(_ e: DetectionEvent) -> Bool {
        !t.evaluate(e)
    }
}

extension TriggerPredicate {
    
    func and(_ other: TriggerPredicate) -> TriggerPredicate {
        AndTrigger(a: self, b: other)
    }
    func or(_ other: TriggerPredicate) -> TriggerPredicate {
        OrTrigger(a: self, b: other)
    }
    func not() -> TriggerPredicate {
        NotTrigger(t: self)
    }
}
