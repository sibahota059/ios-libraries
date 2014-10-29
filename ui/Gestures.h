//
//  Gestures.h
//
//  Created by breaklee on 2014. 10. 24..
//

#import <Foundation/Foundation.h>

@interface Gestures : NSObject

+ (void)singleTouchGestures:(UIViewController *)target view:(UIView*)view selector:(SEL)action;
+ (void)doubleTouchGestures:(UIViewController *)target view:(UIView*)view selector:(SEL)action;

@end
