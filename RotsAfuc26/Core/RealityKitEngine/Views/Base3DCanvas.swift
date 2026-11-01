import SwiftUI
import RealityKit

/// 3D Canvas supporting RealityKit on iOS 18+ (via RealityView) and iOS 17 (via ARViewRepresentable).
struct Base3DCanvas: View {
    let fileName: String
    let isBundleAsset: Bool
    var rotationY: Angle = .zero
    var scaleMultiplier: CGFloat = 1.0

    @State private var loadedEntity: Entity?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            if #available(iOS 18.0, *) {
                realityViewContent
            } else {
                legacyARViewContent
            }

            if isLoading {
                ProgressView("Loading 3D Model...")
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            } else if let errorMessage {
                VStack(spacing: 8) {
                    Image(systemName: "cube.transparent")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Failed to load model")
                        .font(.headline)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
    }

    // MARK: - iOS 18 Native RealityView
    @available(iOS 18.0, *)
    @ViewBuilder
    private var realityViewContent: some View {
        RealityView { content in
            let rootAnchor = AnchorEntity(world: .zero)
            content.add(rootAnchor)

            Task { @MainActor in
                do {
                    let entity = try await Model3DLoader.loadEntity(
                        fileName: fileName,
                        isBundleAsset: isBundleAsset
                    )
                    EntityNormalizer.normalize(entity)
                    rootAnchor.addChild(entity)
                    self.loadedEntity = entity
                    self.isLoading = false
                } catch {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        } update: { _ in
            if let loadedEntity {
                loadedEntity.transform.rotation = simd_quatf(
                    angle: Float(rotationY.radians),
                    axis: [0, 1, 0]
                )
                let baseScale = loadedEntity.scale
                loadedEntity.transform.scale = baseScale * Float(scaleMultiplier)
            }
        }
    }

    // MARK: - iOS 17 Fallback using ARView
    private var legacyARViewContent: some View {
        LegacyARViewRepresentable(
            fileName: fileName,
            isBundleAsset: isBundleAsset,
            rotationY: rotationY,
            scaleMultiplier: scaleMultiplier,
            onLoaded: { entity in
                self.loadedEntity = entity
                self.isLoading = false
            },
            onError: { error in
                self.errorMessage = error
                self.isLoading = false
            }
        )
    }
}

// MARK: - UIViewRepresentable Fallback for iOS 17
private struct LegacyARViewRepresentable: UIViewRepresentable {
    let fileName: String
    let isBundleAsset: Bool
    let rotationY: Angle
    let scaleMultiplier: CGFloat
    let onLoaded: (Entity) -> Void
    let onError: (String) -> Void

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        let rootAnchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(rootAnchor)

        Task { @MainActor in
            do {
                let entity = try await Model3DLoader.loadEntity(fileName: fileName, isBundleAsset: isBundleAsset)
                EntityNormalizer.normalize(entity)
                rootAnchor.addChild(entity)
                context.coordinator.entity = entity
                onLoaded(entity)
            } catch {
                onError(error.localizedDescription)
            }
        }

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if let entity = context.coordinator.entity {
            entity.transform.rotation = simd_quatf(
                angle: Float(rotationY.radians),
                axis: [0, 1, 0]
            )
            let baseScale = entity.scale
            entity.transform.scale = baseScale * Float(scaleMultiplier)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var entity: Entity?
    }
}
