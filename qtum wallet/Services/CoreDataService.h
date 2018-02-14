//
//  CoreDataService.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WalletHistoryEntity;
@class TransactionReceipt;
@class WalletBalanceEntity;
@class WalletContractHistoryEntity;

@interface CoreDataService : NSObject <Clearable>

@property (strong, nonatomic, readonly) NSManagedObjectContext*  _Nullable managedObjectContext;

- (void)saveWithcompletion:(void (^_Nullable)(BOOL contextDidSave, NSError *_Nullable error))complete;
- (WalletHistoryEntity *_Nonnull)createWalletHistoryEntityWith:(HistoryElement*_Nonnull) element;
- (NSArray<TransactionReceipt*>*_Nonnull)findAllHistoryReceiptEntityWithTxHash:(NSString *_Nonnull)txHash;
- (TransactionReceipt *_Nonnull)createReceiptEntityWith:(NSArray*_Nonnull) dataDictionary withTxHash:(NSString*_Nonnull) historyTransactionHash;
- (NSArray<WalletHistoryEntity*>*_Nonnull)findWalletHistoryEntityWithTxHash:(NSString *_Nonnull)txHash;
- (TransactionReceipt*_Nullable)findHistoryRecieptEntityWithTxHash:(NSString *_Nonnull)txHash;
- (WalletContractHistoryEntity *_Nonnull)createWalletContractHistoryEntityWith:(HistoryElement*_Nonnull) element andDecimals:(NSString*_Nonnull) decimals;
- (WalletBalanceEntity*_Nonnull)walletBalanceEntity;
- (void)updateHistoryEntityWithReceiptTxHash:(NSString *_Nonnull) txHash contracted:(BOOL) contracted;
- (NSArray<WalletHistoryEntity*>*_Nonnull)allWalletHistoryEntitysWithLimit:(NSInteger) limit;


@end
