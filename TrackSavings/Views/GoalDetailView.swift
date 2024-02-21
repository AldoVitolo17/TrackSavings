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
            VStack {
                // Custom CircularProgressView with the progress and goal image
                CircularProgressView(progress: progress, image: goal.image)
                    .frame(width: 100, height: 100) // Adjust size as needed
                
                // General Section with goal details
                VStack(alignment: .leading) {
                    Text("General").font(.headline)
                    HStack {
                        Text("Total cost")
                        Spacer()
                        Text("\(goal.cost, specifier: "%.2f")k")
                    }
                    HStack {
                        Text("Total saved")
                        Spacer()
                        Text("\(savingsEntries.reduce(0) { $0 + $1.amount }, specifier: "%.2f")k")
                    }
                }
                .padding()
                
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
                .padding()
            }
            .navigationTitle(goal.item)
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Done", action: saveGoal))
            .padding()
        }
    }
    
    private func saveGoal() {
        // Implement save functionality
    }
    
    private func deleteItem(goal: Goal) {
//        modelContext.delete(goal)
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


#Preview {
    GoalDetailView(goal: Goal(item: "New Car", image: "car", cost: 20000, date: Date()))
}
