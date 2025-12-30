import SwiftData
import SwiftUI

struct SettingsView: View {
	@AppStorage(APKeys.projectID.rawValue) var projectID: String = ""
	@Query() var projects: [Project]
	
	@State var project: Project? = nil
	@State var feasibleProjectSelections = [FeasibleProjectSelection]()
	
    var body: some View {
		NavigationStack {
			Form {
				Section("Show only tasks allocated to") {
					if projects.count > 0 {
						Picker("Project", selection: $project) {
							ForEach(
								feasibleProjectSelections,
								id: \.self
							) { feasibleSelection in
								Text(feasibleSelection.title)
									.tag(feasibleSelection.project)
							}
						}.pickerStyle(.menu)
					}
				}
			}.navigationTitle("Settings")
				.navigationBarTitleDisplayMode(.inline)
		}.onAppear() {
			if projects.count > 0 {
				feasibleProjectSelections.removeAll()
				
				feasibleProjectSelections
					.append(
						FeasibleProjectSelection(
							title: "* ",
							project: nil
						)
					)
				projects.forEach { project in
					feasibleProjectSelections
						.append(
							FeasibleProjectSelection(
								title: project.title,
								project: project
							)
						)
				}
				
				feasibleProjectSelections.sort()
			}
		}.onChange(of: project) {
			if let project {
				projectID = project.id
			} else {
				projectID = ""
			}
		}
	}
}

#Preview {
    SettingsView()
}
