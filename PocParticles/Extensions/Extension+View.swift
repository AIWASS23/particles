//
//  Extension+View.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Foundation
import SwiftUI

extension View {
    /// Configure scope inputs (simple demo: side-effect on controller)
    func scope(_ sources: Set<String>) -> some View {
        self.onAppear { ARParticles.current.controller.scope = sources }
    }
    func designSystem(_ catalog: ParticleCatalog) -> some View { self }

    /// Collect particle configs via a builder
    func particles(@ParticleConfigsBuilder _ builder: @escaping () -> [ParticleConfig]) -> some View {
        modifier(ParticleConfigCollector { arr in arr.append(contentsOf: builder()) })
    }

    /// Convenience single-particle modifier
    func particle(_ name: String, build: @escaping (inout ParticleBuilder) -> Void) -> some View {
        self.particles {
            var b = ParticleBuilder(name: name, runtime: SparkleParticle())
            build(&b)
            return [b.config]
        }
    }
}
