//
//  GoalDetailView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 20/02/24.
//
import SwiftData
import SwiftUI

struct GoalDetailView: View {
    let goal: Goal
    @Environment(\.modelContext) private var modelContext
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            CircularProgressView(progress: 0.0, image: goal.image)
            List{
                Section("General"){
                    Text("Item: \(goal.item)")
                    Text("Cost: $\(goal.cost, specifier: "%.2f")")
                    // Add more details as needed
                }
                
                Section{
                    Button(role: .destructive, action: {
                        deleteItem(goal: goal)
                        dismiss()
                    }, label: {
                        Text("Delete")
                    }).foregroundColor(.red)
                }
                .position(CGPoint(x: 25, y: 400.0))
            }
            .listStyle(.plain)
            .navigationTitle("Goal Detail")
        }
    }
    
    func deleteItem(goal: Goal){
        modelContext.delete(goal)
    }
}

#Preview {
    GoalDetailView(goal: Goal(item: "New Car", image: "car", cost: 20000, savings: [], date: Date()))
}
