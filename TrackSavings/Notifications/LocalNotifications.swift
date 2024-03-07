//
//  LocalNotifications.swift
//  TrackSavings
//
//  Created by Arantza Castro Dessavre on 20/02/24.
//
import SwiftData
import SwiftUI
import CoreLocation
import UserNotifications
//import UserNotificationsUI

class NotificationManager {
    
    static let instance = NotificationManager()
    
    func requestAuthorization (){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error{
                print("ERROR: \(error)")
            } else{
                print("SUCCESS")
            }
        }
    }
    
    func requestNotifications(reminder: String, goal: String) {
        
        //Notifications content
        let content = UNMutableNotificationContent()
        content.title = "Save Money!!"
        content.subtitle = "it's time to save money for \(goal)"
        content.sound = .default
        content.badge = 1
        
        /*Calendar*/
        var dateComponents = DateComponents()
        
        switch reminder {
        case "morning":
            dateComponents.hour = 10
        case "afternoon":
            dateComponents.hour = 16
        case "night":
            dateComponents.hour = 21
        default:
            dateComponents.hour = 16
        }
        
        let tirgger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let requestCalendar = UNNotificationRequest(identifier: goal,
                                                    content: content,
                                                    trigger: tirgger)
        UNUserNotificationCenter.current().add(requestCalendar)
        
    }
    
    func cancelNotifications(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func deleteGoalNotifications(goal: String){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [goal])
    }
}
