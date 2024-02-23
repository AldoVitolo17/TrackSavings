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
    
    func requestNotifications(reminder: String) {
        
        //Notifications content
        let contentT = UNMutableNotificationContent()
        contentT.title = "Save Money!!"
        contentT.subtitle = "it's tiiiimeeeeee"
        contentT.sound = .default
        contentT.badge = 1
        
        let contentC = UNMutableNotificationContent()
        contentC.title = "Save Money!!"
        contentC.subtitle = "it's hammer time"
        contentC.sound = .default
        contentC.badge = 1
        
        let contentL = UNMutableNotificationContent()
        contentL.title = "Save Money!!"
        contentL.subtitle = "I know where you live..."
        contentL.sound = .default
        contentL.badge = 1
        
        //Triggers
        /*Time*/
        let triggerTime = UNTimeIntervalNotificationTrigger(timeInterval: 5.0 , repeats: false)
        
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
        
        let triggerCalendar = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        /*Location*/
        let coordinates = CLLocationCoordinate2D(latitude: 40.83625219241846, longitude: 14.306192447547891)
        
        let region = CLCircularRegion(
            center: coordinates,
            radius: 100,
            identifier: UUID().uuidString)
        
        region.notifyOnExit = true
        region.notifyOnEntry = true
        
        let triggerLocation = UNLocationNotificationTrigger(region: region, repeats: true)
        
        let requestTime = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: contentT,
                                            trigger: triggerTime)
        UNUserNotificationCenter.current().add(requestTime)
        
        let requestCalendar = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: contentC,
                                            trigger: triggerCalendar)
        UNUserNotificationCenter.current().add(requestCalendar)
        
        let requestLocation = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: contentL,
                                            trigger: triggerLocation)
        UNUserNotificationCenter.current().add(requestLocation)
    }
    
    func cancelNotifications(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        
    }
    
}

//struct LocalNotificationView: View {
//
////    var body: some View {
////        VStack{
////            Button("Request authorization"){
////                NotificationManager.instance.requestAuthorization()
////            }
////        
//////            Button("send"){
//////                NotificationManager.instance.requestNotifications()
//////            }
////            
////            Button("Cancel"){
////                NotificationManager.instance.cancelNotifications()
////            }
////            .onAppear{
////                let null = 0
////                UNUserNotificationCenter.current().setBadgeCount(null)
////            }
////        }
////    }
//}
