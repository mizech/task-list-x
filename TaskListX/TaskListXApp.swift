import SwiftData
import SwiftUI

// Todo: Impl. ArchiveView-list
// Todo: LabelContent in ProjectDetailsView. See: TaskDetailsView
@main
struct TaskListXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.modelContainer(for: Task.self)
        }
    }
}
