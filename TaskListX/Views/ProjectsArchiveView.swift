import SwiftData
import SwiftUI

struct ProjectsArchiveView: View {
	@Environment(\.modelContext) var context
	@Query(filter: #Predicate<Project> { project in
		project.hasBeenDeleted == true
	}) var projects: [Project]
	
	let dateFormatter = DateFormatter()
	
	init() {
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .short
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(projects, id: \.self) { project in
					VStack(alignment: .leading) {
						Text(project.title)
							.bold()
							.lineLimit(2)
							.strikethrough(project.hasBeenDeleted)
						Text(project.desc)
							.lineLimit(2)
							.strikethrough(project.hasBeenDeleted)
						LabeledContent {
							Text(dateFormatter.string(from: project.createdAt))
						} label: {
							Text("Created at: ")
						}
						LabeledContent {
							Text(dateFormatter.string(from: project.modifiedAt))
						} label: {
							Text("Deleted at: ")
						}
						HStack(alignment: .center) {
							Spacer()
							Button {
								project.hasBeenDeleted = false
							} label: {
								Label("Recreate", systemImage: "arrow.up.trash")
							}
							Spacer()
						}.padding(.top)
					}
				}
				.onDelete { indexSet in
					for index in indexSet {
						context.delete(projects[index])
					}
					
					do {
						try context.save()
					} catch {
						print("Archive View: Delete failed.")
						print(error)
					}
				}
			}.navigationTitle("Archived projects")
				.navigationBarTitleDisplayMode(.inline)
				.listStyle(.plain)
		}
    }
}

#Preview {
    ProjectsArchiveView()
}
