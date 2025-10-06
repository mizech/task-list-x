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
				ForEach(projects) {  project in
					Text(project.title)
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
			Form {
				Section("Project data") {
					TextField("Title", text: $title)
					TextField("Description", text: $description)
				}
				Section() {
					Button("Submit") {
						context.insert(
							Project(
								title: title,
								desc: description
							)
						)
						
						do {
							print("ModelContext save, after insert failed.")
							try context.save()
						} catch {
							print(error)
						}
						isCreateSheetShown.toggle()
					}
					.buttonStyle(.borderedProminent)
				}
			}
		}
    }
}

#Preview {
    ProjectsView()
}
