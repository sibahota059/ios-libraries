//
//  FacebookLoginManager.h
//
//  Created by breaklee on 5/24/14.
//
//

#import "SessionManager.h"
#import "DefaultSessionManager.h"

#ifdef SESSION_FACEBOOK_SUPPORT

@interface FacebookSessionManager : DefaultSessionManager

+ (id<BaseSessionManager>)sharedSessionManager;

- (void)signIn:(SessonStateHandler)handler;
- (void)signOut;

- (void)sessionLoad:(SessonStateHandler)handler;
- (void)sessionIsOpened:(SessonStateHandler)handler;
- (void)sessionIsCached:(SessonStateHandler)handler;

- (void)handleDidBecomeActive;
- (BOOL)handleOpenURL:(NSURL*)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (NSString*) type;
- (NSString*) token;
@end

#endif//SESSION_FACEBOOK_SUPPORT