//
//  Purchase.swift
//  TrackSavings
//
//  Created by Aldo Vitolo on 18/02/24.
//
import SwiftUI
import Foundation
import SwiftData


@Model
final class Purchase: Identifiable{
    var id = UUID().uuidString
    var item: String
    var image: String
    var cost: Double
    var savings: [Saving]
    var date: Date
    
    init(id: String = UUID().uuidString,item: String,image: String, cost: Double, savings: [Saving], date: Date){
        self.item = item
        self.image = image
        self.cost = cost
        self.savings = savings
        self.date = date
    }
}
