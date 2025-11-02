import SwiftUI

struct TaskDetailsView: View {
	@Environment(\.modelContext) var context
	@Bindable var task: Task
	
	@State private var isEditSheetShown = false
	
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
			}.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						isEditSheetShown.toggle()
					} label: {
						Label("Edit", systemImage: "pencil")
					}
				}
			}.padding()
				.sheet(isPresented: $isEditSheetShown) {
					TaskFormView(task: task)
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
		))
}
