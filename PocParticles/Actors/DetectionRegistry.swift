//
//  DetectionRegistry.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Foundation


actor DetectionRegistry {
    static let shared = DetectionRegistry()
    private var sources: [String: DetectionSource] = [:]

    func register(_ source: DetectionSource) {
        sources[source.id] = source
    }
    
    func unregister(id: String) {
        sources.removeValue(forKey: id)
    }
    
    func all() -> [DetectionSource] {
        Array(sources.values)
    }
}
