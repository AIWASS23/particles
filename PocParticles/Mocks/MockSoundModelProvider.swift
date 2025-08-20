//
//  YourSoundModelProvider.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 20/08/25.
//


import Foundation
@preconcurrency import CoreML
#if canImport(SoundAnalysis)
import SoundAnalysis
#endif

final class MockSoundModelProvider: SoundModelProvider {
    
    #if canImport(SoundAnalysis)
    let mlModel: MLModel

    init() {
        do {
            let config = MLModelConfiguration()
            let modelWrapper = try SleepSoundClassification(configuration: config)
            mlModel = modelWrapper.model
        } catch {
            fatalError("Erro ao carregar o modelo Core ML: \(error)")
        }
    }
    #endif
}
