import SwiftData
import Foundation

@MainActor
enum PreviewContainer {
    static let sample: ModelContainer = {
        let container = ModelContainerFactory.createContainer(inMemory: true)
        let context = container.mainContext

        let sample1 = CollectibleItem(
            name: "Isometric Mini Room",
            category: "3D Environments",
            acquisitionDate: .now,
            estimatedValue: 1500.0,
            notes: "Custom isometric mini room designed in Spline 3D.",
            modelFileName: "miniroom",
            assetType: .spline,
            isBundleAsset: true
        )

        let sample2 = CollectibleItem(
            name: "Vintage Chronograph",
            category: "Watches",
            acquisitionDate: .now.addingTimeInterval(-86400 * 14),
            estimatedValue: 4200.0,
            notes: "Mint condition mechanical chronograph.",
            modelFileName: "vintage_watch.usdz",
            assetType: .usdz,
            isBundleAsset: true
        )

        context.insert(sample1)
        context.insert(sample2)

        return container
    }()
}
