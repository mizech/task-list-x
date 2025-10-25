import SwiftData
import SwiftUI

struct TasksView: View {
	@Environment(\.modelContext) private var context
	@Query private var tasks: [Task]
	
	@State private var isCreateSheetShown = false
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(tasks) { task in
					NavigationLink {
						TaskDetailsView(task: task)
					} label: {
						VStack(alignment: .leading) {
							Text(task.title).fontWeight(.bold)
							if task.project != nil {
								Text(task.project?.title ?? "")
							}
						}
					}
				}
				.onDelete { indexSet in
					for index in indexSet {
						context.delete(tasks[index])
						
						do {
							try context.save()
						} catch {
							print(error)
						}
					}
				}
			}
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
		}.sheet(isPresented: $isCreateSheetShown) {
			TaskFormView()
		}
    }
}

#Preview {
	TasksView()
}
