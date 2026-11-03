//
//  MonthPickerSheet.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// Lets the user jump to any past day.
struct MonthPickerSheet: View {
    let viewModel: JournalViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var month: CalendarGrid.Month
    @State private var moods: [ThoughtDay: Mood] = [:]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    init(viewModel: JournalViewModel) {
        self.viewModel = viewModel
        _month = State(initialValue: viewModel.grid.month(containing: viewModel.selectedDay))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: DSSpacing.xs) {
                monthHeader
                weekdayHeader
                LazyVGrid(columns: columns, spacing: DSSpacing.xxs) {
                    ForEach(Array(cells.enumerated()), id: \.offset) { _, day in
                        if let day {
                            cell(for: day)
                        } else {
                            Color.clear.frame(height: 44)
                        }
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, DSSpacing.md)
            .navigationTitle(Text("Select Date", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label {
                            Text("Close", bundle: .module)
                        } icon: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
        .presentationDetents([.height(440)])
        .presentationDragIndicator(.visible)
        .task(id: month) {
            moods = viewModel.moods(in: cells.compactMap(\.self))
        }
    }

    private var cells: [ThoughtDay?] { viewModel.grid.cells(for: month) }

    private var monthDate: Date {
        ThoughtDay(year: month.year, month: month.month, day: 1).date(calendar: viewModel.grid.calendar)
    }

    private var canGoForward: Bool {
        month != viewModel.grid.month(containing: viewModel.today)
    }

    private var monthHeader: some View {
        HStack {
            Text(monthDate, format: .dateTime.month(.wide).year())
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            monthButton(
                systemImage: "chevron.left",
                label: Text("Previous month", bundle: .module),
                offset: -1
            )
            monthButton(
                systemImage: "chevron.right",
                label: Text("Next month", bundle: .module),
                offset: 1
            )
            .disabled(!canGoForward)
        }
    }

    private func monthButton(systemImage: String, label: Text, offset: Int) -> some View {
        Button {
            month = viewModel.grid.month(month, shiftedBy: offset)
        } label: {
            Image(systemName: systemImage)
                .font(.headline)
                .frame(width: 44, height: 44)
        }
        .tint(DSColor.brand)
        .accessibilityLabel(label)
    }

    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.grid.weekdaySymbols, id: \.self) { symbol in
                Text(verbatim: symbol)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .accessibilityHidden(true)
    }

    private func cell(for day: ThoughtDay) -> some View {
        DayCell(
            day: day,
            date: day.date(calendar: viewModel.grid.calendar),
            isSelected: day == viewModel.selectedDay,
            mood: moods[day],
            isEnabled: viewModel.canSelect(day)
        ) {
            viewModel.select(day)
            dismiss()
        }
    }
}
