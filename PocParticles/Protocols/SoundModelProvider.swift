//
//  SoundModelProvider.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import CoreML


protocol SoundModelProvider: Sendable {
    #if canImport(SoundAnalysis)
    var mlModel: MLModel { get }
    #endif
}
