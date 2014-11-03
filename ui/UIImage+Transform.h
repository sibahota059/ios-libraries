//
//  UIRoundImage.h
//
//  Created by breaklee on 2014. 11. 3..
//

#import <UIKit/UIKit.h>

@interface UIImage (Transform)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)resizedImageToSize:(CGSize)size;
- (UIImage *)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

@end
