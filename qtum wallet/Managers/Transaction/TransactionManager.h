//
//  TransactionManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 02.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionManager : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (void)sendTransactionWalletKeys:(NSArray<BTCKey*>*) walletKeys
               toAddressAndAmount:(NSArray*) amountsAndAddresses
                       andHandler:(void(^)(NSError* error, id response)) completion;


- (void)createSmartContractWithKeys:(NSArray<BTCKey*>*) walletKeys
                         andBitcode:(NSData*) bitcode
                         andHandler:(void(^)(NSError* error, BTCTransaction * transaction, NSString* hashTransaction)) completion;

//- (void)sendSmartTransaction:(NSData*) bitcode withSuccess:(void(^)(NSData* address))success andFailure:(void(^)(NSString *message))failure;

@end
