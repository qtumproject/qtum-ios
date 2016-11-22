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
@property (nonatomic, copy) void (^keyRegistered)(BOOL registered);

- (void)createNewKey;
- (BOOL)save;
- (void)load;
- (BOOL)removeAllKeys;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
