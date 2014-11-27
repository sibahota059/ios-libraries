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
 [self needsToDisplay] 호출 시, runloop 에서 모든 뷰의 drawRect 를 호출.
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialize];        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initialize];
    }
    return self;
}

- (void) initialize {
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleFingerTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if(self.onClicked) {
        self.onClicked(recognizer);
    }
}

@end
