//
//  RealityChuckView.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import Foundation
import OSLog
import RealityKit
import SwiftUI

/// The 3D chick. `Documentation/CHICK_3D.md` describes the asset this view expects.
struct RealityChuckView: View {
    let url: URL
    let state: ChuckState
    let onLoadFailure: @MainActor () -> Void

    @State private var chick: Entity?

    var body: some View {
        RealityView { content in
            content.camera = .virtual
            content.add(Self.makeLight())
            content.add(Self.makeCamera())
        } update: { content in
            guard let chick else { return }
            if chick.parent == nil {
                Self.place(chick)
                content.add(chick)
            }
            Self.play(state, on: chick)
        }
        .task(id: url) {
            do {
                chick = try await Entity(contentsOf: url)
            } catch {
                Self.logger.error("Could not load chick: \(error.localizedDescription)")
                onLoadFailure()
            }
        }
    }

    /// Scales the model to about one unit tall with its feet on the origin.
    private static func place(_ chick: Entity) {
        let bounds = chick.visualBounds(relativeTo: nil)
        let height = max(bounds.extents.y, .leastNonzeroMagnitude)
        let scale = 1 / height
        chick.scale = SIMD3(repeating: scale)
        chick.position = SIMD3(-bounds.center.x, -bounds.min.y, -bounds.center.z) * scale
    }

    private static func play(_ state: ChuckState, on chick: Entity) {
        guard
            let clip = chick.availableAnimations.first(where: { $0.name == state.rawValue })
                ?? chick.availableAnimations.first
        else { return }
        chick.playAnimation(clip.repeat(), transitionDuration: 0.25)
    }

    private static func makeCamera() -> Entity {
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 30
        camera.look(at: SIMD3(0, 0.5, 0), from: SIMD3(0, 0.6, 2.1), relativeTo: nil)
        return camera
    }

    /// Fixed in the world, so highlights stay put while the chick moves.
    private static func makeLight() -> Entity {
        let light = DirectionalLight()
        light.light.intensity = 2_500
        light.look(at: .zero, from: SIMD3(0.6, 1.5, 1.5), relativeTo: nil)
        return light
    }

    private static let logger = Logger(subsystem: "RotsAfuc4", category: "ChickKit")
}
