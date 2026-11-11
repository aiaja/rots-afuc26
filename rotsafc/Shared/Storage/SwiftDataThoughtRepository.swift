//
//  SwiftDataThoughtRepository.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import Foundation
import SwiftData

/// Stores thoughts on the device with SwiftData.
@MainActor
public final class SwiftDataThoughtRepository: ThoughtRepository {
    private let container: ModelContainer

    private var context: ModelContext { container.mainContext }

    public init(inMemory: Bool = false) throws {
        container = try ModelContainer(
            for: Schema(versionedSchema: ThoughtSchemaV1.self),
            migrationPlan: ThoughtMigrationPlan.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: inMemory)
        )
    }

    public func thoughts(on day: ThoughtDay) throws -> [Thought] {
        let key = day.key
        let descriptor = FetchDescriptor<ThoughtRecord>(
            predicate: #Predicate { $0.dayKey == key },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor).map(\.thought)
    }

    public func latestMoods(in range: ClosedRange<ThoughtDay>) throws -> [ThoughtDay: Mood] {
        let lower = range.lowerBound.key
        let upper = range.upperBound.key
        var descriptor = FetchDescriptor<ThoughtRecord>(
            predicate: #Predicate { $0.dayKey >= lower && $0.dayKey <= upper },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        descriptor.propertiesToFetch = [\.dayKey, \.moodRaw]
        return try context.fetch(descriptor).reduce(into: [:]) { moods, record in
            moods[record.thought.day] = record.thought.mood
        }
    }

    @discardableResult
    public func add(_ draft: ThoughtDraft, on day: ThoughtDay, at date: Date) throws -> Thought {
        let record = ThoughtRecord(
            id: UUID(),
            text: draft.trimmedText,
            moodRaw: draft.mood.rawValue,
            colorRaw: draft.color.rawValue,
            dayKey: day.key,
            createdAt: date
        )
        context.insert(record)
        try context.save()
        return record.thought
    }

    @discardableResult
    public func update(id: UUID, with draft: ThoughtDraft) throws -> Thought {
        let record = try record(id: id)
        record.text = draft.trimmedText
        record.moodRaw = draft.mood.rawValue
        record.colorRaw = draft.color.rawValue
        try context.save()
        return record.thought
    }

    public func delete(id: UUID) throws {
        context.delete(try record(id: id))
        try context.save()
    }

    private func record(id: UUID) throws -> ThoughtRecord {
        var descriptor = FetchDescriptor<ThoughtRecord>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        guard let record = try context.fetch(descriptor).first else {
            throw ThoughtRepositoryError.notFound
        }
        return record
    }
}

extension ThoughtRecord {
    fileprivate var thought: Thought {
        Thought(
            id: id,
            text: text,
            mood: Mood(rawValue: moodRaw) ?? .joy,
            color: NoteColor(rawValue: colorRaw) ?? .yellow,
            day: ThoughtDay(key: dayKey),
            createdAt: createdAt
        )
    }
}
