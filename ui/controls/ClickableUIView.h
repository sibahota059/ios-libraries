//
//  ClickableUIView.h
//
//  Created by breaklee on 2014. 10. 10..
//

//typedef void(^ClickedEvent)(UITapGestureRecognizer *);

@import UIKit;

@interface ClickableUIView : UIView

@property (nonatomic, strong) ClickedEvent onClicked;

@end    
