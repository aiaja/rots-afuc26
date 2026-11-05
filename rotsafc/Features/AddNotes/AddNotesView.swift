import SwiftUI

struct AddNotesView: View {
    let title: Text
    let onSave: (ThoughtDraft) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var draft: ThoughtDraft
    @State private var showDiscardDialog = false
    @FocusState private var isEditing: Bool

    private let original: ThoughtDraft

    init(title: Text, draft: ThoughtDraft, onSave: @escaping (ThoughtDraft) -> Void) {
        self.title = title
        self.onSave = onSave
        self.original = draft
        _draft = State(initialValue: draft)
    }

    private var hasChanges: Bool {
        original.canSave ? draft != original : draft.canSave
    }

    private func cancel() {
        if hasChanges { showDiscardDialog = true } else { dismiss() }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        MoodPicker(selection: $draft.mood)
                        StickyNoteEditor(text: $draft.text, color: draft.color.swatch, mood: draft.mood, focus: $isEditing)
                        NoteColorPicker(selection: $draft.color)
                    }
                    .padding(.horizontal, DSSpacing.md)
                    .padding(.top, DSSpacing.xs)
            }
            .scrollDismissesKeyboard(.interactively)
            .scrollBounceBehavior(.basedOnSize)
            .background { RoomBackground(floorHeight: 120) }
            .overlay { ChuckChuckPeek(isPeeking: isEditing) }
            .overlay { MoodCelebration(mood: draft.mood) }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbar }
            .confirmationDialog(
                Text("Discard this thought?", bundle: .module),
                isPresented: $showDiscardDialog,
                titleVisibility: .visible
            ) {
                Button(role: .destructive) { dismiss() } label: {
                    Text("Discard", bundle: .module)
                }
                Button(role: .cancel) {} label: {
                    Text("Keep editing", bundle: .module)
                }
            }
        }
        .interactiveDismissDisabled(hasChanges)
        .presentationDragIndicator(.visible)
        .task { isEditing = true }
        .sensoryFeedback(.selection, trigger: draft.mood)
        .sensoryFeedback(.selection, trigger: draft.color)
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button(role: .close, action: cancel)
        }
        ToolbarItem(placement: .confirmationAction) {
            Button(role: .confirm) { onSave(draft) }
                .tint(DSColor.brand)
                .disabled(!draft.canSave)
        }
    }
}

#Preview {
    Color.clear.sheet(isPresented: .constant(true)) {
        AddNotesView(title: Text("New thought"), draft: ThoughtDraft()) { _ in }
    }
}
