import SwiftUI

struct ProjectDetailsView: View {
	@Environment(\.modelContext) var context
	@Bindable var project: Project
	
	@State private var isEditSheetShown = false
	@State private var title = ""
	@State private var desc = ""
	@State private var createdAt = ""
	@State private var modifiedAt = ""
	
	let formatter = DateFormatter()
	
    var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading) {
					Text(project.title)
						.font(.title)
						.padding(.bottom, 2)
					Text("Created at: \(createdAt)")
						.foregroundStyle(.black.mix(with: .gray, by: 0.7))
						.font(.subheadline)
					Text("Modified at: \(modifiedAt)")
						.foregroundStyle(.black.mix(with: .gray, by: 0.7))
						.font(.subheadline)
						.padding(.bottom, 4)
					Text(project.desc)
					Spacer()
				}.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Button {
							isEditSheetShown.toggle()
							title = project.title
							desc = project.desc
						} label: {
							Label("Edit", systemImage: "pencil")
						}
					}
				}.padding()
			}
			.sheet(isPresented: $isEditSheetShown) {
				ProjectFormView(project: project, action: { title, desc in
					project.title = title
					project.desc = desc
					
					do {
						try context.save()
					} catch {
						print("Edit - context.save -> Failed!")
						print(error)
					}
					isEditSheetShown.toggle()
				})
			}
		}.onAppear() {
			formatter.dateStyle = .medium
			createdAt = formatter.string(from: project.createdAt)
			modifiedAt = formatter.string(from: project.modifiedAt)
		}
    }
}

#Preview {
	ProjectDetailsView(
		project: Project(
			title: "Title_01",
			desc: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.\nNullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet.\nEtiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante.\nDuis arcu tortor, suscipit eget, imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris. Integer ante arcu, accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing. Phasellus ullamcorper ipsum rutrum nunc. Nunc nonummy metus. Vestibulum volutpat pretium libero. Cras id dui. Aenean ut eros et nisl sagittis vestibulum. Nullam nulla eros, ultricies sit amet, nonummy id, imperdiet feugiat, pede. Sed lectus. Donec mollis hendrerit risus. Phasellus nec sem in justo pellentesque facilisis. Etiam imperdiet imperdiet orci. Nunc nec neque. Phasellus leo dolor, tempus non, auctor et, hendrerit quis, nisi. Curabitur ligula sapien, tincidunt non, euismod vitae, posuere imperdiet, leo."
		)
	)
}
