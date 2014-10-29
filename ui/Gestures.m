//
//  Gestures.m
//
//  Created by breaklee on 2014. 10. 24..
//

#import "Gestures.h"

@interface Gestures()<UIGestureRecognizerDelegate>


@end

/*
 UITapGestureRecogniger
 UIPinchGestureRecognizer
 UIRotationGestureRecognizer
 
 UIPanGestureRecognizer
 UISwipeGestureRecognizer
 UISwipeGestureRecognizer
 UILongPressGestureRecognizer
 */


@implementation Gestures

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

+ (void)singleTouchGestures:(UIViewController *)target view:(UIView*)view selector:(SEL)action {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
//    tapRecognizer.delegate = self;
    [view addGestureRecognizer:tapRecognizer];
}

+ (void)doubleTouchGestures:(UIViewController *)target view:(UIView*)view selector:(SEL)action {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [tapRecognizer setNumberOfTapsRequired:2];
    //    tapRecognizer.delegate = self;
    [view addGestureRecognizer:tapRecognizer];
    //    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
}


    //    UIPinchGestureRecognizer *soloPinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(myGestureViewSoloPinched:)];
    //    [_myGestureView addGestureRecognizer:soloPinchRecognizer];
    //    [[self view] addGestureRecognizer:soloPinchRecognizer];
    
    //    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(myGestureViewPinched:)];
    //    [pinchRecognizer setDelegate:self];
    //    [self.myGestureView addGestureRecognizer:pinchRecognizer];
    //
    //    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(myGestureViewRotated:)];
    //    [rotateRecognizer setDelegate:self];
    //    [self.myGestureView addGestureRecognizer:rotateRecognizer];

/*
 
 @property (nonatomic, assign) CGFloat scaleFactor;
 @property (nonatomic, assign) CGFloat rotationFactor;
 @property (nonatomic, assign) CGFloat currentScaleDelta;
 @property (nonatomic, assign) CGFloat currentRotationDelta;
 
 
 - (void)myGestureViewSoloPinched:(UIPinchGestureRecognizer *)pinchGesture {
 CGFloat pinchScale = [pinchGesture scale];
	CGAffineTransform scaleTransform = 	CGAffineTransformMakeScale(pinchScale, pinchScale);
	[self.myGestureView setTransform:scaleTransform];
 }
 
 - (void)updateViewTransformWithScaleDelta:(CGFloat)scaleDelta andRotationDelta:(CGFloat)rotationDelta;
 {
 if (rotationDelta != 0) {
 [self setCurrentRotationDelta:rotationDelta];
 }
 if (scaleDelta != 0) {
 [self setCurrentScaleDelta:scaleDelta];
 }
 CGFloat scaleAmount = [self scaleFactor]+[self currentScaleDelta];
 CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scaleAmount, scaleAmount);
 
 CGFloat rotationAmount = [self rotationFactor]+[self currentRotationDelta];
 CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(rotationAmount);
 
 CGAffineTransform newTransform = CGAffineTransformConcat(scaleTransform, rotateTransform);
 [self.myGestureView setTransform:newTransform];
 }
 
 - (void)myGestureViewPinched:(UIPinchGestureRecognizer *)pinchGesture {
 CGFloat newPinchDelta = [pinchGesture scale] - 1; //scale starts at 1.0
 [self updateViewTransformWithScaleDelta:newPinchDelta andRotationDelta:0];
 if ([pinchGesture state] == UIGestureRecognizerStateEnded) {
 [self setScaleFactor:[self scaleFactor] + newPinchDelta];
 [self setCurrentScaleDelta:0.0];
 }
 }
 
 - (void)myGestureViewRotated:(UIRotationGestureRecognizer *)rotateGesture {
 CGFloat newRotateRadians = [rotateGesture rotation];
 
 [self updateViewTransformWithScaleDelta:0.0 andRotationDelta:newRotateRadians];
 if ([rotateGesture state] == UIGestureRecognizerStateEnded) {
 CGFloat saveRotation = [self rotationFactor] + newRotateRadians;
 [self setRotationFactor:saveRotation];
 [self setCurrentRotationDelta:0.0];
 }
 }

 */
@end
