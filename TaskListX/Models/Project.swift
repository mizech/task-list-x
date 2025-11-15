import Foundation
import SwiftData

@Model
class Project {
	var id = UUID().uuidString
	var title: String
	var desc: String
	
	var status = Status.open
	var createdAt = Date.now
	var modifiedAt = Date.now
	
	@Relationship(deleteRule: .cascade, inverse: \Task.project)
	var tasks = [Task]()
	
	init(title: String, desc: String) {
		self.title = title
		self.desc = desc
	}
}
