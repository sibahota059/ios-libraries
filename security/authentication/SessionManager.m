//
//  LoginManager.m
//
//  Created by breaklee on 5/18/14.
//
//

#import "SessionManager.h"
#import "FacebookSessionManager.h"
#import "GooglePlusSessionManager.h"

@implementation SessionManager

+ (void)setManager:(NSString*)sessionType {
    [[NSUserDefaults standardUserDefaults] setObject:sessionType forKey:SESSION_TYPE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id<BaseSessionManager>) sharedSessionManager {
    id<SessionManagerDelegate> delegate = (id<SessionManagerDelegate>)[UIApplication sharedApplication].delegate;
    id<BaseSessionManager> manager;    
    NSString *typeName = [[NSUserDefaults standardUserDefaults] objectForKey:SESSION_TYPE_KEY];
    if([typeName isEqualToString:SESSION_FACEBOOK]) {
#ifdef SESSION_FACEBOOK_SUPPORT
        manager = [FacebookSessionManager sharedSessionManager];
#endif//SESSION_FACEBOOK_SUPPORT
    }
    else if([typeName isEqualToString:SESSION_GOOGLE]) {
#ifdef SESSION_GOOGLE_SUPPORT
        manager = [GooglePlusSessionManager sharedSessionManager];
#endif//SESSION_GOOGLE_SUPPORT
    }
    else {
        manager = [DefaultSessionManager sharedSessionManager];
    }
    manager.delegate = delegate;
    return manager;
}

@end
