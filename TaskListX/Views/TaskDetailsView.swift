import SwiftUI

struct TaskDetailsView: View {
	@Environment(\.modelContext) var context
	@Bindable var task: Task
	
	@State private var isEditSheetShown = false
	@State private var title = ""
	@State private var desc = ""
	@State private var project: Project? = nil
	
    var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					Text(task.title)
						.font(.title)
					Text(task.desc)
					if let project = task.project {
						Text(project.title)
					}
					Spacer()
				}
			}
		}
    }
}

#Preview {
	TaskDetailsView(
		task: Task(
			title: "Title 01",
			desc: "Desc 01",
			project: nil
		)
	)
}
