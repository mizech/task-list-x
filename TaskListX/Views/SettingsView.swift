import SwiftData
import SwiftUI

struct SettingsView: View {
	@AppStorage(AppStorageKeyValues.projectID.rawValue) var projectID: String = ""
	@AppStorage(
		AppStorageKeyValues.showStatusOpen.rawValue
	) var showStatusOpen = true
	@AppStorage(
		AppStorageKeyValues.showStatusInWork.rawValue
	) var showStatusInWork = true
	@AppStorage(AppStorageKeyValues.showStatusDone.rawValue) var showStatusDone = true
	
	@Query() var projects: [Project]
	
	@State var project: Project? = nil
	@State var isStatusOpenSelected = true
	@State var isStatusInWorkSelected = true
	@State var isStatusDoneSelected = true
	@State var feasibleProjectSelections = [FeasibleProjectSelection]()
	
	let emptyProject = Project(title: "", desc: "")
	
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
				Section("Show tasks with status") {
					Toggle("Open", isOn: $isStatusOpenSelected)
					Toggle("In work", isOn: $isStatusInWorkSelected)
					Toggle("Done", isOn: $isStatusDoneSelected)
				}
			}.navigationTitle("Settings")
				.navigationBarTitleDisplayMode(.inline)
		}.onAppear() {
			isStatusOpenSelected = showStatusOpen
			isStatusInWorkSelected = showStatusInWork
			isStatusDoneSelected = showStatusDone
			
			if projects.count > 0 {
				feasibleProjectSelections.removeAll()
				
				feasibleProjectSelections
					.append(
						FeasibleProjectSelection(
							title: "* ",
							project: nil
						)
					)
				feasibleProjectSelections
					.append(
						FeasibleProjectSelection(
							title: "No project assigned",
							project: emptyProject
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
			
			if projectID.isEmpty == false {
				if projectID == AppStorageKeyValues.noProjectAssigned.rawValue {
					project = emptyProject
				} else {
					project = projects.first(where: { project in
						project.id == projectID
					})
				}
			}
		}.onChange(of: project) {
			if let project {
				if project.title.isEmpty == false {
					projectID = project.id
				} else {
					projectID = AppStorageKeyValues.noProjectAssigned.rawValue
				}
			} else {
				projectID = ""
			}
		}.onChange(of: isStatusOpenSelected) {
			showStatusOpen = isStatusOpenSelected
		}.onChange(of: isStatusInWorkSelected) {
			showStatusInWork = isStatusInWorkSelected
		}.onChange(of: isStatusDoneSelected) {
			showStatusDone = isStatusDoneSelected
		}
	}
}

#Preview {
	SettingsView()
}
