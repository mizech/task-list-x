import Foundation

protocol Trackable: Identifiable {
	var id: String { get }
	var title: String { get set }
	var desc: String { get set }
	var createdAt: Date { get }
	var modifiedAt: Date { get set }
	var isDeleted: Bool { get set}
}
