import SwiftUI

struct ContentView: View {
    var body: some View {
		TabView {
			VStack {
				Text("Tasks")
			}.tabItem {
				Label("Tasks", systemImage: "star")
			}
			VStack {
				Text("Projects")
			}.tabItem {
				Label("Projects", systemImage: "heart")
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
