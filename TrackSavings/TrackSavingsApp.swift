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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Goal.self,
            Saving.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
