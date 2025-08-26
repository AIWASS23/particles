//
//  AppModel.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 26/08/25.
//


import SwiftUI
import RealityKit

@MainActor
@Observable
class AppModel {
    var mainWindowOpen: Bool = false
    var gardenMixedOpen: Bool = false
    var gardenProgressiveOpen: Bool = false
    var gardenFullOpen: Bool = false
    
    #if os(visionOS)
    // Configuração do estilo de imersão padrão
    var immersiveStyleSelection: ImmersionStyle = .automatic
    #endif

    var immersiveSpaceActive: Bool {
        return gardenMixedOpen || gardenProgressiveOpen || gardenFullOpen
    }
}
