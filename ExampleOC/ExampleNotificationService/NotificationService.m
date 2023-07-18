//
//  NotificationService.m
//  ExampleNotificationService
//
//  Created by Jimmy on 2023/7/18.
//

#import "NotificationService.h"
@import CinnoxVisitorCoreSDK;

@interface NotificationService ()

@property (nonatomic, strong) id<CinnoxNotificationServiceHandler> handler;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.handler = [CinnoxVisitorCore createNotificationServiceHandler];
    
    [self.handler didReceive: request withCinnoxContentHandler:^(UNNotificationContent * _Nonnull content) {
        contentHandler(content);
    } nonCinnoxContent:^{
        UNMutableNotificationContent *bestAttemptContent = [request.content mutableCopy];
        contentHandler(bestAttemptContent);
    }];
}

@end
