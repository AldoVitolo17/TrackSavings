//
//  GoalDetailView.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 20/02/24.
//

import SwiftUI

struct GoalDetailView: View {
    let goal: Goal

    var body: some View {
        VStack {
            Text("Item: \(goal.item)")
            Text("Cost: $\(goal.cost, specifier: "%.2f")")
            // Add more details as needed
        }
        .navigationTitle("Goal Detail")
    }
}

#Preview {
    GoalDetailView(goal: Goal(item: "New Car", image: "car", cost: 20000, savings: [], date: Date()))
}
