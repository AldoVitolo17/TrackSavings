//
//  SavingWidgetLiveActivity.swift
//  SavingWidget
//
//  Created by Aldo Vitolo on 14/02/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SavingWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SavingWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SavingWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SavingWidgetAttributes {
    fileprivate static var preview: SavingWidgetAttributes {
        SavingWidgetAttributes(name: "World")
    }
}

extension SavingWidgetAttributes.ContentState {
    fileprivate static var smiley: SavingWidgetAttributes.ContentState {
        SavingWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SavingWidgetAttributes.ContentState {
         SavingWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SavingWidgetAttributes.preview) {
   SavingWidgetLiveActivity()
} contentStates: {
    SavingWidgetAttributes.ContentState.smiley
    SavingWidgetAttributes.ContentState.starEyes
}
