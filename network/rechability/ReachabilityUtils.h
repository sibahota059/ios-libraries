//
//  ReachabilityUtils.h
//  MRProgress
//
//  Created by breaklee on 9/19/14.
//  Copyright (c) 2014 Marius Rackwitz. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef void (^RetryBlock)();

@interface ReachabilityUtils : NSObject

+ (BOOL)isInternetReachable;

+ (void)showAlertNoInternetConnection;

+ (void)showAlertNoInternetConnectionWithRetryBlock:(RetryBlock) block;


@end
