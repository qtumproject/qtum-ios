//
//  KeysManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 31.10.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeysManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong, readonly) NSArray *keys;
@property (nonatomic, strong, readonly) NSArray *keysForTransaction;
@property (nonatomic, strong, readonly) NSString *label;
@property (nonatomic, copy) void (^keyRegistered)(BOOL registered);
@property (nonatomic, strong, readonly) NSString* PIN;


- (void)createNewKey;
- (void)importKey:(NSString *)privateAddress;
- (BOOL)save;
- (void)load;
- (void)removeAllKeys;

- (void)storePin:(NSString*) pin;
- (void)removePin;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
