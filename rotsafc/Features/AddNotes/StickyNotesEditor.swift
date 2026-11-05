import SwiftUI

struct StickyNoteEditor: View {
    private static let height: CGFloat = 224
    private static let stampClearance = MoodStamp.size + DSSpacing.xs
    
    @Binding var text: String
    let color: Color
    let mood: Mood
    var focus: FocusState<Bool>.Binding

    var body: some View {
        TextEditor(text: $text)
            .focused(focus)
            .scrollContentBackground(.hidden)
            .font(.body)
            .foregroundStyle(.black)
            .padding(.bottom, Self.stampClearance)
            .padding(DSSpacing.sm)
            .frame(height: Self.height)
            .stickyNote(color)
            .overlay(alignment: .topLeading) { placeholder }
            .overlay(alignment: .bottomTrailing) {
                MoodStamp(mood: mood)
                    .padding(DSSpacing.xs)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
            .overlay(alignment: .top) { ClothesPeg().offset(y: -12) }
            .animation(.easeInOut(duration: 0.2), value: color)
            .padding(.top, DSSpacing.xs)
            .accessibilityLabel(Text("Thought note", bundle: .module))
    }

    @ViewBuilder
    private var placeholder: some View {
        if text.isEmpty {
            Text("Share your thoughts", bundle: .module)
                .foregroundStyle(.black.opacity(0.45))
                .padding(.top, DSSpacing.sm + 8)
                .padding(.leading, DSSpacing.sm + 5)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        }
    }
}
