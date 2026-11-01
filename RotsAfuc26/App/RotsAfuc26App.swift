import SwiftUI
import SwiftData

@main
struct RotsAfuc26App: App {
    let container: ModelContainer

    init() {
        self.container = ModelContainerFactory.createContainer()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(container)
    }
}
