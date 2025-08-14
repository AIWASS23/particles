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
        ARParticles.current.controller.registerDetector(SoundDetection())
        ARParticles.current.controller.registerDetector(VisionDetection())
        ARParticles.current.controller.start()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
