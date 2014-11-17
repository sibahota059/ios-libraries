//
//  FacebookLoginManager.m
//
//  Created by breaklee on 5/24/14.
//
//

/*
presquites
    1. add properties to plist file
        - FacebookAppID         : 309907225867548
        - FacebookDisplayName   : app name
        - URL Types
            URL Schemes         : fb309907225867548
 
    2. define required to pch or others
        #define UNUSED_ARGS(X) (X);
 
    3. add 'Other Linker Flags" -ObjC
 
    4. add FacebookSDK.framework to project
 
    5. add framework Search Path to facebooks
*/

#ifdef SESSION_FACEBOOK_SUPPORT

#import "FacebookSessionManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookSessionManager()<FBLoginViewDelegate> {
    
}

@end

@implementation FacebookSessionManager

+ (id<BaseSessionManager>)sharedSessionManager {
    NSLog(@"Facebook : %@", NSStringFromSelector(_cmd));
    static FacebookSessionManager *facebookManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        if(facebookManager == nil) {
            facebookManager = [[FacebookSessionManager alloc] init];
        }
    });
    return facebookManager;
}

- (NSString*)type {
    return SESSION_FACEBOOK;
}

- (NSString*)token {
    return [FBSession activeSession].accessTokenData.accessToken;
}

- (void)handleDidBecomeActive {
    NSLog(@"Facebook : %@", NSStringFromSelector(_cmd));
    [FBAppCall handleDidBecomeActive];    
}

- (BOOL)handleOpenURL:(NSURL*)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Facebook : %@, url : %@", NSStringFromSelector(_cmd), url);
    UNUSED_ARGS(sourceApplication);
    UNUSED_ARGS(annotation);
    return [FBSession.activeSession handleOpenURL:url];    
}

- (void)sessionStateChanged:(FBSessionState) state
                      error:(NSError *)error {
    NSLog(@"Facebook : %@, state : %d", NSStringFromSelector(_cmd), state);
    self.email = nil;
    self.imagePath = nil;
    
    if (!error && state == FBSessionStateOpen) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            } else {
                self.imagePath = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", [user objectForKey:@"id"]];
                self.email = [user objectForKey:@"email"];
            }
            
            NSLog(@"Facebook session opened %d", state);
            [[NSUserDefaults standardUserDefaults] setInteger:SS_LOGINED forKey:SESSION_STATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if ([(id)self.delegate respondsToSelector:@selector(session:changed:)]) {
                [self.delegate session:self changed:SS_LOGINED];
            }
        }];
        
        return;
    }
    
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
        NSLog(@"Facebook session closed");
        [[NSUserDefaults standardUserDefaults] setInteger:SS_LOGOUTED forKey:SESSION_STATE];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:SESSION_TYPE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([(id)self.delegate respondsToSelector:@selector(session:changed:)]) {
            [self.delegate session:self changed:SS_LOGOUTED];
        }
    }
    
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        }
        else {
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
            }
            else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
            }
            else {
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }        
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

- (void)sessionLoad:(SessonStateHandler)handler {
    NSLog(@"Facebook : %@", NSStringFromSelector(_cmd));
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_birthday"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:state error:error];
                                      }];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:SESSION_TYPE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(handler) {
            handler(SS_LOGOUTED);
        }
    }
}

- (void)sessionIsCached:(SessonStateHandler)handler {
    NSLog(@"Facebook : %@", NSStringFromSelector(_cmd));
    if(handler) {
        SessionStateType type = SS_LOGINED;
        if(FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded &&
           FBSession.activeSession.state != FBSessionStateOpen) {
            type = SS_CACHED;
        }
        handler(type);
    }
}

- (void)sessionIsOpened:(SessonStateHandler)handler {
    FBSessionState state = FBSession.activeSession.state;
    NSLog(@"Facebook : %@, opened : %d, %d", NSStringFromSelector(_cmd), (state == FBSessionStateOpen), state);
    if(handler) {
        
        SessionStateType type = SS_LOGOUTED;
        if(state == FBSessionStateCreatedOpening) {
            type = SS_OPENING;
        }
        else if(state == FBSessionStateOpen) {
            type = SS_LOGINED;
        }
        handler(type);
    }
}

- (void)signOut {
    NSLog(@"Facebook : %@", NSStringFromSelector(_cmd));
    if (FBSession.activeSession.state == FBSessionStateOpen ||
        FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

- (void)signIn:(SessonStateHandler)handler {
    NSLog(@"Facebook : %@", NSStringFromSelector(_cmd));
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_birthday"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      [self sessionStateChanged:state error:error];
                                      if(handler) {
                                          SessionStateType type = SS_LOGOUTED;
                                          if(state == FBSessionStateCreatedOpening) {
                                              type = SS_OPENING;
                                          }
                                          else if(state == FBSessionStateOpen) {
                                              type = SS_LOGINED;
                                          }
                                          handler(type);
                                      }
                                  }];
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

@end

#endif//SESSION_FACEBOOK_SUPPORT