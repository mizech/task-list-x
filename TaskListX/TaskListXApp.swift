import SwiftData
import SwiftUI

@main
struct TaskListXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.modelContainer(for: Task.self)
        }
    }
}
