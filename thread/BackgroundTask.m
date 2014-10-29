//
//  BackgroundTask.m
//
//  Created by breaklee on 2014. 10. 23..
//

#import "BackgroundTask.h"


@interface BackgroundTask() {
    UIBackgroundTaskIdentifier _bTask;
    BackgroundTaskBlock _processBlock;
    BackgroundTaskBlock _completedBlock;
}

@end

@implementation BackgroundTask

- (BOOL)avaliable {
    UIDevice *device = [UIDevice currentDevice];
    return [device isMultitaskingSupported];
}

- (BOOL)isRunning {
    return  (_bTask != UIBackgroundTaskInvalid);
}

- (void)executeBackground:(BackgroundTaskBlock)processBlock completedBlock:(BackgroundTaskBlock) compeletedBlock {
    if([self isRunning]) {
        return;
    }
    _processBlock = processBlock;
    _completedBlock = compeletedBlock;
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(background, ^ {
        [self backgroundProcess];
    });
}

-(void)backgroundProcess {
    _bTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^ {
        [[UIApplication sharedApplication] endBackgroundTask:_bTask];
        _bTask = UIBackgroundTaskInvalid;
        
        if(_completedBlock) {
            _completedBlock();
        }
    }];
    
    if(_processBlock) {
        _processBlock();
    }
    
    [[UIApplication sharedApplication] endBackgroundTask:_bTask];
    _bTask = UIBackgroundTaskInvalid;
}

@end
