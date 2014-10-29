//
//  textButton.m
//
//  Created by breaklee on 2014. 10. 16..
//

#import "TextButton.h"
#import <objc/runtime.h>

@implementation TextButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self configureButton];
    }
    return self;
}

- (void)sizeToFit {
    [super sizeToFit];
    
    CGRect frame = self.frame;
    frame.size.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right;
    self.frame = frame;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    size.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right;
    return size;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
//    [super setTitleColor:color forState:state];
    UIColor *co = [color colorWithAlphaComponent:0.4];
    [super setTitleColor:color forState:UIControlStateNormal];
    [super setTitleColor:co forState:UIControlStateDisabled];
    [super setTitleColor:co forState:UIControlStateHighlighted];
    
}

- (void)configureButton {
    self.titleLabel.minimumScaleFactor = 10.0/15.0;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15.0, 0, 15.0)];
    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateHighlighted];
    
}

@end
