//
//  TransactionManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 02.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionBuilder.h"

@interface TransactionManager : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (void)sendTransactionWalletKeys:(NSArray<BTCKey*>*) walletKeys
               toAddressAndAmount:(NSArray*) amountsAndAddresses
                              fee:(NSDecimalNumber*) fee
                       andHandler:(void(^)(TransactionManagerErrorType errorType, id response)) completion;


- (void)createSmartContractWithKeys:(NSArray<BTCKey*>*) walletKeys
                         andBitcode:(NSData*) bitcode
                                fee:(NSDecimalNumber*) fee
                         andHandler:(void(^)(NSError* error, BTCTransaction * transaction, NSString* hashTransaction)) completion;

- (void)callTokenWithAddress:(NSData*) contractAddress
                andBitcode:(NSData*) bitcode
               fromAddresses:(NSArray<NSString*>*) fromAddresses
                 toAddress:(NSString*) toAddress
                  walletKeys:(NSArray<BTCKey*>*) walletKeys
                         fee:(NSDecimalNumber*) fee
                andHandler:(void(^)(TransactionManagerErrorType errorType, BTCTransaction * transaction, NSString* hashTransaction)) completion;

- (void)sendTransactionToToken:(Contract*) token
                     toAddress:(NSString*) toAddress
                        amount:(NSNumber*) amount
                           fee:(NSDecimalNumber*) fee
                    andHandler:(void(^)(TransactionManagerErrorType errorType, BTCTransaction * transaction, NSString* hashTransaction)) completion;

- (void)sendToken:(Contract*) token
        fromAddress:(NSString*) frommAddress
         toAddress:(NSString*) toAddress
            amount:(NSDecimalNumber*) amount
              fee:(NSDecimalNumber*) fee
        andHandler:(void(^)(TransactionManagerErrorType errorType, BTCTransaction * transaction, NSString* hashTransaction)) completion;

@end
