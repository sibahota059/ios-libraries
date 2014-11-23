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


/*
UIResponder 는 터치와 관련된 이벤트를 받는 클래스

touchesBegan:withEvent
...
	NSSet*touches 파라미터에는 UITouch 객체가 있음.
	Begin~end 사이에서 전달되는  UITouche 파라미터는 는 새로운 객체가 아니라 업데이트 되는 객체임(주소가 같음)

	self.multipleTouchEnabled = YES // 멀티터치 제어하기


	//t 는 터치 객체
	NSValue *key = [NSValue valueWithNonretainedObject:t];
	t의 주소를 가지는 NSValue 를 반환.
	touch 이벤트 주기 내에서 이 값을 dictionary 의 키값으로 사용 가능.

	UIResponder 는 nextResponder 포인터를 가진다. 이는 리스폰더 체인을 구성한다.
	이는 보통 자신의 상위뷰나 만약 업사면 UIViewController 를 가리킨다.
	UIViewController->UIWindow->UIApplication 순이다.

	터치 이벤트는 최 하의 뷰에서 부터 일어나는데, 터치함수를 재정의 하지 않으면
	nextResponer 의 터치 이벤트를 확인한다. 최상위까지 처리가 안되면 버려진다.
	명시적으로 내 상위뷰로도 터치 이벤트를 보낼 수 있따.

	if(touch.tapCount == 2) {
		[[self nextResponder] touchesBegan:touches withEvent:event];
		return;
	}

*/