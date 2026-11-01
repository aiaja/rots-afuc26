import Foundation

/// Manages local filesystem storage for 3D assets (.usdz) outside SwiftData.
final class LocalFileStorage {
    static let shared = LocalFileStorage()
    private let fileManager = FileManager.default

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var modelsDirectory: URL {
        let dir = documentsDirectory.appendingPathComponent("UserModels", isDirectory: true)
        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    private init() {}

    func saveModel(data: Data, originalFileName: String) throws -> String {
        let ext = (originalFileName as NSString).pathExtension
        let safeFileName = "\(UUID().uuidString).\(ext.isEmpty ? "usdz" : ext)"
        let destinationURL = modelsDirectory.appendingPathComponent(safeFileName)
        try data.write(to: destinationURL, options: .atomic)
        return safeFileName
    }

    func fileURL(for modelFileName: String) -> URL {
        modelsDirectory.appendingPathComponent(modelFileName)
    }

    func deleteModel(fileName: String) {
        let target = modelsDirectory.appendingPathComponent(fileName)
        try? fileManager.removeItem(at: target)
    }
}
