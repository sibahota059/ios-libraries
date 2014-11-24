//
//  UIRoundImage.m
//
//  Created by breaklee on 2014. 11. 3..
//

#import "UIImage+Transform.h"

/*

 setNeedsDisplayInRect:
 setNeedsDisplay 는 runloop 로 하여금, drawRect 를 다시 그리게끔 함.
 drawRect  or 다른 UI 를 수정했으면 setNeedsDisplay 를 호출해서 갱신할 수 있도록 해야 함.
 
 
 viewController 는 view 를 설정하기 위해 loadView 함수가 있다.
 (뭔가 수정하려면 loadView 함수를 오버라이드 )
 viewController 가 만들어 질때 self.view 가 nil 이면 loadView 를 호출한다.
 
 UIResponder. 사용자 반응과 관련된 deletage.
 사용자가 컨트로를 선택하면 window.firstResponder 를 해당 컨트롤로 셋팅한다.
 textfield나 textView 가 firstResponser 가 되면, keyboard 가 올라온다.
 becomeFirstResponser -> 해당 컨트로를 firstResp[onser 로 만들기
 resignFirstResponder -> firstReponser 해제
 
 실글톤 제작시 방어 코드
 - (instancetype) init {
 @throw [NSException exceptionWithName:@"singleton" reason:@"use sharedStore" userInfo:nil];
 }

 UITableViewCell 코드 등록(identifier)
 self.tableView registerClass : [[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
 

  - (void)viewDidLayoutSubviews {
   for(UIview *subview in self.view.subviews) {
      if([subview hasAmbiguouseLayout]) {
    /// 이상한 레이아웃 임, exersiseAmbiguityInLayout] 호출하면 여러가지 가능성에 대한것을 동적으로 바꿔줌(터치이벤트랑 묶어서 디버그용으로 사용 )
      }
    }
 }
 
 
 오토레이아웃 코딩 시
  오토리사이즈마스크와 함께 동작해야만 한다. 그래서 충돌이 날 수 있는데, translateAutoresizingMaskIntoConstraints = NO 로 설정해서변환을 막는다.
 translateAutoresizingMaskIntoConstraints 는 같은 뷰와는 상관없고, 상위뷰와의 관계를 정의.
 기본적으로 뷰는 이 마스크를 이용해 관계를 추가함. 이러한 변환조건들이 직접 추가된 제약조건과 충돌할 수 있음. 그래서 NO로 설정해줘야 함.
   @:"H|-0-[imageView]-0-|"
    0은 생략 가능 , "H:|[imageview]|", - 기본값은 8
 
  @"V:[someVIew(==50)]" height 은 50
 
 
 NSDictionary *map = @{@"imageView":self.imageView, @"datalabel":self.datalabel};
 NSArray *horizontalConstrainst = NSLayoutConstraint constraintWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
 
 제약사항을 받아야 할 view 결정하는 조건
   // addConstrainsts:
    1. 제약조건이 상위뷰가 같은 두 뷰에 조건을 걸면 상위뷰에 추가
    2. 단 하나에만 적용되면 해당뷰에 추가
    3. 바로 위의 상위뷰는 다르지만 더 높은 조상의 공통 뷰가 있으면 거기에 추가.
    4. 해당 뷰와 상위뷰에 영향을 주면 상위뷰에 추가

 
 비율 기반 레이아웃은 VFL 을 사용할 수 없다.
 NSLayoutConstrant 인스턴스를 만들 수 있다. constraintWithItem:attribute:relateBy:toItem:attribute:multiplier:constant:
   두 뷰 객체의 두 레이아웃 속성을 이용해 하나의 제약조건을 만든다.
   multiplier 인자가 비율 기반의 제약조건을 만드는 핵심임
 
 
 
 */

@implementation UIImage (Transform)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)resizedImageToSize:(CGSize)size {
    CGImageRef imgRef = self.CGImage;
    CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    
    if (CGSizeEqualToSize(srcSize, size)) {
        return self;
    }
    
    CGFloat scaleRatio = size.width / size.width;
    UIImageOrientation orient = self.imageOrientation;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch(orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            size = CGSizeMake(size.height, size.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            size = CGSizeMake(size.height, size.width);
            transform = CGAffineTransformMakeTranslation(0.0, size.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            size = CGSizeMake(size.height, size.width);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            size = CGSizeMake(size.height, size.width);
            transform = CGAffineTransformMakeTranslation(size.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil;
    }
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -srcSize.height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -srcSize.height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale {

    CGImageRef imgRef = self.CGImage;
    CGSize srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    
    UIImageOrientation orient = self.imageOrientation;
    switch (orient) {
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            boundingSize = CGSizeMake(boundingSize.height, boundingSize.width);
            break;
        default:
            break;
    }
    
    CGSize dstSize;
    
    if ( !scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height) ) {
        dstSize = srcSize;
    }
    else {
        CGFloat wRatio = boundingSize.width / srcSize.width;
        CGFloat hRatio = boundingSize.height / srcSize.height;
        
        if (wRatio < hRatio) {
            dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
        }
        else {
            dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
        }
    }
    return [self resizedImageToSize:dstSize];
}

@end
