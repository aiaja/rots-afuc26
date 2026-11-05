import SwiftUI

struct ChuckChuckPeek: View {
    let isPeeking: Bool
    
    var body: some View {
        ChuckView()
            .frame(width: isPeeking ? 96 : 150, height: isPeeking ? 96 : 150)
            .rotationEffect(.degrees(isPeeking ? 25 : 0))
            .offset(
                x: isPeeking ? -DSSpacing.lg : 0,
                y: isPeeking ? DSSpacing.md : -DSSpacing.lg
            )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: isPeeking ? .bottomLeading : .bottom
            )
            .allowsHitTesting(false)
            .animation(.spring(duration: 0.45), value: isPeeking)
    }
}
