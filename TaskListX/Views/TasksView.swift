import SwiftData
import SwiftUI

struct TasksView: View {
	@Environment(\.modelContext) private var context
	@Query private var tasks: [Task]
		
	@State private var isCreateSheetShown = false
	@State private var searchText = ""
	
	@State private var filteredTasks = [Task]()
	
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
				ForEach(filteredTasks) { task in
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
		}
		.searchable(text: $searchText)
		.onChange(of: searchText) {
			if searchText.isEmpty == true {
				filteredTasks = tasks
			} else {
				filteredTasks = tasks.filter { task in
					if task.title
						.contains(searchText) || task.desc
						.contains(searchText) {
						return true
					} else {
						if let project = task.project, project.title
							.contains(searchText) {
							return true
						}
					}
					return false
				}
			}
		}
		.onChange(of: tasks) {
			filteredTasks = tasks
		}
		.onAppear() {
			filteredTasks = tasks
		}
		.sheet(isPresented: $isCreateSheetShown) {
			TaskFormView()
		}
    }
}

#Preview {
	TasksView()
}
