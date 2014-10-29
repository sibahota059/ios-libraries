ios-libraries
=============


---
# authentication

    facebook, google login wrapper
    this source is facebook, google ( or something ) api wrapper

``` objective-c
	#import "SessionManager.h"

	@interface AppDelegate : UIResponder <UIApplicationDelegate, SessionManagerDelegate>
	- (void)session:(id)sender changed:(SessionStateType)type;
	@end
```


``` objective-c
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	    [[SessionManager sharedSessionManager] sessionLoad:^(BOOL opened) {
	    }];
	    return YES;
	}

	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	    return [[SessionManager sharedSessionManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
	}

	- (void)applicationWillEnterForeground:(UIApplication *)application {
	    [[SessionManager sharedSessionManager] sessionIsOpened:^(BOOL opened) {
	        SessionStateType type = opened ? SS_LOGINED : SS_LOGOUTED;
	        [[NSUserDefaults standardUserDefaults] setInteger:type forKey:SESSION_STATE];
	        [[NSUserDefaults standardUserDefaults] synchronize];
	    }];
	}

	- (void)applicationDidBecomeActive:(UIApplication *)application {
	    [APNSService registerSettings];
	    [APNSService clearBadgeNumber];
	    [[SessionManager sharedSessionManager] handleDidBecomeActive];
	}

	- (void)session:(id)sender changed:(SessionStateType)type {
	    NSLog(@"AppDelegate : %@, changed : %d", NSStringFromSelector(_cmd), (int)type);
	    switch(type) {
	        case SS_LOGINED:
	            break;
	        case SS_LOGOUTED:
	            break;
	        default:
	            break;
	    }
	}
```
	    
