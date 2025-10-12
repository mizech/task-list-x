import SwiftUI

struct ProjectFormView: View {
	var action: (String, String) -> Void
	
	@State var title: String = ""
	@State var description: String = ""
	
	var project: Project? = nil
	
    var body: some View {
		NavigationStack {
			Form {
				Section("Project data") {
					TextField("Title", text: $title)
						.textFieldStyle(.roundedBorder)
					TextField("Description", text: $description)
						.textFieldStyle(.roundedBorder)
				}
				
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
		}.onAppear() {
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
