//
//  ThoughtRepository.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import Foundation

public enum ThoughtRepositoryError: Error, Equatable {
    case notFound
}

/// Reads and writes thoughts.
@MainActor
public protocol ThoughtRepository: AnyObject {
    /// The thoughts written on `day`, newest first.
    func thoughts(on day: ThoughtDay) throws -> [Thought]

    /// The mood of the newest thought on each day within `range` that has thoughts.
    func latestMoods(in range: ClosedRange<ThoughtDay>) throws -> [ThoughtDay: Mood]

    @discardableResult
    func add(_ draft: ThoughtDraft, on day: ThoughtDay, at date: Date) throws -> Thought

    @discardableResult
    func update(id: UUID, with draft: ThoughtDraft) throws -> Thought

    func delete(id: UUID) throws
}

