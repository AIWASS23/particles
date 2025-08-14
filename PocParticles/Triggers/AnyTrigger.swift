//
//  AnyTrigger.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Foundation


struct AnyTrigger: TriggerPredicate {
    private let f: @Sendable (DetectionEvent) -> Bool
    
    init(
        _ f: @escaping @Sendable (DetectionEvent) -> Bool
    ) {
        self.f = f
    }
    
    func evaluate(_ e: DetectionEvent) -> Bool {
        f(e)
    }
}
