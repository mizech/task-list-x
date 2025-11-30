import SwiftData
import SwiftUI

struct TasksArchiveView: View {
	@Environment(\.modelContext) var context
	@Query var tasks: [Task]
	
	init() {
		let isDone = Status.done.rawValue
		let filter = #Predicate<Task> { task in
			task.hasBeenDeleted == true || task.status == isDone
		}
		_tasks = Query(filter: filter)
	}
	
	var body: some View {
		List {
			ForEach(tasks, id: \.self) { task in
				VStack(alignment: .leading) {
					Text(task.title)
						.bold()
					Text(task.desc)
						.lineLimit(2)
					Text("\(task.createdAt)")
						.lineLimit(2)
					Text("\(task.modifiedAt)")
						.lineLimit(2)
					Text("\(task.hasBeenDeleted)")
						.strikethrough(task.hasBeenDeleted == true)
				}
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
	ProjectsArchiveView()
}
