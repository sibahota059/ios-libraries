//
//  DefaultSessionManager.h
//
//  Created by breaklee on 5/24/14.
//
//

#import "SessionManager.h"

@interface DefaultSessionManager : NSObject<BaseSessionManager>

@property (weak,nonatomic) id<SessionManagerDelegate> delegate;

+ (id<BaseSessionManager>)sharedSessionManager;

- (void)handleDidBecomeActive;
- (BOOL)handleOpenURL:(NSURL*)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (void)signIn:(SessonStateHandler)handler;
- (void)signOut;
- (void)sessionLoad:(SessonStateHandler)handler;
- (void)sessionIsOpened:(SessonStateHandler)handler;
- (void)sessionIsCached:(SessonStateHandler)handler;

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *imagePath;

@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSString *token;

@end