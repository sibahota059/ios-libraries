#import "APNSService.h"
#import "AppDelegate.h"

static NSString* _deviceToken = nil;

@implementation APNSService

/*
  add code to AppDelegate 
 
 - (void)applicationDidBecomeActive:(UIApplication *)application {
    [APNSService registerSettings];
    [APNSService clearBadgeNumber];
 
    // 로컬 알림
    NSDictionary *notif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(notif) {
        [self application:application didReceiveLocalNotification:launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]];
    }

 }

 - (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
    if([application applicationState] == UIApplicationStateActive) { }
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:notif.alertAction message:notif.alertBody delegate:nil cancelButtonTitle:@"SDF" otherButtonTitles:@"sdf", nil];
    [view show];
 }
 
 - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
 [APNSService receiveNotification:userInfo];
 }
 
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 [APNSService successRegister:deviceToken];
 }
 
 - (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
 [APNSService runService:notificationSettings];
 }
 
 - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
 [APNSService failRegister:error];
 }
 
*/

+ (void)addLocalNotification:(NSString*)body title:(NSString*)title interval:(NSTimeInterval)second {
    NSDate *now = [NSDate date];
    UILocalNotification *reminderNotification = [[UILocalNotification alloc] init];
    [reminderNotification setFireDate:[now dateByAddingTimeInterval:second]];
    [reminderNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [reminderNotification setAlertBody:body];
    [reminderNotification setAlertAction:title];
    [reminderNotification setSoundName:UILocalNotificationDefaultSoundName];
    [reminderNotification setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] scheduleLocalNotification:reminderNotification];
}

+ (void)runService:(UIUserNotificationSettings*)settings {
    if(settings.types == UIUserNotificationTypeNone) {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        NSLog(@"[APNS] unregister remote notification");
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        NSLog(@"[APNS] register remote notification");
    }
}

+ (void)registerSettings {
    if([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
            NSLog(@"[APNS] current settings %u", settings.types);
        }
        else {
            NSUInteger settingFlags = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:settingFlags
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            NSLog(@"[APNS] request remote notification");
        }
    }
    else {
        NSUInteger settingFlags = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:settingFlags];
    }
}

+ (void)successRegister:(NSData*)token {
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSString *settedString = [[NSString stringWithFormat:@"%@", token] stringByTrimmingCharactersInSet:charSet];
    _deviceToken = [settedString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"[APNS] register token %@", _deviceToken);
    /*
     무조건 서버로 전송해서 등록    하는 로직을 추가하자.
     Device 가 바뀌는 경우가 생길 수 있다.
     */
}

+ (NSString*)deviceToken {
    return _deviceToken;
}

+ (void)increateBadgeNumber {
    NSUInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [UIApplication sharedApplication].applicationIconBadgeNumber = ++badgeNumber;
    NSLog(@"[APNS] Inactive, badge number %ud", badgeNumber);
}

+ (void)failRegister:(NSError*)error {
    NSLog(@"[APNS] register fail : %@", [error localizedDescription]);
    _deviceToken = nil;
}

+ (void)receiveNotification:(NSDictionary*)userInfo {
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        [APNSService increateBadgeNumber];
    }
    else {
        NSLog(@"[APNS] Active, badge number : %ud", [UIApplication sharedApplication].applicationIconBadgeNumber);
    }
}

+ (void)clearBadgeNumber {
    if([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

@end
