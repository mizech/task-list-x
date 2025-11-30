import SwiftData
import SwiftUI

struct ProjectsArchiveView: View {
	@Environment(\.modelContext) var context
	@Query(filter: #Predicate<Project> { project in
		project.hasBeenDeleted == true
	}) var projects: [Project]
	
    var body: some View {
		List {
			ForEach(projects, id: \.self) { project in
				VStack(alignment: .leading) {
					Text(project.title)
						.bold()
					Text(project.desc)
						.lineLimit(2)
				}.strikethrough(project.hasBeenDeleted)
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
		}
    }
}

#Preview {
    ProjectsArchiveView()
}
