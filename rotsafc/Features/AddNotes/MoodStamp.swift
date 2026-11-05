import SwiftUI

/// The chosen mood, pinned to the note's corner.
struct MoodStamp: View {
    static let size: CGFloat = 40

    let mood: Mood

    var body: some View {
        mood.sticker
            .resizable()
            .scaledToFit()
            .frame(width: Self.size, height: Self.size)
    }
}
