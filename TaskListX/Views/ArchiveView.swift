import SwiftData
import SwiftUI

struct ArchiveView: View {
	@Environment(\.modelContext) var context
	@Query(filter: #Predicate<Project> { project in
		project.isDeleted == true
	}) var projects: [Project]
	
	@Query var tasks: [Task]
	
	init() {
		let isDone = Status.done.rawValue
		let filter = #Predicate<Task> { task in
			task.isDeleted == true || task.status == isDone
		}
		_tasks = Query(filter: filter)
	}
	
    var body: some View {
		List {
			ForEach(projects, id: \.self) { project in
				VStack(alignment: .leading) {
					Text(project.title)
						.bold()
					Text(project.desc)
						.lineLimit(2)
				}.strikethrough(true)
			}
			.onDelete { indexSet in
				for index in indexSet {
					context.delete(projects[index])
				}
				
				do {
					try context.save()
				} catch {
					print("Archive View: Delete failed.")
					print(error)
				}
			}
			ForEach(tasks, id: \.self) { task in
				VStack(alignment: .leading) {
					Text(task.title)
						.bold()
					Text(task.desc)
						.lineLimit(2)
				}.strikethrough()
			}
			.onDelete { indexSet in
				for index in indexSet {
					context.delete(tasks[index])
				}
				
				do {
					try context.save()
				} catch {
					print("Archive View: Delete failed.")
					print(error)
				}
			}
		}
    }
}

#Preview {
    ArchiveView()
}
