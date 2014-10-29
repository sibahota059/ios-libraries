//
//  BackgroundTask.h
//
//  Created by breaklee on 2014. 10. 23..
//

#import <Foundation/Foundation.h>

typedef void (^BackgroundTaskBlock)();

@interface BackgroundTask : NSObject

- (BOOL)avaliable;
- (BOOL)isRunning;
- (void)executeBackground:(BackgroundTaskBlock)processBlock completedBlock:(BackgroundTaskBlock) compeletedBlock;

@end
