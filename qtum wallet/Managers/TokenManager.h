//
//  TokenManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HistoryElement;

extern NSString *const kTokenDidChange;

@interface TokenManager : NSObject <Managerable>

- (NSArray <Token*>*)getAllContracts;
- (NSArray <Token*>*)getAllTokens;
- (void)addNewToken:(Token*) token;
- (void)updateTokenWithAddress:(NSString*) address withNewBalance:(NSString*) balance;
- (void)checkSmartContract:(HistoryElement*) item;
- (void)addNewTokenWithContractAddress:(NSString*) contractAddress;
- (void)addSmartContractPretendent:(NSArray*) addresses forKey:(NSString*) key withTemplate:(TemplateModel*)templateModel;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
