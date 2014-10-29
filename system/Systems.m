//
//  Systems.m
//
//  Created by breaklee on 2014. 10. 22..
//

#import "Systems.h"
//MD5
#import <CommonCrypto/CommonDigest.h>

@implementation Systems

//#ifdef __IPHONE_8_0
+ (void)showIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void)hideIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

+ (NSString*)documentDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    2) NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    return documentsDirectory;    
}

+ (NSString*)uuid {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    NSString *retStr = (__bridge NSString *)string;
    CFRelease(string);
    return [retStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceid"];
//    if(deviceID == nil || deviceID.length == 0){
//        theUUID = [theUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:theUUID forKey:@"deviceid"];
//        [userDefaults synchronize];
//    }
//    return
}

+ (NSString*)hashMD5Data:(NSData*)data {
//    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
//    
//    if (fileExistsAtPath && !isDirectory) {
//        NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:filePath];
//        unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], data.length, result);
    
    NSMutableString *hash = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

+ (NSString*)hashMD5:(NSString*)string {
    const char *concat_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    
    NSMutableString *hash = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

+ (uint64_t) totalSpaceOfDocumentDirectory {
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    return totalSpace;
}

+ (uint64_t) freeSpaceOfDocumentDirectory {
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    return totalFreeSpace;
}

+ (void)deleteFilesInDir:(NSString*)dir error:(NSError*)error {
//    NSString *docuementPath = [Utils documentsPath];
//    NSString *imageCashPath = [docuementPath stringByAppendingPathComponent:IMAGECASH_DIR_NAME];
    if ([[NSFileManager defaultManager] isReadableFileAtPath:dir]) {
        [[NSFileManager defaultManager] removeItemAtPath:dir error:&error];
//            customLog(@"image cash remove success");
//        } else {
//            customLog(@"image cash remove fail [%@]",error.description);
//        }
    }
}

+ (void) savePlistToDoc:(NSDictionary*)dic filename:(NSString*)name {
//    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path]) {
        
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        
//        or  ( backup copy )
//        
//        NSString *bundle = [[NSBundle mainBundle]pathForResource:@"AppInfo" ofType:@"plist"];
//        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    [dic writeToFile:path atomically:YES];
    
//    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
//    if([[savedStock objectForKey:@"version"] intValue]==1){
////        return NO;
//    }else{
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
//        int value = 1;
//        [data setObject:[NSNumber numberWithInt:value] forKey:@"version"];
//        
//        [data writeToFile: path atomically:YES];
////        return YES;
//    }
}

+ (NSString*)trimmedSpaceNewLine:(NSString*)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString*)trimAlnum:(NSString*)string {
    #define LEGALSTRING     @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:LEGALSTRING] invertedSet];
    NSString *filterd = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return filterd;
}

+ (const char*)toCString:(NSString*)string {
    return [string cStringUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData*)stringToData:(NSString*)string {
    return [string dataUsingEncoding:0x80000000+kCFStringEncodingDOSKorean];
}

+ (BOOL)isEmailFormat:(NSString*)emailString {
    // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

+ (void)makeCornerRadius:(UIView*)view delta:(float)value {
    view.layer.cornerRadius = value;
    view.layer.masksToBounds = YES;
}

+ (UIImage*)colorImage:(UIColor*)color frame:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)setCookieStorage:(int)cacheSize diskSize:(int)diskSize {
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

//    int cacheSizeMemory = 8 * 1024 * 1024; // 8MB
//    int cacheSizeDisk = 32 * 1024 * 1024; // 32MB
    NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSize diskCapacity:diskSize diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
}

+ (NSString*) jsonToString:(NSDictionary*)dic {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+ (NSDictionary*)stringToJson:(NSString*)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end

/*
 
 24. CLLocationManager
 
 CLLocationManager *locManager = [[CLLocationManager alloc] init];
 [locManager setDelegate:self];
 [locManager setDesiredAccuracy:kCLLocationAccuracyBest];
 [locManager startUpdationgLocation]; // ios8 이전
 [locManager release];
 
 1.
 CLLocationManager *locManager = [[CLLocationManager alloc] init];
 [locManager setDelegate:self];
 [locManager setDesiredAccuracy:kCLLocationAccuracyBest];
 if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
 [locManager requestWhenInUseAuthorization]; //App이 실행중일때만 위치정보 수집
 //[locManager requestAlwaysAuthorization]; //App이 실행중이지 않아도 위치정보 수집
 }
 [locManager startUpdationgLocation];
 [locManager release];
 
 ios8이상에서의 처리
 2.(info.plist에 프로퍼티 추가) iOS8
 App이 실행중일때만 위치정보를 수집할때 ([locManager requestWhenInUseAuthorization])사용시
 ->프로퍼티명: NSLocationWhenInUseUsageDescription / Type:String / Value(동의창이 뜰때 추가로 넣고싶은내용)
 
 App 실행중이지 않아도 위치정보를 수집할때 ([locManager requestAlwaysAuthorization])사용시
 ->프로퍼티명:NSLocationAlwaysUsageDescription / Type:String / Value(동의창이 뜰때 추가로 넣고싶은내용)
*/

