//
//  VisionModelProvider.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Vision


protocol VisionModelProvider: Sendable {
    #if canImport(Vision)
    var vnModel: VNCoreMLModel { get }
    #endif
}
