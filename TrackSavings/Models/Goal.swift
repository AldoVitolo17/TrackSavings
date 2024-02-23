//
//  Goal.swift
//  TrackSavings
//
//  Created by Aldo Vitolo on 18/02/24.
//
import SwiftUI
import Foundation
import SwiftData


@Model
final class Goal: Identifiable {
    var id: String // Using item name as the ID
    var item: String
    var image: String
    var cost: Double
    var date: Date
    var reminder: String
    
    init(item: String, image: String, cost: Double, date: Date, reminder: String) {
        self.id = item // Assigning item name as ID
        self.item = item
        self.image = image
        self.cost = cost
        self.date = date
        self.reminder = reminder
    }
    
    static func exampleGoal() -> Goal {
        let goal = Goal(item: "dyson", image: "car", cost: 533.00, date: Date.now, reminder: "morning")
        return goal
    }
}
