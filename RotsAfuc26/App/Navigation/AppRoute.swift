import Foundation

/// Centralized route definitions for type-safe navigation.
enum AppRoute: Hashable {
    case detail(item: CollectibleItem)
    case studio3D(item: CollectibleItem)
    case addEdit(item: CollectibleItem?)
}
