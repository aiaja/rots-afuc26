import Foundation

/// How the user felt when writing a thought.
public enum Mood: String, CaseIterable, Identifiable, Sendable {
    case drained
    case down
    case okay
    case good
    case amazing

    public var id: String { rawValue }
}

/// The paper color of a sticky note.
public enum NoteColor: String, CaseIterable, Identifiable, Sendable {
    case yellow
    case peach
    case mint
    case lavender

    public var id: String { rawValue }
}

/// A saved thought.
public struct Thought: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let text: String
    public let mood: Mood
    public let color: NoteColor
    public let day: ThoughtDay
    public let createdAt: Date

    public init(
        id: UUID,
        text: String,
        mood: Mood,
        color: NoteColor,
        day: ThoughtDay,
        createdAt: Date
    ) {
        self.id = id
        self.text = text
        self.mood = mood
        self.color = color
        self.day = day
        self.createdAt = createdAt
    }
}

/// The user-editable part of a thought.
public struct ThoughtDraft: Hashable, Sendable {
    public var text: String
    public var mood: Mood
    public var color: NoteColor

    public init(text: String = "", mood: Mood = .good, color: NoteColor = .yellow) {
        self.text = text
        self.mood = mood
        self.color = color
    }

    public init(_ thought: Thought) {
        self.init(text: thought.text, mood: thought.mood, color: thought.color)
    }

    public var trimmedText: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var canSave: Bool { !trimmedText.isEmpty }
}
