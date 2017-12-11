//
//  KeychainKeyValueStorageProtocol.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 29.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeychainKeyValueStorageProtocol <NSObject>

- (instancetype)initWithService:(NSString*) service;

- (BOOL)setObject:(id) object forKey:(id)key;
- (id)objectForKey:(id)key;
- (BOOL)removeObjectForKey:(id) key;

@end
