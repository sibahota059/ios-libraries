//
//  RoundedButton.m
//
//  Created by breaklee on 2014. 10. 16..
//

#import "RoundedButton.h"

@implementation RoundedButton

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

- (void) configureButton {
    [self setTitle:@"Login" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateHighlighted];
    [self setColor: [UIColor colorWithRed:0/255.f green:166/255.f blue:162/255.f alpha:1.0f]];
}

- (void) setColor:(UIColor*)color {
    CGRect fillRect = CGRectMake(0, 0, 11.0, 40.0);
    UIEdgeInsets capInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    UIImage *mainImage;
    
    UIGraphicsBeginImageContextWithOptions(fillRect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:fillRect cornerRadius:3.0].CGPath);
    CGContextClip(context);
    CGContextFillRect(context, fillRect);
    mainImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setBackgroundImage:[mainImage resizableImageWithCapInsets:capInsets] forState:UIControlStateNormal];
}

@end
