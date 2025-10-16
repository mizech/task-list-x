import SwiftUI

struct ContentView: View {
    var body: some View {
		TabView {
			VStack {
				TasksView()
			}.tabItem {
				Label("Tasks", systemImage: "checklist")
			}
			VStack {
				ProjectsView()
			}.tabItem {
				Label("Projects", systemImage: "calendar.badge.clock")
			}
			VStack  {
				Text("Settings")
			}.tabItem {
				Label("Settings", systemImage: "gear")
			}
		}
    }
}

#Preview {
    ContentView()
}
