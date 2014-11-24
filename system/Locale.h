//
//  Locale.h
//  alo
//
//  Created by breaklee on 2014. 11. 21..
//  Copyright (c) 2014년 wescan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Locale : NSObject
/*
 NSLocale *local = [NSLocale currentLocale];
 BOOL isMetric = [locale bjectForKey:NSLocaleUserMetricSystem] boolValue];
  NSString *symbol = [locale bjectForKey:NSLocaleCurrencySymbol];
 
 //로케일에 따라 숫자 표현 됨, 123.456, 123,456
 NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
 NSString *string = [numberFormatter stringFromNumber:@"1234.456"];
 
 //통화 표현법
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
 formatter.numberStyle = NSNUmberFormatterCurrencyStyle;
 NSString *string = [numberFormatter stringFromNumber:@"1234.456"];
 
 
NSCurerntLocaleDidChangeNotification // 폰의 로케일 설정이 바뀌면 노티상수
 
 [nc addObserver:self selector:notifed: name:NSCurerntLocaleDidChangeNotification object:nil];
 
 
 이미지나 xib 등 다 지역화 가능 함.
    lproj 폴더 로 구성 됨.
 
 project setting -> info 에 base localizatino 클릭하면  base.lproj 생성 됨.



 국제화를 추가하는 실제 작업은 NSBundle 클래스가 담당 함.
 뷰 컨트롤러가 뷰를 로드하면  xib 파일을 번들에 요청 함.
 적절한  lproj 디렉터리를 찾는다.

 NSBUndle pathForResource:ofType: 은 지역화가 고려된(lproj 폴더) 경로를 반환한다.
 NSString *path = [[NSBundle mainBundle] pathForResource:@"MyImage" ofType:"png"];

 최상위 번들을 확인 후 파일이 없으면 os 의 언어 설정 을 본 후 적절한 lproj 폴더를 뒤져서 반환한다 
 없으면 nil

 이래서 지역화 할 때, bundle 최상위의 파일을 지워야 하는 이유이다. xcode 등은 재설치 할 때 번들에서
 파일을 지우지 않는다. 앱 번들에 lproj 파일이 있다고 하더라도 최상위 파일을 먼저 찾기 때문에 의도치 않은 오류가 발생할 수 있다.
 
 */
@end
