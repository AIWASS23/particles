//
//  TriggerPredicate.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation

protocol TriggerPredicate: Sendable {
    func evaluate(_ e: DetectionEvent) -> Bool
}
