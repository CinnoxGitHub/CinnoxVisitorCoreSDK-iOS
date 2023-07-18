//
//  NotificationService.swift
//  ExampleNotificationService
//
//  Created by Jimmy on 2023/7/17.
//

import UserNotifications
import CinnoxVisitorCoreSDK

class NotificationService: UNNotificationServiceExtension {
    public var notificationHandler = CinnoxVisitorCore.createNotificationServiceHandler()

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        notificationHandler.didReceive(request) { content in
            contentHandler(content)
        } nonCinnoxContent: {
            if let bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent) {
                contentHandler(bestAttemptContent)
            }
        }
    }
}

