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
        }
        .modelContainer(sharedModelContainer)
    }
}

@MainActor
let sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Goal.self,
        Saving.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

    do {
        let container = try ModelContainer(for: schema)
        
        var goalLimit = FetchDescriptor<Goal>()
        goalLimit.fetchLimit = 1
        
        guard try container.mainContext.fetch(goalLimit).count == 0 else { return container}
        
        NotificationManager.instance.cancelNotifications()
        
        return container
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
