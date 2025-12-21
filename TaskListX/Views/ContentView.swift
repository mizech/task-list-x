import SwiftUI

enum Views {
	case projects
	case tasks
	case archive
}

struct ContentView: View {
	@State var selectedView = Views.tasks
	
    var body: some View {
		TabView(selection: $selectedView) {
			VStack {
				ProjectsView()
			}.tabItem {
				Label("Projects", systemImage: "checklist")
			}.tag(Views.projects)
			
			VStack {
				TasksView()
			}.tabItem {
				Label("Tasks", systemImage: "calendar.badge.clock")
			}.tag(Views.tasks)
			
			VStack  {
				ProjectsArchiveView()
			}.tabItem {
				Label("Projects archive", systemImage: "archivebox")
			}.tag(Views.archive)
			VStack  {
				TasksArchiveView()
			}.tabItem {
				Label("Tasks archive", systemImage: "trash")
			}.tag(Views.archive)
		}
    }
}

#Preview {
    ContentView()
}
