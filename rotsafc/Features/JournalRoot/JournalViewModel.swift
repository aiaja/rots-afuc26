//
//  JournalViewModel.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import Foundation
import OSLog
import Observation

/// State and actions for the whole journal flow: the board, its calendar, and note editing.
@Observable
@MainActor
final class JournalViewModel {
    enum Greeting {
        case morning
        case afternoon
        case evening
    }

    enum Editor: Identifiable {
        case new
        case edit(Thought)

        var id: String {
            switch self {
            case .new: "new"
            case .edit(let thought): thought.id.uuidString
            }
        }
    }

    static let notesPerPage = 4
    static let browsableWeeks = 104

    private(set) var selectedDay: ThoughtDay
    private(set) var thoughts: [Thought] = []
    private(set) var dayMoods: [ThoughtDay: Mood] = [:]
    private(set) var failure: LocalizedStringResource?

    var chuckState: ChuckState
    var path: [UUID] = []
    var editor: Editor?
    var isMonthPickerPresented = false
    var boardPage = 0

    let grid: CalendarGrid

    private let repository: any ThoughtRepository
    private let now: () -> Date
    private let logger = Logger(subsystem: "RotsAfuc4", category: "Journal")

    init(
        repository: any ThoughtRepository,
        greetsOnAppear: Bool = false,
        calendar: Calendar = .autoupdatingCurrent,
        now: @escaping () -> Date = Date.init
    ) {
        self.repository = repository
        self.now = now
        self.grid = CalendarGrid(calendar: calendar)
        self.chuckState = greetsOnAppear ? .greeting : .idle
        self.selectedDay = ThoughtDay(date: now(), calendar: calendar)
    }

    // MARK: - Derived state

    var today: ThoughtDay { ThoughtDay(date: now(), calendar: grid.calendar) }

    var isShowingToday: Bool { selectedDay == today }

    var weekStart: ThoughtDay { grid.startOfWeek(containing: selectedDay) }

    /// The first day of every week the strip can show, oldest first. The list ends at the current
    /// week and reaches back far enough to include the selected day.
    var weeks: [ThoughtDay] {
        let current = grid.startOfWeek(containing: today)
        let weeksBack = grid.days(from: weekStart, to: current) / 7
        let count = max(Self.browsableWeeks, weeksBack + 1)
        return (0..<count).reversed().map { grid.day(current, addingDays: -7 * $0) }
    }

    /// Whether the chick should invite the user to write, because today's board is empty.
    var invitesFirstThought: Bool { isShowingToday && thoughts.isEmpty }

    var greeting: Greeting {
        switch grid.calendar.component(.hour, from: now()) {
        case 5..<12: .morning
        case 12..<18: .afternoon
        default: .evening
        }
    }

    var pages: [[Thought]] {
        stride(from: 0, to: thoughts.count, by: Self.notesPerPage).map { start in
            Array(thoughts[start..<min(start + Self.notesPerPage, thoughts.count)])
        }
    }

    func thought(id: UUID) -> Thought? {
        thoughts.first { $0.id == id }
    }

    func canSelect(_ day: ThoughtDay) -> Bool {
        day <= today
    }

    func moods(in days: [ThoughtDay]) -> [ThoughtDay: Mood] {
        guard let first = days.first, let last = days.last else { return [:] }
        return perform(fallback: [:]) { try repository.latestMoods(in: first...last) }
    }

    // MARK: - Actions

    func reload() {
        perform(fallback: ()) {
            thoughts = try repository.thoughts(on: selectedDay)
        }
        // Includes both neighboring weeks so their marks are ready while swiping.
        dayMoods = moods(in: [
            grid.day(weekStart, addingDays: -7),
            grid.day(weekStart, addingDays: 13),
        ])
        boardPage = min(boardPage, max(pages.count - 1, 0))
    }

    func select(_ day: ThoughtDay) {
        guard canSelect(day) else { return }
        selectedDay = day
        boardPage = 0
        reload()
    }

    func selectToday() {
        select(today)
    }

    /// Moves to the same weekday in another week, stopping at today.
    func showWeek(startingOn start: ThoughtDay) {
        let weekday = grid.days(from: weekStart, to: selectedDay)
        select(min(grid.day(start, addingDays: weekday), today))
    }

    func showNextBoardPage() {
        boardPage = (boardPage + 1) % max(pages.count, 1)
    }

    func save(_ draft: ThoughtDraft, from editor: Editor) {
        perform(fallback: ()) {
            switch editor {
            case .new:
                try repository.add(draft, on: selectedDay, at: now())
                boardPage = 0
                chuckState = .reacting
            case .edit(let thought):
                try repository.update(id: thought.id, with: draft)
            }
            self.editor = nil
        }
        reload()
    }

    func delete(_ thought: Thought) {
        perform(fallback: ()) {
            try repository.delete(id: thought.id)
            path.removeAll()
        }
        reload()
    }

    func dismissFailure() {
        failure = nil
    }

    /// The prototype's tap path: reaction → greeting → idle, and idle back to a greeting.
    func tapChick() {
        chuckState = chuckState == .idle ? .greeting : nextChickState
    }

    func chickMomentDidEnd() {
        chuckState = nextChickState
    }

    private var nextChickState: ChuckState {
        chuckState == .reacting ? .greeting : .idle
    }

    private func perform<Value>(fallback: Value, _ work: () throws -> Value) -> Value {
        do {
            return try work()
        } catch {
            logger.error("Journal storage failed: \(error.localizedDescription)")
            failure = "Your thoughts couldn’t be updated. Please try again."
            return fallback
        }
    }
}
