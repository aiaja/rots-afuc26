import SwiftUI

@Observable
final class HomeViewModel {
    var displayMode: HomeViewDisplayMode = .standard
    var searchText: String = ""

    func filterItems(_ items: [CollectibleItem]) -> [CollectibleItem] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return items
        }
        return items.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText) ||
            item.category.localizedCaseInsensitiveContains(searchText)
        }
    }
}
