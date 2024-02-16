//
//  User.swift
//  TrackSavings
//
//  Created by Aldo Vitolo on 13/02/24.
//
import SwiftUI
import Foundation
import SwiftData

@Model
class User{
    var name: String
    var surname: String
    var username: String?
    var savings: Double
    
    init(name: String, surname: String, username: String, savings: Double){
        self.name = ""
        self.surname = ""
        self.username = ""
        self.savings = 0
    }
}


