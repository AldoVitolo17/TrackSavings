//
//  GoalDetailView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 20/02/24.
//
import SwiftUI
import SwiftData

struct GoalDetailView: View {
    let goal: Goal
    @State private var addSavingModal = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
//    @FetchRequest(
//        entity: Saving.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Saving.date, ascending: true)],
//        predicate: NSPredicate(format: "goal == %@", goal.id)
//    ) private var savingsEntries: FetchedResults<Saving> // Fetches savings related to this goal
    
//    
//init(goal: Goal) {
//    self.goal = goal
//    self.descriptor = FetchDescriptor<Saving>(predicate: #Predicate<Saving> { saving in
//        saving.id == goal.id})
//}
//
//@Query(descriptor) private var savingsEntries: [Saving]
    
    @Query private var savingsEntries: [Saving]

    var progress: Double {
        // Calculate the progress based on the goal's total cost and the total saved amount
        let totalSavings = savingsEntries.reduce(0) { $0 + $1.amount }
        return totalSavings / goal.cost
    }

    var body: some View {
        NavigationView {
            ZStack { //Fix the UI
                VStack(spacing: 20) {
                    // Custom CircularProgressView with the progress and goal image
                    CircularProgressView(progress: progress, image: goal.image)
                        .frame(width: 150, height: 250) // Adjust size as needed
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("General")
                            .fontDesign(.rounded)
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                            .padding(.leading)
                        DetailRow(label: "Total cost", value: String(format: "£%.2f", goal.cost))
                        Divider()
                        DetailRow(label: "Total saved", value: String(format: "£%.2f", savingsEntries.reduce(0) { $0 + $1.amount }))
                        Divider()
                    }

                    .padding([.top, .horizontal])
                    
                    // New Saving Button
                    Button(action: { addSavingModal.toggle() }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                            Text("New saving")
                        }
                    }                        .fullScreenCover(isPresented: $addSavingModal) {
                        AddSavingView(isPresented: $addSavingModal)
                    }
                    .padding([.horizontal, .top])
                    
                    
                    
                    ForEach(savingsEntries) { saving in
                        HStack(alignment: .center){
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundStyle(Color("PrimaryColor"))
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            
                            VStack(alignment: .leading){
                                Text("\(saving.date, formatter: dateFormatter)")
                                
                                Text("\(saving.date, formatter: timeFormatter)")
                                    .foregroundStyle(Color.secondary)
                            }
                            
                            Spacer()
                            Text("£\(saving.amount, specifier: "%.2f")")
                        }
                        .padding(.horizontal)
                    }
                    .onDelete(perform: deleteSaving)
                    
                    // Delete Goal Button
                    Button("Delete Goal", role: .destructive){
                        deleteItem(goal: goal)
                        dismiss()
                    }
                    .padding([.bottom, .horizontal])
                }
                .navigationTitle(goal.item)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbarBackground(Color("PrimaryColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .background(Color("BackgroundColor"))
                .navigationBarItems(
                    leading: Button("Cancel") { dismiss() },
                    trailing: Button("Done", action: saveChanges))
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding(.bottom) // If necessary, to avoid clipping on some devices
        .fontDesign(.rounded)
    }
    
    private func saveChanges() {
        // Implement save functionality
    }
    
    private func deleteItem(goal: Goal) {
        modelContext.delete(goal)
    }
    
    private func deleteSaving(offsets: IndexSet) {
        withAnimation {
            offsets.map { savingsEntries[$0] }.forEach(modelContext.delete)
            // Save the context after deletion
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()


// A helper view to create a consistent layout for detail rows
struct DetailRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label).padding(.leading)
            Spacer()
            Text(value)
        }
        .padding(.vertical, 4)
    }
}



#Preview {
    ModelPreview{ goal in
        GoalDetailView(goal: goal)
    }
}



