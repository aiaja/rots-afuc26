//
//  JournalRootView.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// The journal flow: home, thought detail, the editor, and the calendar.
public struct JournalRootView: View {
    @State private var viewModel: JournalViewModel
    @Environment(\.scenePhase) private var scenePhase

    /// - Parameter greetsOnAppear: Whether the chick says hello as soon as the screen appears.
    public init(repository: any ThoughtRepository, greetsOnAppear: Bool = false) {
        _viewModel = State(
            initialValue: JournalViewModel(repository: repository, greetsOnAppear: greetsOnAppear)
        )
    }

    public var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack(path: $viewModel.path) {
            HomeView(viewModel: viewModel)
                .navigationDestination(for: UUID.self) { id in
                    if let thought = viewModel.thought(id: id) {
//                        ThoughtDetailView(
//                            thought: thought,
//                            calendar: viewModel.grid.calendar,
//                            onEdit: { viewModel.editor = .edit(thought) },
//                            onDelete: { viewModel.delete(thought) }
//                        )
                    }
                }
        }
        .sheet(item: $viewModel.editor) { editor in
//            ThoughtEditorSheet(title: title(for: editor), draft: draft(for: editor)) { draft in
//                viewModel.save(draft, from: editor)
//            }
        }
        .sheet(isPresented: $viewModel.isMonthPickerPresented) {
            MonthPickerSheet(viewModel: viewModel)
        }
        .alert(
            Text("Something went wrong", bundle: .module),
            isPresented: Binding(
                get: { viewModel.failure != nil },
                set: { if !$0 { viewModel.dismissFailure() } }
            )
        ) {
        } message: {
            if let failure = viewModel.failure {
                Text(failure)
            }
        }
        .sensoryFeedback(.success, trigger: viewModel.chuckState) { _, new in new == .reacting }
        .task { viewModel.reload() }
        .onChange(of: scenePhase) { _, phase in
//            if phase == .active { viewModel.reload() }
        }
    }

    private func title(for editor: JournalViewModel.Editor) -> Text {
        switch editor {
        case .new: Text("New thought", bundle: .module)
        case .edit: Text("Edit thought", bundle: .module)
        }
    }

    private func draft(for editor: JournalViewModel.Editor) -> ThoughtDraft {
        switch editor {
        case .new: ThoughtDraft()
        case .edit(let thought): ThoughtDraft(thought)
        }
    }
}

#Preview {
    if let repository = try? SwiftDataThoughtRepository(inMemory: true) {
        JournalRootView(repository: repository, greetsOnAppear: true)
    }
}
