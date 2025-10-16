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
						
					} label: {
						Text(task.title)
					}
				}
			}
			.toolbar(content: {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						
					} label: {
						Label("Add", systemImage: "plus")
					}
				}
			})
			.navigationTitle("Tasks")
		}.sheet(isPresented: $isCreateSheetShown) {
			
		}
    }
}

#Preview {
	TasksView()
}
