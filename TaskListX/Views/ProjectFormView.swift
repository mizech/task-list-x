import SwiftUI

struct ProjectFormView: View {
	@Environment(\.dismiss) private var dismiss
	var action: (String, String) -> Void
	
	@State var title: String = ""
	@State var description: String = ""
	
	var project: Project? = nil
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Project") {
					LabeledContent {
						TextField("Title (mandatory)", text: $title)
							.textFieldStyle(.roundedBorder)
					} label: {
						Text("Title")
					}
					LabeledContent {
						TextField("Description (optional)", text: $description)
							.textFieldStyle(.roundedBorder)
					} label: {
						Text("Description")
					}
				}
				if title.count > 0 {
					Section {
						Button {
							action(title, description)
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
			}.toolbar(content: {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						dismiss()
					} label: {
						Label("Close", systemImage: "xmark.circle.fill")
					}
				}
			})
		}
		.onAppear() {
			if let project = self.project {
				self.title = project.title
				self.description = project.desc
			}
		}
	}
}

extension ProjectFormView {
	init(project: Project, action: @escaping (String, String) -> Void) {
		self.action = action
		self.project = project
	}
}

#Preview {
	let a = ""
	let b = ""
	ProjectFormView(action: { (a, b) in })
}
