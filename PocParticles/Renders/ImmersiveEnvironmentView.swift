//
//  RealityViewAdaptor.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//



#if os(visionOS)
import SwiftUI
import RealityKit
import RealityKitContent

@available(visionOS 1.0, *)
struct ImmersiveEnvironmentView: View {
    var mode: ParticleEnvironmentMode
    @Environment(\.particleConfigSet) private var configs
    @Environment(AppModel.self) private var appModel
    @State private var entityGroups: [String: [Entity]] = [:]
    
    var body: some View {
        RealityView { content in
            for (_, group) in entityGroups {
                for entity in group { content.add(entity) }
            }
        } update: { content in
            var newGroups: [String: [Entity]] = [:]
            for cfg in configs {
                var group = entityGroups[cfg.name] ?? []
                group += cfg.runtime.spawnEntities(config: cfg)
                cfg.runtime.updateEntities(dt: 1.0/60.0, entities: &group)
                newGroups[cfg.name] = group
            }
            entityGroups = newGroups
        }
    }
    
    private func bindingForMode(_ mode: ParticleEnvironmentMode) -> Binding<ImmersionStyle> {
        Binding(get: { appModel.immersiveStyleSelection },
                set: { appModel.immersiveStyleSelection = $0 })
    }
    
    private func immersionStyleForMode(_ mode: ParticleEnvironmentMode) -> ImmersionStyle {
        switch mode {
        case .windowed: return .automatic
        case .mixed: return .mixed
        case .full: return .full
        default: return .automatic
        }
    }
}
#endif

