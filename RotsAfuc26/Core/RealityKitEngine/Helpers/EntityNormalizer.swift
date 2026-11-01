import RealityKit
import Foundation

enum EntityNormalizer {
    /// Normalizes entity scale so it fits consistently inside a target bounding box (in meters).
    static func normalize(_ entity: Entity, targetSizeInMeters: Float = 0.25) {
        let bounds = entity.visualBounds(relativeTo: nil)
        let maxDimension = max(bounds.extents.x, bounds.extents.y, bounds.extents.z)
        guard maxDimension > 0 else { return }

        let scaleFactor = targetSizeInMeters / maxDimension
        entity.scale = SIMD3<Float>(repeating: scaleFactor)
    }
}
