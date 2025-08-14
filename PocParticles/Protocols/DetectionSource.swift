//
//  DetectionSource.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation

protocol DetectionSource: Sendable {
    var id: String { get }
    func start() async
    func stop() async
}
