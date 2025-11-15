import SwiftUI

struct TaskDetailsView: View {
	@Environment(\.modelContext) var context
	@Bindable var task: Task
	
	@State private var isEditSheetShown = false
	@State private var createdAt = ""
	@State private var modifiedAt = ""
	
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
					Text(
						"Created at: \(task.createdAt.formatted(date: .long, time: .shortened))"
					)
						.foregroundStyle(.black.mix(with: .gray, by: 0.7))
						.font(.subheadline)
					Text(
						"Modifed at: \(task.modifiedAt.formatted(date: .long, time: .shortened))"
					)
						.foregroundStyle(.black.mix(with: .gray, by: 0.7))
						.font(.subheadline)
						.padding(.bottom, 4)
					LabeledContent {
						Text(task.desc)
					} label: {
						Text("Description")
					}
					LabeledContent {
						Text(task.status.rawValue)
					} label: {
						Text("Status")
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
				.onAppear() {
					dateFormatter.dateStyle = .short
					dateFormatter.timeStyle = .short
					createdAt = dateFormatter.string(from: task.createdAt)
					modifiedAt = dateFormatter.string(from: task.modifiedAt)
				}
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
			status: Status.open,
			project: Project(
				title: "Project_Title",
				desc: "-"
			)
		)
	)
}
