//
//  TrackSavingsApp.swift
//  TrackSavings
//
//  Created by Aldo Vitolo on 13/02/24.
//

import SwiftUI
import SwiftData

@main
struct TrackSavingsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Goal.self,Saving.self])
        }
    
    }
}
