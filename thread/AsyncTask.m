//
//  AsyncTask.m
//
//  Created by breaklee on 2014. 10. 27..
//

#import "AsyncTask.h"

@implementation AsyncTask

//NSThread sleepForTimeInterval

+ (id) sharedTask {
    static AsyncTask* task;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if(task == nil) {
        task = [[AsyncTask alloc] init];
        }
    });
    return task;
}

- (void)exeuteTask:(NormalTask) task {
    if(task) {
        task();
    }
}

+ (void)executeBackground:(NormalTask) task {
    [[AsyncTask sharedTask] performSelectorInBackground:@selector(exeuteTask:) withObject:task];
//    self performSelectorOnMainThread:<#(SEL)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#>
}

+ (void)executeSingleBackground:(NormalTask)processBlock completion:(NormalTask) completeBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    
    NSBlockOperation *block = [[NSBlockOperation alloc] init];
    //block = [NSBlockOperation blockOperationWithBlock:^{}];
    
    [block addExecutionBlock:processBlock];
    [block setCompletionBlock:completeBlock];
    [queue addOperation:block];
    
//    NSInvocationOperation *op = [NSInvocationOperation alloc] initWithTarget:self selector:@selector() object:nil];
//    [op setCompletionBlock:^{}];
//    [queue addOperation:op];
}

+ (void)executeCuncurencyBackground:(NSArray*)normalTasks completion:(NormalTask) completeBlock {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = [normalTasks count];
    for(NormalTask task in normalTasks) {
        NSBlockOperation *block = [[NSBlockOperation alloc] init];
        //block = [NSBlockOperation blockOperationWithBlock:^{}];
        [block addExecutionBlock:task];
        [block setCompletionBlock:completeBlock];
        [queue addOperation:block];
    }
}

+ (void)executeSerialBackground:(NSArray*) normalTasks {
    NSMutableArray *operationsToAdd = [[NSMutableArray alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = [normalTasks count];
    NSBlockOperation *beforeOp = nil;
    for(NormalTask task in normalTasks) {
        NSBlockOperation *op = [[NSBlockOperation alloc] init];
        [op addExecutionBlock:task];
        if(beforeOp) {
            [op addDependency:beforeOp];
        }
        beforeOp = op;
        [operationsToAdd addObject:op];
    }
    
    for(NSBlockOperation *op in operationsToAdd) {
        [queue addOperation:op];
    }
}

/*
1. concurrency dispatch queue
- (void) dispatch_apply:(NormalTask)task {
    dispatch_queue_t workQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    for (int i=1; i<=5; i++)
    {
        
        NSNumber *iteration = [NSNumber numberWithInt:i];
        
        dispatch_async(workQueue, ^{
            [self performLongRunningTaskForIteration:iteration];
        });
    }
}

- (void)performLongRunningTaskForIteration:(id)iteration {
    NSNumber *iterationNumber = (NSNumber *)iteration;
    
    __block NSMutableArray *newArray =
    [[NSMutableArray alloc] initWithCapacity:10];
    
    dispatch_queue_t detailQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    dispatch_apply(10, detailQueue, ^(size_t i) {
 
                       [NSThread sleepForTimeInterval:.1];
                       
                       [newArray addObject:[NSString stringWithFormat:
                                            @"Item %@-%zu",iterationNumber,i+1]];
                       
                       NSLog(@"DispQ Concurrent Added %@-%zu",iterationNumber,i+1);
                   });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTableData:newArray];
    });
}

//2.dispatch_queue serial
- (void) dispatch_serial {
    dispatch_queue_t workQueue =
    dispatch_queue_create("com.icf.serialqueue", NULL);
    for (int i=1; i<=5; i++) {
        NSNumber *iteration = [NSNumber numberWithInt:i];
        dispatch_async(workQueue, ^{

        });
    }
}
*/
@end

//ICFCustomOperation *operation =
//[[ICFCustomOperation alloc] initWithIteration:iteration andDelegate:self];

//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//    NSLog(@"parameter1: %d parameter2: %f", parameter1, parameter2);
//});

@protocol CustomOperationDelegate <NSObject>

- (void)updateTableWithData:(NSArray *)moreData;

@end

@interface CustomOperation : NSOperation

@property (nonatomic, weak) id<CustomOperationDelegate> delegate;
@property (nonatomic, strong) NSNumber *iteration;
- (id)initWithIteration:(NSNumber *)iterationNumber andDelegate:(id)myDelegate;
@end

@implementation CustomOperation

- (id)initWithIteration:(NSNumber *)iterationNumber
            andDelegate:(id)myDelegate {
    if (self = [super init]) {
        self.iteration = iterationNumber;
        self.delegate = myDelegate;
    }
    return self;
}

- (void)main {
    NSMutableArray *newArray =
    [[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i=1; i<=10; i++) {
        if ([self isCancelled]) {
            break;
        }
        
        [newArray addObject:
         [NSString stringWithFormat:@"Item %@-%d",
          self.iteration,i]];
        
        [NSThread sleepForTimeInterval:.1];
        NSLog(@"OpQ Custom Added %@-%d",self.iteration,i);
    }
    [self.delegate updateTableWithData:newArray];
}

@end


