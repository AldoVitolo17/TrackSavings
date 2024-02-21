//
//  Saving.swift
//  TrackSavings
//
//  Created by Gustavo Isaac Lopez Nunez on 20/02/24.
//

import SwiftUI
import Foundation
import SwiftData


@Model
final class Saving: Identifiable{
    var id = UUID().uuidString
    var amount: Double
    var date: Date
    var goal: String

    init(id: String = UUID().uuidString,amount: Double, date: Date, goal: String){
        self.amount = amount
        self.date = date
        self.goal = goal
    }
}
