//
//  DefaultSessionManager.m
//
//  Created by breaklee on 5/24/14.
//
//
#import "DefaultSessionManager.h"

@implementation DefaultSessionManager

+ (id<BaseSessionManager>)sharedSessionManager {
    static DefaultSessionManager *defaultManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if(defaultManager == nil) {
            defaultManager = [[DefaultSessionManager alloc] init];
        }
    });
    return defaultManager;
}

- (void)signIn:(SessonStateHandler)handler {
    NSLog(@"warning : defaultSessionManager should be not worked!!!");
    if(handler) {
        handler(SS_LOGOUTED);
    }
}

- (void)signOut {
    NSLog(@"warning : defaultSessionManager should be not worked!!!");
}

- (void)handleDidBecomeActive {
    NSLog(@"warning : defaultSessionManager should be not worked!!!");
}

- (BOOL)handleOpenURL:(NSURL*)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    UNUSED_ARGS(url);
    UNUSED_ARGS(sourceApplication);
    UNUSED_ARGS(annotation);
    NSLog(@"warning : defaultSessionManager should be not worked!!!");    
    return YES;
}

- (void)sessionLoad:(SessonStateHandler)handler {
    NSLog(@"warning : defaultSessionManager should be not worked!!!");
    if(handler) {
        handler(SS_LOGOUTED);
    }
}

- (void)sessionIsCached:(SessonStateHandler)handler {
    NSLog(@"warning : defaultSessionManager should be not worked!!!");
    if(handler) {
        handler(SS_LOGOUTED);
    }
}

- (void)sessionIsOpened:(SessonStateHandler)handler {
    NSLog(@"warning : defaultSessionManager should be not worked!!!");
    if(handler) {
        handler(SS_LOGOUTED);
    }
}

@end
