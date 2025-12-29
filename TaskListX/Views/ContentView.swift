import SwiftUI

enum Views {
	case projects
	case tasks
	case settings
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
				SettingsView()
			}.tabItem {
				Label("Settings", systemImage: "gear")
			}.tag(Views.settings)
		}
    }
}

#Preview {
    ContentView()
}
