//
//  AttributeText.h
//  alo
//
//  Created by breaklee on 2014. 10. 27..
//  Copyright (c) 2014년 wescan. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const defaultTokenName;

typedef void (^FoundStrBlock)(NSString* string);

@interface CustomTextView : UITextView

@property (nonatomic, strong) FoundStrBlock block;

@end

@interface AttributeText : NSObject

- (id)initWithFrame:(CGRect)frame;
- (CustomTextView*)viewWithString:(NSString*)string;

+ (UIFont*)systemUserFont;
- (void)setTokenAndAttr:(NSDictionary*)dic;
+ (void)setDetector:(UITextView*)textView;
+ (void)setExclusionTextView:(UITextView*)view frame:(CGRect)rect;

@end

