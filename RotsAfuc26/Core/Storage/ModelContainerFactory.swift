import SwiftData

enum ModelContainerFactory {
    static func createContainer(inMemory: Bool = false) -> ModelContainer {
        let schema = Schema([
            CollectibleItem.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
}
