//
//  KeyChainManager.h
//
//  Created by breaklee on 2014. 10. 23..
//

#import <Foundation/Foundation.h>

@interface KeyChainItem : NSObject

- (id)initWithIdentifier:(NSString*)identifier;
- (void)removeKeychain;
- (void)setObject:(NSString*)value;
- (NSString*)getObject;

@end

