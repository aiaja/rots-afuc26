//
//  ThoughtSchema.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import Foundation
import SwiftData

typealias ThoughtRecord = ThoughtSchemaV1.ThoughtRecord

/// The first shipped schema. Add a new version and a migration stage for any later change.
enum ThoughtSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }
    static var models: [any PersistentModel.Type] { [ThoughtRecord.self] }

    @Model
    final class ThoughtRecord {
        #Index<ThoughtRecord>([\.dayKey])

        @Attribute(.unique) var id: UUID
        var text: String
        var moodRaw: String
        var colorRaw: String
        var dayKey: Int
        var createdAt: Date

        init(
            id: UUID,
            text: String,
            moodRaw: String,
            colorRaw: String,
            dayKey: Int,
            createdAt: Date
        ) {
            self.id = id
            self.text = text
            self.moodRaw = moodRaw
            self.colorRaw = colorRaw
            self.dayKey = dayKey
            self.createdAt = createdAt
        }
    }
}

enum ThoughtMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [ThoughtSchemaV1.self] }
    static var stages: [MigrationStage] { [] }
}
