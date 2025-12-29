import SwiftData
import SwiftUI

struct TasksView: View {
	@Environment(\.modelContext) private var context
	@Query() private var tasks: [Task]
	
	@State private var isCreateSheetShown = false
	@State private var searchText = ""
	@State private var needsRefresh = false
	
	@State private var filteredTasks = [Task]()
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(filteredTasks) { task in
					NavigationLink {
						TaskDetailsView(task: task, needsRefresh: $needsRefresh)
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
					for index in indexSet {
						tasks[index].hasBeenDeleted = true
						tasks[index].modifiedAt = Date.now
						tasks[index].project = nil
						
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
		.onChange(of: searchText, {
			if searchText.isEmpty == false {
				let lSearchText = searchText.localizedLowercase
				
				filteredTasks = filteredTasks.filter { task in
					task.title.localizedLowercase.contains(lSearchText)
							|| task.desc.localizedLowercase.contains(lSearchText)
				}
			} else {
				filteredTasks = tasks
			}
			
			filteredTasks.sorted(using: SortDescriptor(\Task.title))
		})
		.sheet(isPresented: $isCreateSheetShown) {
			TaskFormView()
		}.onAppear() {
			setFilteredTasks()
		}
		.onChange(of: tasks) {
			setFilteredTasks()
		}
		.onChange(of: needsRefresh) {
			setFilteredTasks()
		}
	}
	
	func setFilteredTasks() {
		filteredTasks = tasks
		filteredTasks = filteredTasks.filter { task in
			task.hasBeenDeleted == false && task.status != Status.done.rawValue
		}
		filteredTasks.sort(using: SortDescriptor(\Task.title))
	}
}

#Preview {
	TasksView()
}

