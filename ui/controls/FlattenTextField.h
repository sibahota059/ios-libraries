//
//  FlattenTextField.h
//
//  Created by breaklee on 2014. 10. 16..
//

#import <UIKit/UIKit.h>

@interface FlattenTextField : UITextField

@property (nonatomic) UIEdgeInsets textInsets;
@property (nonatomic) BOOL showTopLineSeperator;
@property (nonatomic) BOOL showSecureTextEntryToggle;

- (instancetype)initWithLeftViewImage:(UIImage *)image;

@end
