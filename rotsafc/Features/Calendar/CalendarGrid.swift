//
//  CalendarGrid.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import Foundation

/// Lays out days for the week strip and the month picker.
struct CalendarGrid {
    struct Month: Hashable {
        var year: Int
        var month: Int
    }

    let calendar: Calendar

    /// The seven days of the week containing `day`, starting on the locale's first weekday.
    func week(containing day: ThoughtDay) -> [ThoughtDay] {
        guard let start = calendar.dateInterval(of: .weekOfYear, for: day.date(calendar: calendar))?.start
        else { return [day] }
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: start).map {
                ThoughtDay(date: $0, calendar: calendar)
            }
        }
    }

    func startOfWeek(containing day: ThoughtDay) -> ThoughtDay {
        week(containing: day).first ?? day
    }

    func day(_ day: ThoughtDay, addingDays offset: Int) -> ThoughtDay {
        guard let date = calendar.date(byAdding: .day, value: offset, to: day.date(calendar: calendar))
        else { return day }
        return ThoughtDay(date: date, calendar: calendar)
    }

    func days(from start: ThoughtDay, to end: ThoughtDay) -> Int {
        let startDate = start.date(calendar: calendar)
        let endDate = end.date(calendar: calendar)
        return calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }

    /// The cells of a month grid. `nil` marks a blank before the first of the month.
    func cells(for month: Month) -> [ThoughtDay?] {
        let first = ThoughtDay(year: month.year, month: month.month, day: 1)
        let date = first.date(calendar: calendar)
        let dayCount = calendar.range(of: .day, in: .month, for: date)?.count ?? 0
        let blanks = (calendar.component(.weekday, from: date) - calendar.firstWeekday + 7) % 7
        let days = (1...max(dayCount, 1)).map {
            ThoughtDay(year: month.year, month: month.month, day: $0)
        }
        return Array(repeating: nil, count: blanks) + days
    }

    func month(containing day: ThoughtDay) -> Month {
        Month(year: day.year, month: day.month)
    }

    func month(_ month: Month, shiftedBy offset: Int) -> Month {
        let first = ThoughtDay(year: month.year, month: month.month, day: 1).date(calendar: calendar)
        guard let shifted = calendar.date(byAdding: .month, value: offset, to: first) else {
            return month
        }
        return self.month(containing: ThoughtDay(date: shifted, calendar: calendar))
    }

    /// Short weekday names in display order, such as `SUN`.
    var weekdaySymbols: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let start = calendar.firstWeekday - 1
        return (symbols[start...] + symbols[..<start]).map { $0.uppercased() }
    }
}
