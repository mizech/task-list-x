import Foundation
import SwiftData

@Model
class Task: Trackable {
	var id = UUID().uuidString
	var title: String
	var desc: String
	var status = Status.open.rawValue
	
	var createdAt = Date.now
	var modifiedAt = Date.now
	var isDeleted = false
	
	var project: Project? = nil
	
	init(
		id: String = UUID().uuidString,
		title: String,
		desc: String,
		status: String,
		project: Project?
	) {
		self.id = id
		self.title = title
		self.desc = desc
		self.status = status
		self.project = project
	}
}
