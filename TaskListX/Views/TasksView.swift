import SwiftData
import SwiftUI

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct TasksView: View {
	@Environment(\.modelContext) private var context
	@Query private var tasks: [Task]
		
	@State private var isCreateSheetShown = false
	@State private var searchText = ""
	
	private var filteredTasks: [Task] {
		let base = tasks
		let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		guard query.isEmpty == false else { return base }
		return base.filter { task in
			if task.title.localizedCaseInsensitiveContains(query) { return true }
			if task.desc.localizedCaseInsensitiveContains(query) { return true }
			if let project = task.project, project.title.localizedCaseInsensitiveContains(query) { return true }
			return false
		}
	}
	
	init() {
		let done = Status.done.rawValue
		let filter: Predicate<Task> = #Predicate { task in
			task.status != done && task.hasBeenDeleted == false
		}
		
		_tasks = Query(filter: filter, sort: [SortDescriptor(\.modifiedAt, order: .reverse)])
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(filteredTasks.sorted(by: {
					$0.title < $1.title
				})) { task in
					NavigationLink {
						TaskDetailsView(task: task)
					} label: {
						VStack(alignment: .leading) {
							Text(task.title)
								.fontWeight(.bold)
							if let project = task.project {
								Text(project.title)
							}
						}.strikethrough(task.isDeleted == true)
					}
				}
				.onDelete { indexSet in
					let itemsToDelete = indexSet.compactMap { filteredTasks[safe: $0] }
					for item in itemsToDelete {
						var task = item
						task.hasBeenDeleted = true
						task.modifiedAt = Date.now
						task.project = nil
						
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
		.sheet(isPresented: $isCreateSheetShown) {
			TaskFormView()
		}
    }
}

#Preview {
	TasksView()
}
