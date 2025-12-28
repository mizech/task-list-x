import SwiftData
import SwiftUI

struct ProjectsArchiveView: View {
	@Environment(\.modelContext) var context
	@Query(filter: #Predicate<Project> { project in
		project.hasBeenDeleted == true
	}, sort: [SortDescriptor(\Project.title)]) var projects: [Project]
	
	@State private var searchText = ""
	@State private var filteredProjects = [Project]()
	
	let dateFormatter = DateFormatter()
	
	init() {
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .short
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(filteredProjects, id: \.self) { project in
					VStack(alignment: .leading) {
						Text(project.title)
							.bold()
							.lineLimit(2)
						Text(project.desc)
							.lineLimit(2)
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
						Button {
							project.hasBeenDeleted = false
							
							do {
								try context.save()
							} catch {
								print(error)
							}
							filteredProjects = projects
						} label: {
							Label("Recreate", systemImage: "arrow.up.trash")
								.frame(height: 40)
									.frame(maxWidth: .infinity)
									.background(.blue)
									.foregroundStyle(.white)
									.fontWeight(.bold)
									.clipShape(RoundedRectangle(cornerRadius: 8))
						}
					}
				}
				.onDelete { indexSet in
					for index in indexSet {
						context.delete(filteredProjects[index])
						filteredProjects.remove(at: index)
					}
					
					do {
						try context.save()
					} catch {
						print("Archive View: Delete failed.")
						print(error)
					}
				}
			}
			.onAppear() {
				filteredProjects = projects
			}
			.onChange(of: searchText) {
				guard searchText.isEmpty == false else {
					filteredProjects = projects
					return
				}
				
				filteredProjects = projects.filter { project in
					project.hasBeenDeleted == true && project.title.localizedLowercase
						.contains(searchText.localizedLowercase)
				}
			}
			.navigationTitle("Archived projects")
				.navigationBarTitleDisplayMode(.inline)
				.listStyle(.plain)
				.searchable(text: $searchText)
		}
    }
}

#Preview {
    ProjectsArchiveView()
}
