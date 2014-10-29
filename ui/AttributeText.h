//
//  AttributeText.h
//  alo
//
//  Created by breaklee on 2014. 10. 27..
//  Copyright (c) 2014년 wescan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttributeText : NSObject

- (id)initWithFrame:(CGRect)frame;
- (UITextView*)viewWithString:(NSString*)string;

+ (UIFont*)systemUserFont;
+ (void)setDetector:(UITextView*)textView;
+ (void)setExclusionTextView:(UITextView*)view frame:(CGRect)rect;

@end
