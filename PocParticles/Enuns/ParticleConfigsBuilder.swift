//
//  ParticleConfigsBuilder.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


@resultBuilder
enum ParticleConfigsBuilder {
    public static func buildBlock(_ components: [ParticleConfig]...) -> [ParticleConfig] { components.flatMap { $0 } }
}
