//
//  Rule.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation

struct Rule: Sendable, Hashable {
    var name: String
    var predicate: TriggerPredicate
    var debounce: TimeInterval?
    var action: @Sendable (DetectionEvent) -> Void
    
    init(
        name: String,
        predicate: TriggerPredicate,
        debounce: TimeInterval? = nil,
        action: @escaping @Sendable (DetectionEvent) -> Void
    ) {
        self.name = name
        self.predicate = predicate
        self.debounce = debounce
        self.action = action
    }
    
    static func == (lhs: Rule, rhs: Rule) -> Bool {
        lhs.name == rhs.name &&
        lhs.debounce == rhs.debounce
        // Ignoramos `predicate` e `action` na comparação
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(debounce)
        // Ignoramos `predicate` e `action` no hash
    }
}
