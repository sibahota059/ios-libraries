//
//  FlattenTextField.m
//  alo-test
//
//  Created by breaklee on 2014. 10. 16..
//  Copyright (c) 2014년 wescan. All rights reserved.
//

#import "FlattenTextField.h"

@interface FlattenTextField ()

@property (nonatomic, strong) UIImage *leftViewImage;
@property (nonatomic, strong) UIButton *secureTextEntryToggle;
@property (nonatomic, strong) UIImage *secureTextEntryImageVisible;
@property (nonatomic, strong) UIImage *secureTextEntryImageHidden;

@end

@implementation FlattenTextField

- (id)init {
    self = [super init];
    if(self) {
        self.textInsets = UIEdgeInsetsMake(7, 10, 7, 10);
        self.layer.cornerRadius = 1.0;
        self.clipsToBounds = YES;
        self.showTopLineSeperator = YES;
        self.showSecureTextEntryToggle = NO;
        
        self.secureTextEntryImageVisible = [UIImage imageNamed:@""];
        self.secureTextEntryImageHidden = [UIImage imageNamed:@""];
        
        self.secureTextEntryToggle = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.secureTextEntryToggle addTarget:self action:@selector(secureTextEntryToogleAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.secureTextEntryToggle];
        [self updateSecureTextEntryToggleImage];
    }
    return self;
}

- (instancetype)initWithLeftViewImage:(id)image {
    self = [super init];
    if(self) {
        self.leftViewImage = image;
        self.leftView = [[UIImageView alloc] initWithImage:image];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    if(_showTopLineSeperator) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(CGRectGetMinX(rect) + _textInsets.left, CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
        [path setLineWidth:[[UIScreen mainScreen] scale]/2.0];
        CGContextAddPath(context, path.CGPath);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.87 alpha:1.0].CGColor);
        CGContextStrokePath(context);
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.secureTextEntryToggle.hidden = !self.showSecureTextEntryToggle;
    
    if(self.showSecureTextEntryToggle) {
        self.secureTextEntryToggle.frame = CGRectIntegral(CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.secureTextEntryToggle.frame),
                                                          (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.secureTextEntryToggle.frame)) / 2.0,
                                                          CGRectGetWidth(self.secureTextEntryToggle.frame), CGRectGetHeight(self.secureTextEntryToggle.frame)));
        [self bringSubviewToFront:self.secureTextEntryToggle];
    }
    
}

- (CGRect)calculateTextRectForBounds:(CGRect)bounds {
    
    CGRect returnRect;
    if(_leftViewImage) {
        CGFloat leftViewWidth = _leftViewImage.size.width;
        returnRect = CGRectMake(leftViewWidth + 2 * _textInsets.left, _textInsets.top, bounds.size.width - leftViewWidth - 2 * _textInsets.left - _textInsets.right, bounds.size.height - _textInsets.top - _textInsets.bottom);
    }
    else {
        returnRect = CGRectMake(_textInsets.left, _textInsets.top, bounds.size.width - _textInsets.right, bounds.size.height - _textInsets.top - _textInsets.bottom);
    }
    
    if(self.showSecureTextEntryToggle) {
        returnRect.size.width -= self.secureTextEntryToggle.frame.size.width;
    }
    return CGRectIntegral(returnRect);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self calculateTextRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self calculateTextRectForBounds:bounds];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    if(_leftViewImage) {
        return CGRectIntegral(CGRectMake(_textInsets.left, (CGRectGetHeight(bounds) - _leftViewImage.size.height)/2.0, _leftViewImage.size.width, _leftViewImage.size.height));
    }
    
    return [super leftViewRectForBounds:bounds];
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    [super setSecureTextEntry:secureTextEntry];
    [self updateSecureTextEntryToggleImage];
}

- (void)secureTextEntryToogleAction:(id)sender {
    [self setSecureTextEntry:!self.isSecureTextEntry];
    self.text = self.text;// cursor pos change
    [self setNeedsDisplay];
}


-(void)updateSecureTextEntryToggleImage {
 
    UIImage *image = self.isSecureTextEntry ? self.secureTextEntryImageHidden : self.secureTextEntryImageVisible;
    [self.secureTextEntryToggle setImage:image forState:UIControlStateNormal];
}

@end
