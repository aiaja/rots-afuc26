import SwiftUI

/// Unified 3D Canvas supporting both Spline 3D and RealityKit USDZ.
struct Universal3DCanvas: View {
    let item: CollectibleItem
    var rotationY: Angle = .zero
    var scaleMultiplier: CGFloat = 1.0

    var body: some View {
        switch item.assetType {
        case .spline:
            SplineCanvas(
                sceneName: item.modelFileName,
                isBundleAsset: item.isBundleAsset
            )
        case .usdz:
            Base3DCanvas(
                fileName: item.modelFileName,
                isBundleAsset: item.isBundleAsset,
                rotationY: rotationY,
                scaleMultiplier: scaleMultiplier
            )
        }
    }
}
