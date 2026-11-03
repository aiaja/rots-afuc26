import SwiftUI

/// The selected week. Swiping moves to the same weekday in the previous or next week.
struct WeekStrip: View {
    let viewModel: JournalViewModel

    private var selectedWeek: Binding<ThoughtDay> {
        Binding(
            get: { viewModel.weekStart },
            set: { viewModel.showWeek(startingOn: $0) }
        )
    }

    var body: some View {
        TabView(selection: selectedWeek) {
            ForEach(viewModel.weeks, id: \.self) { start in
                WeekRow(viewModel: viewModel, start: start)
                    .tag(start)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 64)
        .dynamicTypeSize(...DynamicTypeSize.xLarge)
    }
}

private struct WeekRow: View {
    let viewModel: JournalViewModel
    let start: ThoughtDay

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(viewModel.grid.week(containing: start).enumerated()), id: \.element) { index, day in
                VStack(spacing: DSSpacing.xxs) {
                    Text(verbatim: viewModel.grid.weekdaySymbols[index])
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                    DayCell(
                        day: day,
                        date: day.date(calendar: viewModel.grid.calendar),
                        isSelected: day == viewModel.selectedDay,
                        mood: viewModel.dayMoods[day],
                        isEnabled: viewModel.canSelect(day)
                    ) {
                        viewModel.select(day)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, DSSpacing.xs)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
