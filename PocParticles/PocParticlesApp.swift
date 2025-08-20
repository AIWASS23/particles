//
//  PocParticlesApp.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import SwiftUI

@main
struct PocParticlesApp: App {
    
    init() {
        
        
        #if canImport(SoundAnalysis)
        // iOS/macOS → inicializa com modelo real
        let soundDetector = SoundDetection(modelProvider: MockSoundModelProvider())
        #else
        // visionOS ou outra plataforma → fallback
        let soundDetector = SoundDetection()
        #endif
        
        ARParticles.current.controller.registerDetector(soundDetector)
        ARParticles.current.controller.registerDetector(VisionDetection())
        ARParticles.current.controller.start()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
