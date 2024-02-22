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
                        .frame(width: 150, height: 150) // Adjust size as needed
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("General").font(.headline).padding(.leading)
                        Divider()
                        DetailRow(label: "Total cost", value: String(format: "%.2fk", goal.cost))
                        Divider()
                        DetailRow(label: "Total saved", value: String(format: "%.2fk", savingsEntries.reduce(0) { $0 + $1.amount }))
                        Divider()
                    }

                    .padding([.top, .horizontal])
                    
                    // New Saving Button
                    Button(action: {
                        // Action to add new saving
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                            Text("New saving")
                        }
                    }
                    .padding()
                    
                    Spacer() // Pushes the delete button to the bottom
                    
                    // List of Savings
                    List {
                        ForEach(savingsEntries) { saving in
                            HStack {
                                Text("Saved amount: \(saving.amount, specifier: "%.2f")")
                                Spacer()
                                Text("Date: \(saving.date, formatter: itemFormatter)")
                            }
                        }
                        .onDelete(perform: deleteSaving)
                    }
                    
                    // Delete Goal Button
                    Button(action: {
                        deleteItem(goal: goal)
                        dismiss()
                    }) {
                        Text("Delete Goal")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding([.bottom, .horizontal])
                }
                .navigationTitle(goal.item)
                .navigationBarItems(
                    leading: Button("Cancel") { dismiss() },
                trailing: Button("Done", action: saveGoal))
            }
        }
        .padding(.bottom) // If necessary, to avoid clipping on some devices
    }
    
    private func saveGoal() {
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
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
    //    GoalDetailView(goal: Goal(item: "New Car", image: "car", cost: 20000, date: Date()))
    ModelPreview{ goal in
        GoalDetailView(goal: goal)
        
    }
}



