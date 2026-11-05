//
//  MoodCelebration.swift
//  rotsafc
//
//  Created by Mac on 05/11/26.
//

import SwiftUI

struct MoodCelebration: View {
    private static let size: CGFloat = 160

    let mood: Mood
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if !reduceMotion {
            mood.sticker
                .resizable()
                .scaledToFit()
                .frame(width: Self.size, height: Self.size)
                .keyframeAnimator(initialValue: Pop(), trigger: mood) { content, pop in
                    content
                        .scaleEffect(pop.scale)
                        .opacity(pop.opacity)
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        SpringKeyframe(1.0, duration: 0.35, spring: .bouncy)
                        LinearKeyframe(1.0, duration: 0.4)
                        LinearKeyframe(0.6, duration: 0.25)
                    }
                    KeyframeTrack(\.opacity) {
                        LinearKeyframe(1, duration: 0.15)
                        LinearKeyframe(1, duration: 0.6)
                        LinearKeyframe(0, duration: 0.25)
                    }
                }
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        }
    }

    private struct Pop {
        var scale = 0.2
        var opacity = 0.0
    }
}
