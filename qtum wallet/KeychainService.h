//
//  KeychainService.h
//  qtum wallet
//
//  Created by Fedorenko Nikita on 29.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainService : NSObject

- (BOOL)setObject:(id) object forKey:(id)key;
- (id)objectForKey:(id)key;
- (void)removeObjectForKey:(id) key;
- (void)touchIDString:(void (^)(NSString *string, NSError *error)) handler;
- (void)addTouchIdString:(NSString *_Nonnull) touchIDString;

@end
