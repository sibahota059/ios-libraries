//
//  KeyChainManager.m
//
//  Created by breaklee on 2014. 10. 23..
//

/*
 presquite
    apple's KeyChainItemWrapper, m
    and BuildPahses -> Compile Sources -> -fno-obj-arc
*/

#import "KeyChainManager.h"
#import "KeychainItemWrapper.h"

@interface KeyChainItem() {
    KeychainItemWrapper *_keyChain;
}

@end
/*
 
    NSString *secureDataString = [keyChain objectForKey:(__bridge id)kSecValueData];
    NSData *data = [secureDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
 

    NSMutableDictionary *dic;
    NSData *rawData = [NSJSONSerialization dataWithJSOINObject:secureDataDict options:0 error:&error];
    NSString *dataString = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
    [keyChain setObject:dataString forKey:(__bridge id)kSecValueData];
 
 */

@implementation KeyChainItem

- (id)initWithIdentifier:(NSString*)identifier {
    if(identifier == nil) {
        return nil;
    }
    
    self = [super init];
    if(self) {
//        kSecMatchEmailAddressIfPresent
//        kSecClassGenericPassword
        _keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
        [_keyChain setObject:identifier forKey:(__bridge id)kSecAttrAccount];
        [_keyChain setObject:(__bridge id)(kSecAttrAccessibleAlways) forKey:(__bridge id)kSecAttrAccessible];
    }
    return self;
}

- (void)removeKeychain {
    [_keyChain resetKeychainItem];
}

- (void)setObject:(NSString*)value {
    [_keyChain setObject:value forKey:(__bridge id)kSecValueData];
}

- (NSString*)getObject {
    return [_keyChain objectForKey:(__bridge id)kSecValueData];
}

@end
