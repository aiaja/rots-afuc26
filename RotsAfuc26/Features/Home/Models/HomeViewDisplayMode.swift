import Foundation

enum HomeViewDisplayMode: String, CaseIterable, Identifiable {
    case standard
    case fullInspection

    var id: String { rawValue }

    var title: String {
        switch self {
        case .standard: return "Compact"
        case .fullInspection: return "Inspection"
        }
    }
}
