//
//  ReachabilityUtils.h
//
//  Created by breaklee on 9/19/14.
//

@import Foundation;
@import UIKit;

typedef void (^RetryBlock)();

@interface ReachabilityUtils : NSObject

+ (BOOL)isInternetReachable;
+ (void)showAlertNoInternetConnection;
+ (void)showAlertNoInternetConnectionWithRetryBlock:(RetryBlock) block;

@end
