//
//  LoginManager.h
//
//  Created by breaklee on 5/18/14.
//
//

#define SESSION_LOGOUT          @""
#define SESSION_FACEBOOK_TAG    1
#define SESSION_GOOGLE_TAG      2

#define SESSION_TYPE_KEY    @"SessionTypeKey"
#define SESSION_STATE       @"SessionState"

#define CATEGORIES          @"Categories"
#define SESSION_FACEBOOK    @"Facebook"
#define SESSION_GOOGLE      @"Google"

typedef NS_OPTIONS(NSUInteger, SessionStateType) {
    SS_LOGOUTED,
    SS_LOGINED,
    SS_OPENING,
    SS_CACHED
} ;

typedef void (^SessonStateHandler) (SessionStateType opened);


@protocol SessionManagerDelegate
- (void)session:(id)sender changed:(SessionStateType)type;
@end

@protocol BaseSessionManager

@required
- (void)signIn:(SessonStateHandler)handler;
- (void)signOut;
- (void)handleDidBecomeActive;
- (BOOL)handleOpenURL:(NSURL*)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)sessionLoad:(SessonStateHandler)handler;
- (void)sessionIsOpened:(SessonStateHandler)handler;
- (void)sessionIsCached:(SessonStateHandler)handler;

@property (weak,nonatomic) id<SessionManagerDelegate> delegate;

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *imagePath;

@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSString *token;

@end

@interface SessionManager : NSObject

+ (id<BaseSessionManager>)sharedSessionManager;
+ (void)setManager:(NSString*)sessionType;

@end

