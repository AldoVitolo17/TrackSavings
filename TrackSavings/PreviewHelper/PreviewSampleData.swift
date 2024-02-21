//
//  PreviewSampleData.swift
//  TrackSavings
//
//  Created by Arantza Castro Dessavre on 21/02/24.
//

import Foundation
import SwiftData

let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Goal.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        Task{ @MainActor in
            let context = container.mainContext
            
            let goal = Goal.example()
            context.insert(goal)
        }
        return container
    } catch {
        fatalError("Failed to load container with error: \(error)")
    }
}()
