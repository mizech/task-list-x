import SwiftData
import SwiftUI

struct TaskFormView: View {
	@Environment(\.modelContext) var context
	@Environment(\.dismiss) var dismiss
	
	@Query var projects: [Project]
	
	@State var title = ""
	@State var desc = ""
	@State var project: Project? = nil
	
	var task: Task? = nil
	
    var body: some View {
		NavigationStack {
			Form {
				Section("Task") {
					LabeledContent {
						TextField("Title", text: $title)
							.textFieldStyle(.roundedBorder)
					} label: {
						Text("Title")
					}
					LabeledContent {
						TextField("Description", text: $desc)
							.textFieldStyle(.roundedBorder)
					} label: {
						Text("Description")
					}
					if projects.count > 0 {
						Picker("Allocation", selection: $project) {
							ForEach(projects, id: \.self) { project in
								Text(project.title).tag(project)
							}
						}.pickerStyle(.menu)
						Text(project?.title ?? "")
					}
				}
				
				Section {
					Button {
						if let task = self.task {
							task.title = title
							task.desc = desc
							task.project = project
						} else {
							let task = Task(
								title: title,
								desc: desc,
								project: project
							)
							context.insert(task)
						}
						
						do {
							try context.save()
						} catch {
							print(error)
						}
						dismiss()
					} label: {
						 Text("Submit")
							.frame(height: 40)
							.frame(maxWidth: .infinity)
							.background(.blue)
							.foregroundStyle(.white)
							.clipShape(RoundedRectangle(cornerRadius: 12))
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						dismiss()
					} label: {
						Label("Close", systemImage: "xmark.circle.fill")
					}
				}
			}
		}.onAppear() {
			if let task = self.task {
				self.title = task.title
				self.desc = task.desc
				self.project = task.project
			}
			
			if projects.count > 0 {
				project = projects.first
			}
		}
    }
}

extension TaskFormView {
	init(task: Task) {
		self.task = task
	}
}

#Preview {
	TaskFormView()
}

