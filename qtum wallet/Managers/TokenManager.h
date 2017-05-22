//
//  TokenManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HistoryElement;

extern NSString *const kTokenDidChange;

@interface TokenManager : NSObject <Managerable>

- (NSArray <Token*>*)gatAllTokens;
- (void)addNewToken:(Token*) token;
- (void)updateTokenWithAddress:(NSString*) address withNewBalance:(NSString*) balance;
- (void)checkSmartContract:(HistoryElement*) item;
- (void)addSmartContractPretendent:(NSArray*) addresses forKey:(NSString*) key;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
