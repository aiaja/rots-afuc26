import SwiftUI

struct MoodStamp: View {
    static let size: CGFloat = 40

    private static let landingDelay = 0.75

    let mood: Mood
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if reduceMotion {
            sticker
        } else {
            sticker.keyframeAnimator(initialValue: 1.0, trigger: mood) { content, scale in
                content.scaleEffect(scale)
            } keyframes: { _ in
                KeyframeTrack {
                    LinearKeyframe(0.01, duration: 0.01)
                    LinearKeyframe(0.01, duration: Self.landingDelay)
                    SpringKeyframe(1.0, duration: 0.45, spring: .bouncy)
                }
            }
        }
    }

    private var sticker: some View {
        mood.sticker
            .resizable()
            .scaledToFit()
            .frame(width: Self.size, height: Self.size)
    }
}
