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
 UILongPressGestureRecognizer
    기본은 0.5 초 인데, 시간설정 가능 :minimumPressDuration 설정.

    UILongPressGestureRecognizer *recog = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@seldctor];


    - (void)longPress:(UIGestureRecognizer*)recoginizer {

        if(recognizer.state == UIGEstureREcognizerStateBegan) {
    
        }
        else if(recognizer.state == UIGEstureREcognizerStateEnded) {
        }    
    }

UIPanGestureRecognizer
    롱제스처 후에 드래그로 이동하게 하려면 필요한 제스처 객체
    일반적으로 제스처인식기는 한번 인식되면 터치정보를 공유하지 않기 때문에,
    두개의 터치제스처가 인식할 방법이 필요하다.

    UIGestureRecognizerDelegate 의 
    gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer
    를 YES 로 재정의 하면 터치를 공유할 수 있다.

    UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selctor()];
    move.delegate = self;
    //제스처가 인식하느 터치를 먹겠다(YES) 다중으로 인식하려면 NO
    move.cancelsTouchesInView = NO;
    [self addRecognizer:move]

    - (void)moveLine:(UIPanGestureRecognizer*)rg {
    
        //펜의 위치가 변하면.    
        if(gr.state == UIGestureRecognizerStateChanged) {

    //  마지막 이후에 변경된 값을 알리기 위한 제스처 인식기가 필요한데, 
        변경을 알릴 때마다 제스처 인식기의 이동값을 제로로 설정함( 이해가 안되는데 우선 기록;ㅁ;)
            [gr setTranslation:CGPointZero inView:self];
        }

    }

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
    /*
        이때 UIResponder 의 touchesBegan:withEvent: 가 처음에 호출된다.
        이를 막기 위해서는
        tapRecognizer.delaysTouchesBegan = YES; 를 해줘야 함.


    */
    //    tapRecognizer.delegate = self;
    [view addGestureRecognizer:tapRecognizer];
    /*
        멀티 탭 제스처를 붙였을 경우, (텝, 더블텝) 더블텝을 인식할 경우, 탭도 같이 호출 된다.
        이를 막기 위해서는 아래와 같은 코드가 필요함.
    */
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
