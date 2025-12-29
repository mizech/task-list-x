import SwiftUI

struct TaskDetailsView: View {
	@Environment(\.modelContext) var context
	@Bindable var task: Task
	@Binding var needsRefresh: Bool
	
	@State private var isEditSheetShown = false
	
	let dateFormatter = DateFormatter()
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					Text(task.title)
						.font(.title)
						.fontWeight(.bold)
					if let project = task.project {
						Text("Project: \(project.title)")
							.font(.title2)
							.fontWeight(.bold)
							.padding(.bottom, 2)
					}
					LabeledContent {
						Text(task.createdAt.formatted(date: .long, time: .shortened))
					} label: {
						Text("Created at: ")
					}.font(.subheadline)
					LabeledContent {
						Text(task.modifiedAt.formatted(date: .long, time: .shortened))
					} label: {
						Text("Modified at: ")
					}.font(.subheadline).padding(.bottom, 4)
					LabeledContent {
						Text(
							Helper
								.decideLocalizedTextFrom(
									statusValue: task.status
								)
						)
					} label: {
						Text("Status: ")
					}
					LabeledContent {
						Text(task.desc)
					} label: {
						Text("Description: ")
					}.labeledContentStyle(.automatic)
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
				.onAppear() {
					dateFormatter.dateStyle = .short
					dateFormatter.timeStyle = .short
				}
				.sheet(isPresented: $isEditSheetShown) {
					TaskFormView(task: task)
				}
				.onChange(of: isEditSheetShown) {
					if isEditSheetShown == false {
						needsRefresh.toggle()
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
			status: Status.open.rawValue,
			project: Project(
				title: "Project_Title",
				desc: "-"
			)
		), needsRefresh: .constant(false)
	)
}
