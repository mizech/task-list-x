import Foundation

struct FeasibleProjectSelection: Hashable, Comparable {
	var title: String
	var project: Project? = nil
	
	static func < (lhs: FeasibleProjectSelection, rhs: FeasibleProjectSelection) -> Bool {
		lhs.title < rhs.title
	}
}
