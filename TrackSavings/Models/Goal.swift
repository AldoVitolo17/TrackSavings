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
    
    init(item: String, image: String, cost: Double, date: Date) {
        self.id = item // Assigning item name as ID
        self.item = item
        self.image = image
        self.cost = cost
        self.date = date
    }
    
    static func exampleGoal() -> Goal {
        let goal = Goal(item: "dyson", image: "car", cost: 50.00, date: Date.now)
        return goal
    }
}
