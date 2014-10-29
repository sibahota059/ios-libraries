//
//  ClickableUIView.m
//
//  Created by breaklee on 2014. 10. 10..
//

#import "ClickableUIView.h"

@implementation ClickableUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleFingerTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleFingerTap];
    }
    return self;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if(self.onClicked) {
        self.onClicked(recognizer);
    }
}

@end
