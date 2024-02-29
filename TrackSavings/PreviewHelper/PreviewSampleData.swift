//
//  PreviewSampleData.swift
//  TrackSavings
//
//  Created by Arantza Castro Dessavre on 21/02/24.
//

import Foundation
import SwiftData
import SwiftUI


let previewContainer: ModelContainer = {
    do {
        let schema2 = Schema([
            Goal.self,
            Saving.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema2, isStoredInMemoryOnly: true)
        
        let container = try ModelContainer(for: schema2)
        
        Task{ @MainActor in
            let context = container.mainContext
            
            let goal = Goal.exampleGoal()
//            context.insert(goal)
//            
            let savings = Saving.exampleSaving()
//            context.insert(savings[0])
//            context.insert(savings[1])
//            context.insert(savings[2])
        }
        return container
    } catch {
        fatalError("Failed to load container with error: \(error)")
    }
}()
