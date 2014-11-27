//
//  Systems.h
//
//  Created by breaklee on 2014. 10. 22..
//

@import Foundation;

@interface Systems : NSObject

+ (NSString*)documentDirectory;
+ (NSString*)uuid;
+ (NSString*)hashMD5:(NSString*)string;
+ (NSString*)hashMD5Data:(NSData*)data;

@end


/*

	NSUserDefaults 공장 초기 설정 등록
	AppDelegate +initialize {
		NSUerDefaults *shared = NSUserDefaults sharedDefaults];
		NSDictionary *dic = @{@"abc":"ded", @"sdf":@"sdfs"};
		[shared registerDefaults:dic];
		[dic intergerForKey:@""];

	}


	상태를 복원하려면 앱이 종료되기 전에 시스템은 컨트롤러들의 트리구조(각노드)를 돌면서 이름이 무엇인가
	클래스는 무엇인가 저장해야 할 데이터를 가지는가 등에 대해 알아봐야 한다.
	앱이 종료되는 동안 이 트리의 정보는 파일 시스템에 저장된다.

	기본적으로 상태복원은 비활성화 되어 있다.
	AppDelegate 에서 함수 오버라이드 하면 됨.

	- (BOOL)application:(UIApplication*)application shouldSaveApplicatioinState:(NSCorder*)coder {
		return YES;
	}

	- (BOOL)application:(UIApplication*)application shouldRestoreApplicatioinState:(NSCorder*)coder {
		return YES;
	}	

	앱의 상태가 저장될 때 윈도우의  rootViewController 에 restorationIdentifier 를 요청한다.
	루트 뷰 컨트롤러가 restorationIdentifier 를 가지고 있으면 상태를 저장하도록 요청 받는다.
	NSStringFromClass([Class class]) 로 하면 편함.
	그리고 자식 뷰 컨트롤러를 돌면서 같은 방식으로 요청 하는데 restorationIdentifier 가 없으면
	자식뷰가 restorationIdentifier 를 가지고 있다고 하더라도 저장에서 제외된다.

	view.restorationIdentifier= NSStringFromClass([Class class]);
	view.restorationClass = [self class];




*/