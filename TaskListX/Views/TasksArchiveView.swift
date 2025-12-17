import SwiftData
import SwiftUI

struct TasksArchiveView: View {
	@Environment(\.modelContext) var context
	@Query var tasks: [Task]
	
	let dateFormatter = DateFormatter()
	
	init() {
		let isDone = Status.done.rawValue
		let filter = #Predicate<Task> { task in
			task.hasBeenDeleted == true || task.status == isDone
		}
		_tasks = Query(filter: filter)
		
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .short
	}
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(tasks, id: \.self) { task in
					VStack(alignment: .leading) {
						Text(task.title)
							.bold()
						Text(task.desc)
							.lineLimit(2)
						LabeledContent {
							Text(dateFormatter.string(from: task.createdAt))
								.lineLimit(2)
						} label: {
							Text("Created at: ")
						}
						LabeledContent {
							Text(dateFormatter.string(from: task.modifiedAt))
								.lineLimit(2)
						} label: {
							Text("Deleted at: ")
						}
					}.strikethrough(task.hasBeenDeleted == true)
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
			}.listStyle(.plain)
				.navigationTitle("Archived tasks")
				.navigationBarTitleDisplayMode(.inline)
		}
	}
}

#Preview {
	ProjectsArchiveView()
}
