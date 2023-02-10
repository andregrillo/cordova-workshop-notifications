//
//  MyNotifications.swift
//  MyAPP2
//
//  Created by Andre Grillo on 09/02/2023.
//

import Foundation
import UserNotifications

@objc(MyNotifications)
class MyNotifications: CDVPlugin {
    @objc(sendNotification:)
    func sendNotification (_ command: CDVInvokedUrlCommand){
        if let message = command.arguments[0] as? String, let title = command.arguments[1] as? String, let seconds = command.arguments[2] as? Int {
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = message
            content.sound = UNNotificationSound.default

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
            
            sendPluginResult(callBackID: command.callbackId, status: CDVCommandStatus_OK)
        } else {
            sendPluginResult(callBackID: command.callbackId, status: CDVCommandStatus_ERROR, message: "Error: Missing input parameter")
        }
    }
    
    private func sendPluginResult(callBackID: String, status: CDVCommandStatus, message: String = "") {
        var pluginResult = CDVPluginResult()
        pluginResult?.setKeepCallbackAs(true)
        pluginResult = CDVPluginResult(status: status, messageAs: message)
        self.commandDelegate!.send(pluginResult, callbackId: callBackID)
    }
    
    @objc(requestPermission:)
    func requestPermission(_ command: CDVInvokedUrlCommand){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
                self.sendPluginResult(callBackID: command.callbackId, status: CDVCommandStatus_OK)
            } else if let error = error {
                print(error.localizedDescription)
                self.sendPluginResult(callBackID: command.callbackId, status: CDVCommandStatus_ERROR, message: error.localizedDescription)
            }
        }
    }
}
