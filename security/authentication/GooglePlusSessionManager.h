//
//  GooglePlusSessionManager.h
//
//  Created by breaklee on 2014. 10. 20..
//

#import "DefaultSessionManager.h"

#ifdef SESSION_GOOGLE_SUPPORT
@interface GooglePlusSessionManager : DefaultSessionManager

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
#endif//SESSION_GOOGLE_SUPPORT