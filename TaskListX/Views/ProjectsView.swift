import SwiftData
import SwiftUI

struct ProjectsView: View {
	@Environment(\.modelContext) private var context
	@Query(filter: #Predicate<Project> { project in
		project.hasBeenDeleted == false
	}) private var projects: [Project]
	
	@State private var isCreateSheetShown = false
	@State private var title = ""
	@State private var description = ""
	@State private var searchText = ""
	
	@State private var filteredProjects = [Project]()
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(filteredProjects) { project in
					NavigationLink {
						ProjectDetailsView(project: project)
					} label: {
						VStack(alignment: .leading) {
							Text(project.title)
								.bold()
							Text(project.desc)
								.lineLimit(2)
								.autocorrectionDisabled(true)
								.textInputAutocapitalization(.never)
						}
					}
				}.onDelete { indexSet in
					for index in indexSet {
						projects[index].hasBeenDeleted = true
						projects[index].tasks.forEach { task in
							task.project = nil
						}
						
						do {
							try context.save()
						} catch {
							print(error)
						}
					}
					do {
						try context.save()
					} catch {
						print("ModelContext save, after deletion failed.")
						print(error)
					}
				}
			}
			.listStyle(.plain)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						isCreateSheetShown.toggle()
					} label: {
						Label("Add", systemImage: "plus")
					}
					
				}
			}
			.navigationTitle("Projects")
			.navigationBarTitleDisplayMode(.inline)
		}
		.searchable(text: $searchText)
		.onChange(of: searchText, {
			if searchText.isEmpty == false {
				filteredProjects = projects.filter { project in
					project.title.contains(searchText)
				}
			} else {
				filteredProjects = projects
			}
		})
		.onAppear() {
			filteredProjects = projects
		}
		.sheet(isPresented: $isCreateSheetShown) {
			ProjectFormView() { title, desc in
				
				context.insert(
					Project(
						title: title,
						desc: desc
					)
				)
				
				do {
					try context.save()
				} catch {
					print("context.save() -> Failed")
					print(error)
				}
				isCreateSheetShown.toggle()
			}
		}
	}
}

#Preview {
	ProjectsView()
}

