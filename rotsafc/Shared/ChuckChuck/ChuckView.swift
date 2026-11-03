//
//  ChuckView.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// The chick standing on its rug.
///
/// Renders `Chick.usdz` with RealityKit when that file is bundled in this module, and
/// otherwise falls back to the 2D sprite. The sprite is also used for Reduce Motion
/// and whenever the model fails to load, so callers never handle those cases.
public struct ChuckView: View {
    private let state: ChuckState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var modelFailed = false

    public init(state: ChuckState = .idle) {
        self.state = state
    }

    public var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            ZStack(alignment: .bottom) {
                Ellipse()
                    .fill(DSColor.brandTint)
                    .frame(width: side * 0.84, height: side * 0.145)
                    .offset(y: side * 0.03)
                character
                    .frame(width: side, height: side)
                    .overlay {
                        if state == .reacting {
                            hearts(side: side)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .animation(.spring(duration: 0.4), value: state)
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var character: some View {
        if let url = Self.modelURL, !reduceMotion, !modelFailed {
            RealityChuckView(url: url, state: state) { modelFailed = true }
        } else {
            SpriteChuckView(state: state)
        }
    }

    private func hearts(side: CGFloat) -> some View {
        ZStack {
            heart(size: side * 0.13).offset(x: -side * 0.48, y: -side * 0.26)
            heart(size: side * 0.10).offset(x: side * 0.5, y: -side * 0.3)
            heart(size: side * 0.07).offset(x: side * 0.42, y: -side * 0.14)
        }
    }

    private func heart(size: CGFloat) -> some View {
        Image(systemName: "heart.fill")
            .font(.system(size: size))
            .foregroundStyle(DSColor.brand)
    }

    private static let modelURL = Bundle.module.url(forResource: "Chick", withExtension: "usdz")
}

