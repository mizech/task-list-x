import Foundation
import SwiftData

@Model
class Task {
	var id = UUID().uuidString
	var title: String
	var desc: String
	let createdAt = Date.now
	var modifiedAt = Date.now
	
	var project: Project? = nil
	
	init(
		id: String = UUID().uuidString,
		title: String,
		desc: String,
		project: Project? 
	) {
		self.id = id
		self.title = title
		self.desc = desc
		self.project = project
	}
}
