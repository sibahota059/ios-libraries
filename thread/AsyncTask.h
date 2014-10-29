//
//  AsyncTask.h
//
//  Created by breaklee on 2014. 10. 27..
//

#import <Foundation/Foundation.h>

typedef void (^NormalTask)();

@interface AsyncTask : NSObject

+ (void)executeBackground:(NormalTask) task;
+ (void)executeSerialBackground:(NSArray*) normalTasks;
+ (void)executeSingleBackground:(NormalTask)processBlock completion:(NormalTask) completeBlock;
+ (void)executeCuncurencyBackground:(NSArray*)normalTasks completion:(NormalTask) completeBlock;

@end
