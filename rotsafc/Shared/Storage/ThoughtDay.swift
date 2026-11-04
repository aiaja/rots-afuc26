//
//  ThoughtDay.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import Foundation

/// A calendar day, independent of time zone.
///
/// A thought belongs to the day the user saw when writing it, so it stays on that
/// day even if the device later moves to another time zone.
public struct ThoughtDay: Hashable, Comparable, Sendable {
    public let year: Int
    public let month: Int
    public let day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    public init(date: Date, calendar: Calendar = .current) {
        let parts = calendar.dateComponents([.year, .month, .day], from: date)
        self.init(year: parts.year ?? 1, month: parts.month ?? 1, day: parts.day ?? 1)
    }

    init(key: Int) {
        self.init(year: key / 10_000, month: key / 100 % 100, day: key % 100)
    }

    /// Sortable integer form (`20261029`), used as the stored and indexed value.
    var key: Int { year * 10_000 + month * 100 + day }

    /// Noon on this day, which exists in every time zone even across DST changes.
    public func date(calendar: Calendar = .current) -> Date {
        let parts = DateComponents(year: year, month: month, day: day, hour: 12)
        return calendar.date(from: parts) ?? .distantPast
    }

    public static func < (lhs: ThoughtDay, rhs: ThoughtDay) -> Bool {
        lhs.key < rhs.key
    }
}
