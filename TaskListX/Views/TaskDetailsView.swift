import SwiftUI

struct TaskDetailsView: View {
	@Bindable var task: Task
	
    var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					Text(task.title)
						.font(.title)
				}
			}
		}
    }
}

#Preview {
	TaskDetailsView(
		task: Task(
			title: "Title 01",
			desc: "Desc 01",
			project: nil
		)
	)
}
