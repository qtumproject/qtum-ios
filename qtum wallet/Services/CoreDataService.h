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

@interface CoreDataService : NSObject <Clearable>

@property (strong, nonatomic, readonly) NSManagedObjectContext*  _Nullable managedObjectContext;

- (void)saveWithcompletion:(void (^_Nullable)(BOOL contextDidSave, NSError *_Nullable error))complete;
- (WalletHistoryEntity *_Nonnull)createWalletHistoryEntityWith:(HistoryElement*_Nonnull) element;
- (NSArray<TransactionReceipt*>*_Nonnull)findHistoryReceiptEntityWithTxHash:(NSString *_Nonnull)txHash;
- (TransactionReceipt *_Nonnull)createReceiptEntityWith:(NSArray*_Nonnull) dataDictionary withTxHash:(NSString*_Nonnull) historyTransactionHash;
- (NSArray<WalletHistoryEntity*>*_Nonnull)findWalletHistoryEntityWithTxHash:(NSString *_Nonnull)txHash;

@end
