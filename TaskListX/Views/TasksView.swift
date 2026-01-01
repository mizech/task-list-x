import SwiftData
import SwiftUI

struct TasksView: View {
	@Environment(\.modelContext) private var context
	@AppStorage(AppStorageKeyValues.projectID.rawValue) var projectID: String = ""
	@AppStorage(AppStorageKeyValues.showStatusOpen.rawValue) var showStatusOpen = true
	@AppStorage(AppStorageKeyValues.showStatusInWork.rawValue) var showStatusInWork = true
	@AppStorage(AppStorageKeyValues.showStatusDone.rawValue) var showStatusDone = true
	
	@Query() private var tasks: [Task]
	
	@State private var isCreateSheetShown = false
	@State private var searchText = ""
	@State private var needsRefresh = false
	
	@State private var filteredTasks = [Task]()
	
	private var listView: some View {
		List {
			ForEach(filteredTasks, id: \.id) { task in
				NavigationLink {
					TaskDetailsView(task: task, needsRefresh: $needsRefresh)
				} label: {
					VStack(alignment: .leading) {
						Text(task.title)
							.fontWeight(.bold)
						if let project = task.project {
							Text(project.title)
						}
					}
					.strikethrough(task.isDeleted)
				}
			}
			.onDelete { indexSet in
				for index in indexSet {
					let task = filteredTasks[index]
					task.modifiedAt = Date.now
					task.project = nil
					context.delete(task)
				}
				do {
					try context.save()
				} catch {
					print(error)
				}
				setFilteredTasks()
			}
		}
		.listStyle(.plain)
	}
	
	var body: some View {
		NavigationStack {
			listView
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
		.onAppear {
			setFilteredTasks()
		}
		.onChange(of: tasks) {
			setFilteredTasks()
		}
		.onChange(of: needsRefresh) {
			setFilteredTasks()
		}
		.onChange(of: searchText) {
			setFilteredTasks()
		}
	}
	
	func setFilteredTasks() {
		var result = tasks
		
		if projectID.isEmpty == false {
			if projectID == AppStorageKeyValues.noProjectAssigned.rawValue {
				result = result.filter { task in
					return task.project == nil
				}
			} else {
				result = result.filter { task in
					return task.project?.id == projectID
				}
			}
		}
		
		if showStatusOpen == false {
			result = result.filter { task in
				task.status != Status.open.rawValue
			}
		}
		
		if showStatusInWork == false {
			result = result.filter { task in
				task.status != Status.inWork.rawValue
			}
		}
		
		if showStatusDone == false {
			result = result.filter { task in
				task.status != Status.done.rawValue
			}
		}
		
		let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		if !query.isEmpty {
			let lq = query.localizedLowercase
			result = result.filter { task in
				task.title.localizedLowercase.contains(lq) || task.desc.localizedLowercase.contains(lq)
			}
		}
		result.sort(using: SortDescriptor(\Task.title))
		filteredTasks = result
	}
}

#Preview {
	TasksView()
}

