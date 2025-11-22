import Foundation

enum Status: String, Codable, CaseIterable {
	case open = "Open"
	case inWork = "In work"
	case done = "Done"
}
