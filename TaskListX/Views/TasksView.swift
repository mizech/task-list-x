import SwiftData
import SwiftUI

struct TasksView: View {
	@Environment(\.modelContext) private var context
	@Query private var tasks: [Task]
		
	@State private var isCreateSheetShown = false
	
	init() {
		let done = Status.done.rawValue
		
		let filter = #Predicate<Task> { task in
			task.status != done && task.hasBeenDeleted == false
		}
		
		_tasks = Query(filter: filter)
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(tasks) { task in
					NavigationLink {
						TaskDetailsView(task: task)
					} label: {
						VStack(alignment: .leading) {
							Text(task.title)
								.fontWeight(.bold)
							if task.project != nil {
								Text(task.project?.title ?? "")
							}
						}.strikethrough(task.hasBeenDeleted == true)
					}
				}
				.onDelete { indexSet in
					for index in indexSet {
						var task = tasks[index]
						task.hasBeenDeleted = true
						task.modifiedAt = Date.now
						
						do {
							try context.save()
						} catch {
							print(error)
						}
					}
				}
			}
			.listStyle(.plain)
			.toolbar(content: {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						isCreateSheetShown.toggle()
					} label: {
						Label("Add", systemImage: "plus")
					}
				}
			})
			.navigationTitle("Tasks")
			.navigationBarTitleDisplayMode(.inline)
		}.sheet(isPresented: $isCreateSheetShown) {
			TaskFormView()
		}
    }
}

#Preview {
	TasksView()
}
