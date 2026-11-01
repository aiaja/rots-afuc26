import RealityKit
import Foundation

enum Model3DLoader {
    /// Loads a 3D Entity asynchronously from Bundle or local Document directory.
    /// Compatible with iOS 17.0+ as well as iOS 18.0+.
    @MainActor
    static func loadEntity(fileName: String, isBundleAsset: Bool) async throws -> Entity {
        if #available(iOS 18.0, *) {
            if isBundleAsset {
                return try await Entity(named: fileName)
            } else {
                let fileURL = LocalFileStorage.shared.fileURL(for: fileName)
                return try await Entity(contentsOf: fileURL)
            }
        } else {
            // iOS 17 fallback using Entity.load or ModelEntity.loadModelAsync
            if isBundleAsset {
                return try Entity.load(named: fileName)
            } else {
                let fileURL = LocalFileStorage.shared.fileURL(for: fileName)
                return try Entity.load(contentsOf: fileURL)
            }
        }
    }
}
