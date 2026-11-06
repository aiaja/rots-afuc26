//
//  HomeView.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// The main screen: the day's notes, with the chick peeking from behind the thought board.
struct HomeView: View {
    private static let momentDuration: Duration = .seconds(5)

    @Bindable var viewModel: JournalViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.bottom, 20)
            
            // ZStack untuk mengatur posisi board dan bebek yang mengintip beserta pesannya
            ZStack(alignment: .topTrailing) {
                // 1. Gabungan bebek dan SpeechBubble di belakang board
                chickArea
                    .offset(x: -20, y: -24)
                    .zIndex(0)
                
                // 2. ThoughtBoard diturunkan sedikit ke bawah
                ThoughtBoard(viewModel: viewModel) { thought in
                    viewModel.path.append(thought.id)
                }
                .padding(.top, 45)
                .zIndex(1)
            }
            
            Spacer(minLength: 16)
            Button {
                viewModel.editor = .new
            } label: {
                Text("Add a thought", bundle: .module)
            }
            .buttonStyle(.dsPrimary)
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.bottom, DSSpacing.md)
        .background { RoomBackground(floorHeight: 174) }
        .toolbar(.hidden, for: .navigationBar)
        .task(id: viewModel.chuckState) {
            guard viewModel.chuckState != .idle,
                (try? await Task.sleep(for: Self.momentDuration)) != nil
            else { return }
            viewModel.chickMomentDidEnd()
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                greeting
                    .font(.title.bold())
                    .accessibilityAddTraits(.isHeader)
                monthButton
            }
            Spacer()
            if !viewModel.isShowingToday {
                todayButton
            }
        }
    }

    private var greeting: Text {
        switch viewModel.greeting {
        case .morning: Text("Good morning", bundle: .module)
        case .afternoon: Text("Good afternoon", bundle: .module)
        case .evening: Text("Good evening", bundle: .module)
        }
    }

    private var monthButton: some View {
        Button {
            viewModel.isMonthPickerPresented = true
        } label: {
            HStack(spacing: DSSpacing.xxs) {
                Text(
                    viewModel.selectedDay.date(calendar: viewModel.grid.calendar),
                    format: .dateTime.month(.wide).year()
                )
                Image(systemName: "chevron.down")
                    .font(.caption.weight(.semibold))
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(minHeight: 44, alignment: .leading)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .padding(.vertical, -DSSpacing.sm)
        .accessibilityHint(Text("Opens the calendar", bundle: .module))
    }

    private var todayButton: some View {
        Button {
            withAnimation { viewModel.selectToday() }
        } label: {
            Text("Today", bundle: .module)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .padding(.horizontal, DSSpacing.sm)
                .frame(minHeight: 44)
                .background {
                    Capsule()
                        .fill(.white)
                        .shadow(color: DSColor.brandShadow, radius: 9, y: 6)
                }
        }
        .buttonStyle(.plain)
    }

    private var chickArea: some View {
            Button {
                viewModel.tapChick()
            } label: {
                HStack(spacing: 12) {
                    // Bebek ditaruh di sebelah kiri
                    ChuckView(state: viewModel.chuckState)
                        .frame(width: 115, height: 115)
                    
                    // Balon pesan ditaruh di sebelah kanan bebek dengan ekor menghadap ke kiri (menunjuk ke bebek)
//                    if let chickMessage {
//                        SpeechBubble(chickMessage, tailEdge: .leading)
//                    }
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .animation(.spring(duration: 0.45), value: viewModel.chuckState)
            .animation(.spring(duration: 0.45), value: viewModel.invitesFirstThought)
            .accessibilityLabel(chickMessage ?? Text(verbatim: "RotsAfuc4"))
        }
    private var chickMessage: Text? {
        switch viewModel.chuckState {
        case .idle:
            viewModel.invitesFirstThought ? Text("What’s on your mind?", bundle: .module) : nil
        case .greeting: Text("How was your day?", bundle: .module)
        case .reacting: Text("Yum! Thanks for sharing.", bundle: .module)
        }
    }
}
