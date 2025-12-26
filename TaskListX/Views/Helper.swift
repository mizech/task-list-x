import Foundation

struct Helper {
	static func decideTextFrom(status: Status) -> String {
		switch status {
			case .open:
				return String(localized: "Open")
			case .inWork:
				return String(localized: "In work")
			case .done:
				return String(localized: "Done")
		}
	}
	
	static func decideLocalizedTextFrom(statusValue: String) -> String {
		if statusValue == Status.open.rawValue {
			return String(localized: "Open")
		} else if statusValue == Status.inWork.rawValue {
			return String(localized: "In work")
		} else {
			return String(localized: "Done")
		}
	}
}
