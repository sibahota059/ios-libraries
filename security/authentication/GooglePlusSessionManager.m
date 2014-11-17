//
//  GooglePlusSessionManager.m
//
//  Created by breaklee on 2014. 10. 20..
//

/*
 presquites
 1. add properties to plist file
 - FacebookAppID         : 309907225867548
 - FacebookDisplayName   : app name
 - URL Types
     URL Schemes         : app identifier ( com.sample.test )
     Identifier          : app identifier ( com.sample.test )
 
 2. #define kClientId = @"google app CLIENT ID in developer console";
 
 2. add 'Other Linker Flags" -ObjC
 
 4. add GooglePlus.framework, GoogleOpenSource.framework
        ios framework :
            Addressbook,    AssetsLibrary,  Foundation,     CoreLocation,   CoreMotion,
            CoreGraphics,   CoreText,       MediaPlayer,    Security,       SystemConfiguration
            UIKit
 
 5. add framework Search Path to google framework.
 */

#ifdef SESSION_GOOGLE_SUPPORT

#import "GooglePlusSessionManager.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface GooglePlusSessionManager()<GPPSignInDelegate> {
    SessonStateHandler _loginHandler;
}

@end

@implementation GooglePlusSessionManager

- (NSString*)type {
    return SESSION_GOOGLE;
}

- (NSString*)token {
    return [GPPSignIn sharedInstance].authentication.accessToken;
}

+ (id<BaseSessionManager>)sharedSessionManager {
    NSLog(@"Google : %@", NSStringFromSelector(_cmd));
    static GooglePlusSessionManager *googlePlusManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        if(googlePlusManager == nil) {
            googlePlusManager = [[GooglePlusSessionManager alloc] init];
            
            GPPSignIn *signIn = [GPPSignIn sharedInstance];
            signIn.shouldFetchGooglePlusUser = YES;
            signIn.shouldFetchGoogleUserEmail = YES;

            signIn.clientID = kClientId;
            
            signIn.scopes = @[kGTLAuthScopePlusLogin, kGTLAuthScopePlusUserinfoEmail, kGTLAuthScopePlusUserinfoProfile];
            signIn.delegate = googlePlusManager;
        }
    });
    return googlePlusManager;
}

- (void)handleDidBecomeActive {
    NSLog(@"Google : %@", NSStringFromSelector(_cmd));
}

- (void)signIn:(SessonStateHandler)handler {
    NSLog(@"Google : %@", NSStringFromSelector(_cmd));    
    [[GPPSignIn sharedInstance] authenticate];
    _loginHandler = handler;
}

- (void)signOut {
    NSLog(@"Google : %@", NSStringFromSelector(_cmd));
    [[GPPSignIn sharedInstance] signOut];
    if ([(id)self.delegate respondsToSelector:@selector(session:changed:)]) {
        [self.delegate session:self changed:SS_LOGOUTED];
    }
}

- (void)sessionLoad:(SessonStateHandler)handler {
    NSLog(@"Google : %@", NSStringFromSelector(_cmd));
    [[GPPSignIn sharedInstance] trySilentAuthentication];
    _loginHandler = handler;
}

- (void)sessionIsOpened:(SessonStateHandler)handler {
    NSLog(@"Google : %@, opened : %d", NSStringFromSelector(_cmd), ([[GPPSignIn sharedInstance] authentication] != nil));
    if(handler) {
        GTMOAuth2Authentication *auth = [[GPPSignIn sharedInstance] authentication];
        SessionStateType type = (auth != nil) ? SS_LOGINED : SS_LOGOUTED;
        handler(type);
    }
}

- (void)sessionIsCached:(SessonStateHandler)handler {
    NSLog(@"Google : %@", NSStringFromSelector(_cmd));
    if(handler) {
        SessionStateType type = [[GPPSignIn sharedInstance] hasAuthInKeychain] ? SS_CACHED : SS_LOGOUTED;
        handler(type);
    }
}

- (BOOL)handleOpenURL:(NSURL*)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Google : %@, url : %@", NSStringFromSelector(_cmd), url);
    return [[GPPSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Google : %@, error : %@", NSStringFromSelector(_cmd), error);
    NSLog(@"Received error %@ and auth object %@",error, auth);    
    if (error) {
        self.email = nil;
        self.imagePath = nil;
    } else {
        
        if([GPPSignIn sharedInstance].googlePlusUser.birthday == nil) {
//            GTLPlusPerson *user = [GPPSignIn sharedInstance].googlePlusUser;
//            GTLPlusPersonAgeRange * ragne = user.ageRange;
        }
        
        self.email = [GPPSignIn sharedInstance].userEmail;
        self.imagePath = [GPPSignIn sharedInstance].googlePlusUser.image.url;
    }
    
    if(_loginHandler) {
        SessionStateType type = (error == nil) ?  SS_LOGINED : SS_LOGOUTED;
        _loginHandler(type);
    }
    
    if ([(id)self.delegate respondsToSelector:@selector(session:changed:)]) {
        [self.delegate session:self changed: (error == nil) ? SS_LOGINED : SS_LOGOUTED];
    }
}

- (void)didDisconnectWithError:(NSError *)error {
    NSLog(@"Google : %@, error : %@", NSStringFromSelector(_cmd), error);
    if (error) {
        NSLog(@"Received error %@", error);
    }
    else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
}

//- (void)disconnect {
//    [[GPPSignIn sharedInstance] disconnect];
//}

@end

#endif//SESSION_GOOGLE_SUPPORT