//
//  LifeComponent.swift
//  PocParticles
//
//  Created by Marcelo de Araújo on 26/08/25.
//


import RealityKit

struct LifeComponent: Component {
    var life: Double = 1.0
    var maxLife: Double = 1.0
    var velocity: SIMD3<Float> = .zero
}
