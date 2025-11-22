import SwiftData
import SwiftUI

struct ArchiveView: View {
	@Environment(\.modelContext) var context
	@Query var tasks: [Task]
	
    var body: some View {
		List {
			ForEach(tasks) { task in
				VStack(alignment: .leading) {
					Text(task.title)
						.bold()
					Text(task.desc)
						.lineLimit(2)
				}
			}
			.onDelete { indexSet in
				for index in indexSet {
					context.delete(tasks[index])
				}
				
				do {
					try context.save()
				} catch {
					print("Archive View: Delete failed.")
					print(error)
				}
			}
		}
    }
}

#Preview {
    ArchiveView()
}
