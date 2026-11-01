import Foundation
import SwiftData

enum ModelAssetType: String, Codable {
    case spline = "spline"
    case usdz = "usdz"
}

@Model
final class CollectibleItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    var acquisitionDate: Date
    var estimatedValue: Double
    var notes: String

    // Storing relative file path or bundle asset name only — NEVER binary blob in SwiftData
    var modelFileName: String
    var assetTypeRaw: String
    var isBundleAsset: Bool

    var assetType: ModelAssetType {
        get { ModelAssetType(rawValue: assetTypeRaw) ?? .spline }
        set { assetTypeRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        name: String,
        category: String,
        acquisitionDate: Date = .now,
        estimatedValue: Double = 0.0,
        notes: String = "",
        modelFileName: String,
        assetType: ModelAssetType = .spline,
        isBundleAsset: Bool = true
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.acquisitionDate = acquisitionDate
        self.estimatedValue = estimatedValue
        self.notes = notes
        self.modelFileName = modelFileName
        self.assetTypeRaw = assetType.rawValue
        self.isBundleAsset = isBundleAsset
    }
}
