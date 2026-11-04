//
//  SpriteChuckView.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import Foundation
import SwiftUI

/// The 2D chick, animated with SwiftUI until the rigged model is available.
struct SpriteChuckView: View {
    private static let breathDuration = 3.2

    let state: ChuckState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let image = Image("chick", bundle: .module)
            .resizable()
            .scaledToFit()

        if reduceMotion {
            image
        } else {
            // A repeating SwiftUI animation would also drag the sprite along on layout changes.
            TimelineView(.animation(minimumInterval: 1.0 / 30)) { context in
                image.scaleEffect(x: 1, y: 1 + 0.025 * Self.breath(at: context.date), anchor: .bottom)
            }
            .keyframeAnimator(initialValue: 0.0, trigger: state) { content, hop in
                content.offset(y: state == .reacting ? hop : 0)
            } keyframes: { _ in
                KeyframeTrack {
                    SpringKeyframe(-18, duration: 0.22)
                    SpringKeyframe(0, duration: 0.22)
                    SpringKeyframe(-10, duration: 0.18)
                    SpringKeyframe(0, duration: 0.2)
                }
            }
        }
    }

    /// How far through a breath the chick is, from 0 to 1.
    private static func breath(at date: Date) -> Double {
        (sin(date.timeIntervalSinceReferenceDate * 2 * .pi / breathDuration) + 1) / 2
    }
}
