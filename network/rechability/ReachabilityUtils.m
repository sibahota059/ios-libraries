//
//  ReachabilityUtils.m
//  stoker
//
//  Created by breaklee on 7/30/14.
//  Copyright (c) 2014 zzolgit. All rights reserved.
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"인터넷 연결 안됨", @"")
                                                        message:NSLocalizedString(@"현제 인터넷이 Offline 상태 입니다..", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"확인", @"")
                                              otherButtonTitles:nil];
    if (self.block) {
        [alertView addButtonWithTitle:NSLocalizedString(@"재시도?", @"")];
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
