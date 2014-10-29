//
//  ClickableUIView.h
//  alo
//
//  Created by breaklee on 2014. 10. 10..
//  Copyright (c) 2014년 wescan. All rights reserved.
//

@import UIKit;

typedef void(^UIViewClickedBlock)(UITapGestureRecognizer *);

@interface ClickableUIView : UIView

@property (nonatomic, strong) UIViewClickedBlock clickedBlock;

@end
