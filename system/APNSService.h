@import Foundation;
@import UIKit;

@interface APNSService : NSObject

+ (void)addLocalNotification:(NSString*)body title:(NSString*)title interval:(NSTimeInterval)second;

+ (void)runService:(UIUserNotificationSettings*)settings;
+ (void)registerSettings;
+ (NSString*)deviceToken;
+ (void)successRegister:(NSData*)token;
+ (void)failRegister:(NSError*)error;
+ (void)receiveNotification:(NSDictionary*)userInfo;
+ (void)increateBadgeNumber;
+ (void)clearBadgeNumber;

@end
