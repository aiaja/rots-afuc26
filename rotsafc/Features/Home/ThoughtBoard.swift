//
//  ThoughtBoard.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// The white card holding the week strip and the notes hanging on their lines.
struct ThoughtBoard: View {
    @Bindable var viewModel: JournalViewModel
    let onOpen: (Thought) -> Void

    private static let rowSpacing: CGFloat = 24
    private static let noteHeight: CGFloat = 120
    private static let trackHeight: CGFloat = 284

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WeekStrip(viewModel: viewModel)
                .padding(.top, DSSpacing.xs)

            Divider()
                .padding(.horizontal, DSSpacing.md)
                .padding(.top, DSSpacing.xs)

            Text("Thoughts on my mind", bundle: .module)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
                .padding(.horizontal, DSSpacing.md)
                .padding(.top, DSSpacing.sm)
                .padding(.bottom, DSSpacing.xs)

            track

            if viewModel.pages.count > 1 {
                pageControl
            }
        }
        .padding(.bottom, viewModel.pages.count > 1 ? 0 : DSSpacing.md)
        .background {
            RoundedRectangle(cornerRadius: DSRadius.board, style: .continuous)
                .fill(.white)
                .shadow(color: DSColor.brandShadow, radius: 12, y: 8)
        }
    }

    private var track: some View {
        ZStack(alignment: .top) {
            VStack(spacing: Self.noteHeight + Self.rowSpacing - 10) {
                Clothesline()
                Clothesline()
            }
            .padding(.top, 2)

            if viewModel.thoughts.isEmpty {
                noteGrid {
                    Button {
                        viewModel.editor = .new
                    } label: {
                        EmptyNoteSlot(isToday: viewModel.isShowingToday)
                            .frame(height: Self.noteHeight)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                TabView(selection: $viewModel.boardPage) {
                    ForEach(Array(viewModel.pages.enumerated()), id: \.offset) { index, page in
                        notes(page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .frame(height: Self.trackHeight, alignment: .top)
    }

    private func notes(_ page: [Thought]) -> some View {
        noteGrid {
            ForEach(Array(page.enumerated()), id: \.element.id) { index, thought in
                Button {
                    onOpen(thought)
                } label: {
                    NoteCard(thought: thought, index: index)
                        .frame(height: Self.noteHeight)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func noteGrid<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        let columns = [
            GridItem(.flexible(), spacing: DSSpacing.sm),
            GridItem(.flexible()),
        ]
        return LazyVGrid(columns: columns, spacing: Self.rowSpacing, content: content)
            .padding(.horizontal, DSSpacing.md)
            .padding(.top, DSSpacing.md)
            .frame(maxHeight: .infinity, alignment: .top)
    }

    private var pageControl: some View {
        Button {
            withAnimation { viewModel.showNextBoardPage() }
        } label: {
            HStack(spacing: DSSpacing.xs) {
                ForEach(viewModel.pages.indices, id: \.self) { index in
                    Circle()
                        .fill(index == viewModel.boardPage ? Color.primary : Color(.tertiaryLabel))
                        .frame(width: 7, height: 7)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            Text("Page \(viewModel.boardPage + 1) of \(viewModel.pages.count)", bundle: .module)
        )
        .accessibilityHint(Text("Shows the next page of notes", bundle: .module))
    }
}

/// A small sticky note pinned to the line.
private struct NoteCard: View {
    private static let tilts: [Double] = [-1, 1, 1, -1]

    let thought: Thought
    let index: Int

    var body: some View {
        Text(verbatim: thought.text)
            .font(.subheadline)
            .foregroundStyle(.black)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .stickyNote(thought.color.swatch)
            .overlay(alignment: .bottomTrailing) {
                thought.mood.sticker
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .padding(DSSpacing.xs)
            }
            .overlay(alignment: .top) {
                ClothesPeg().offset(y: -16)
            }
            .rotationEffect(.degrees(Self.tilts[index % Self.tilts.count]))
            .dynamicTypeSize(...DynamicTypeSize.xLarge)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(verbatim: thought.text))
            .accessibilityValue(thought.mood.title)
    }
}

/// A dashed spot on the line, inviting the user to hang a note there.
private struct EmptyNoteSlot: View {
    let isToday: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Image(systemName: "plus")
                .font(.headline)
                .foregroundStyle(DSColor.brand)
                .accessibilityHidden(true)
            title
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding(14)
        .padding(.top, DSSpacing.xxs)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            RoundedRectangle(cornerRadius: DSRadius.note, style: .continuous)
                .fill(DSColor.noteYellow.opacity(0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: DSRadius.note, style: .continuous)
                        .strokeBorder(
                            DSColor.clothesline,
                            style: StrokeStyle(lineWidth: 1.5, dash: [6, 5])
                        )
                }
        }
        .overlay(alignment: .top) {
            ClothesPeg().offset(y: -16)
        }
        .rotationEffect(.degrees(-1))
        .dynamicTypeSize(...DynamicTypeSize.xLarge)
    }

    private var title: Text {
        isToday
            ? Text("Hang your first thought for today", bundle: .module)
            : Text("Add a thought to this day", bundle: .module)
    }
}

