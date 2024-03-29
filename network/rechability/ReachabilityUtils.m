//
//  ReachabilityUtils.m
//
//  Created by breaklee on 7/30/14.
//

#import "Reachability.h"
#import "ReachabilityUtils.h"

@interface ReachabilityAlert : NSObject <UIAlertViewDelegate>

@property(nonatomic, copy) RetryBlock block;

- (id)initWithRetryBlock:(RetryBlock) block;
- (void)show;

@end

static ReachabilityAlert *__currentReachabilityAlert = nil;

@implementation ReachabilityAlert

- (id)initWithRetryBlock:(RetryBlock) retryBlock {
    self = [super init];
    if (self) {
        self.block = retryBlock;
    }
    return self;
}

- (void)show {
    if (__currentReachabilityAlert) {
        return;
    }
    __currentReachabilityAlert = self;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Not connected to Internet", @"")
                                                        message:NSLocalizedString(@"current Offline..", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
    if (self.block) {
        [alertView addButtonWithTitle:NSLocalizedString(@"retry?", @"")];
    }
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && self.block) {
        self.block();
    }
    __currentReachabilityAlert = nil;
}

@end

@implementation ReachabilityUtils

static BOOL connectionAvailable;
static Reachability *internetReachability;

+ (BOOL)isInternetReachable {
    if(internetReachability == nil) {
        [ReachabilityUtils setupReachability];
    }
    return connectionAvailable;
}

+ (void)showAlertNoInternetConnection {
    ReachabilityAlert *alert = [[ReachabilityAlert alloc] initWithRetryBlock:nil];
    [alert show];
}

+ (void)showAlertNoInternetConnectionWithRetryBlock:(RetryBlock) retryBlock {
    ReachabilityAlert *alert = [[ReachabilityAlert alloc] initWithRetryBlock:retryBlock];
    [alert show];
}

+ (void)setupReachability {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    connectionAvailable = YES;
    
    internetReachability = [Reachability reachabilityForInternetConnection];
    
    void (^internetReachabilityBlock)(Reachability *) = ^(Reachability *reach) {
        
        NSString *wifi = reach.isReachableViaWiFi ? @"Y" : @"N";
        NSString *wwan = reach.isReachableViaWWAN ? @"Y" : @"N";
        NSLog(@"WIFI %@, WAN %@", wifi, wwan);
        
        connectionAvailable = reach.isReachable;
    };
    internetReachability.reachableBlock = internetReachabilityBlock;
    internetReachability.unreachableBlock = internetReachabilityBlock;
    
    [internetReachability startNotifier];
    connectionAvailable = [internetReachability isReachable];
    
#pragma clang diagnostic pop
}

@end
