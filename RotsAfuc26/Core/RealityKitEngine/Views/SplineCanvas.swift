import SwiftUI
#if canImport(SplineRuntime)
import SplineRuntime
#endif

/// Reusable 3D Canvas supporting Spline scenes locally (offline) and fallback.
struct SplineCanvas: View {
    let sceneName: String
    var isBundleAsset: Bool = true
    var remoteURL: URL? = nil

    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            #if canImport(SplineRuntime)
            if let targetURL = resolveSceneURL() {
                SplineView(sceneFileURL: targetURL)
                    .ignoresSafeArea(.all)
            } else {
                errorPlaceholder(message: "Scene file '\(sceneName)' not found in App Bundle.")
            }
            #else
            // Fallback placeholder when SplineRuntime SPM is not yet added in Xcode
            VStack(spacing: 12) {
                Image(systemName: "cube.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.tint)
                Text("Spline 3D Scene: \(sceneName)")
                    .font(.headline)
                Text("Add https://github.com/splinetool/spline-ios via Xcode Swift Package Manager to render live Spline scenes.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.secondarySystemBackground))
            #endif
        }
    }

    private func resolveSceneURL() -> URL? {
        if let remoteURL {
            return remoteURL
        }

        if isBundleAsset {
            // Priority 1: Check .splineswift bundle in main App Bundle (Offline)
            if let bundleURL = Bundle.main.url(forResource: sceneName, withExtension: "splineswift") {
                return bundleURL
            }
            // Priority 2: In case user passed raw filename or custom extension
            let baseName = (sceneName as NSString).deletingPathExtension
            let ext = (sceneName as NSString).pathExtension
            return Bundle.main.url(forResource: baseName, withExtension: ext.isEmpty ? "splineswift" : ext)
        } else {
            // Local file storage (documents directory)
            return LocalFileStorage.shared.fileURL(for: sceneName)
        }
    }

    private func errorPlaceholder(message: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title)
                .foregroundStyle(.orange)
            Text("Asset Offline Missing")
                .font(.headline)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    SplineCanvas(sceneName: "miniroom")
}
