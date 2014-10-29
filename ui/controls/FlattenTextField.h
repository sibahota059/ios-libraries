//
//  FlattenTextField.h
//  alo-test
//
//  Created by breaklee on 2014. 10. 16..
//  Copyright (c) 2014년 wescan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlattenTextField : UITextField

@property (nonatomic) UIEdgeInsets textInsets;
@property (nonatomic) BOOL showTopLineSeperator;
@property (nonatomic) BOOL showSecureTextEntryToggle;

- (instancetype)initWithLeftViewImage:(UIImage *)image;

@end
