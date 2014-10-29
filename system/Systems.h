//
//  Systems.h
//
//  Created by breaklee on 2014. 10. 22..
//

@import Foundation;

@interface Systems : NSObject

+ (NSString*)documentDirectory;
+ (NSString*)uuid;
+ (NSString*)hashMD5:(NSString*)string;
+ (NSString*)hashMD5Data:(NSData*)data;

@end
