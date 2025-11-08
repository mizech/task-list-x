import SwiftData
import SwiftUI

struct ProjectsView: View {
	@Environment(\.modelContext) private var context
	@Query private var projects: [Project]
	
	@State private var isCreateSheetShown = false
	@State private var title = ""
	@State private var description = ""
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(projects) { project in
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
						context.delete(projects[index])
					}
					do {
						try context.save()
					} catch {
						print("ModelContext save, after deletion failed.")
						print(error)
					}
				}
			}
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
		}.sheet(isPresented: $isCreateSheetShown) {
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

