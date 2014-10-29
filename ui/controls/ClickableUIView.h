//
//  ClickableUIView.h
//
//  Created by breaklee on 2014. 10. 10..
//

@import UIKit;

typedef void(^ClickedEvent)(UITapGestureRecognizer *);

@interface ClickableUIView : UIView

@property (nonatomic, strong) ClickedEvent onClicked;

@end    
