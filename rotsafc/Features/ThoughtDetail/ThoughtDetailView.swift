import SwiftUI

/// A saved thought shown full size, with ChuckChuck's remark about the day.
struct ThoughtDetailView: View {
    let thought: Thought
    let onEdit: () -> Void
    let onDelete: () -> Void

    @State private var showDeleteAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                note
                remark
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.top, DSSpacing.md)
        }
        .background { RoomBackground(floorHeight: 120) }
        .navigationTitle(Text("Your thought", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbar }
        .alert(
            Text("Delete this thought?", bundle: .module),
            isPresented: $showDeleteAlert
        ) {
            Button(role: .destructive, action: onDelete) {
                Text("Delete", bundle: .module)
            }
            Button(role: .cancel) {} label: {
                Text("Cancel", bundle: .module)
            }
        } message: {
            Text("This can’t be undone.", bundle: .module)
        }
    }

    private var note: some View {
        Text(verbatim: thought.text)
            .font(.body)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(DSSpacing.md)
            .padding(.bottom, MoodStamp.size)
            .frame(minHeight: 224, alignment: .topLeading)
            .stickyNote(thought.color.swatch)
            .overlay(alignment: .bottomTrailing) {
                MoodStamp(mood: thought.mood)
                    .padding(DSSpacing.xs)
            }
            .overlay(alignment: .top) { ClothesPeg().offset(y: -12) }
            .padding(.top, DSSpacing.xs)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(verbatim: thought.text))
            .accessibilityValue(thought.mood.title)
    }

    private var remark: some View {
        HStack(alignment: .bottom, spacing: DSSpacing.lg) {
            ChuckView()
                .frame(width: 96, height: 96)
            SpeechBubble(thought.mood.chickRemark, tailEdge: .leading)
        }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button(action: onEdit) {
                Image(systemName: "pencil")
            }
            .accessibilityLabel(Text("Edit", bundle: .module))

            Button(role: .destructive) { showDeleteAlert = true } label: {
                Image(systemName: "trash")
            }
            .accessibilityLabel(Text("Delete", bundle: .module))
        }
    }
}

#Preview {
    NavigationStack {
        ThoughtDetailView(
            thought: Thought(
                id: UUID(),
                text: "Deadline minggu depan menumpuk, tapi hari ini aku mau tenang dulu.",
                mood: .joy,
                color: .mint,
                day: ThoughtDay(date: .now),
                createdAt: .now
            ),
            onEdit: {},
            onDelete: {}
        )
    }
}
