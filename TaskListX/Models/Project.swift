import Foundation
import SwiftData

@Model
class Project {
	var id = UUID().uuidString
	var title: String
	var desc: String
	
	var createdAt = Date.now
	var modifiedAt = Date.now
	var isDeleted = false
	
	@Relationship(deleteRule: .nullify, inverse: \Task.project)
	var tasks = [Task]()
	
	init(title: String, desc: String) {
		self.title = title
		self.desc = desc
	}
}
