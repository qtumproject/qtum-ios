//
//  WalletHistoryEntity+CoreDataProperties.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//
//

#import "WalletHistoryEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WalletHistoryEntity (CoreDataProperties)

+ (NSFetchRequest<WalletHistoryEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *amountString;
@property (nullable, nonatomic, copy) NSString *feeString;
@property (nonatomic) BOOL confirmed;
@property (nonatomic) BOOL contracted;
@property (nullable, nonatomic, copy) NSString *currency;
@property (nonatomic) int64_t dateInerval;
@property (nullable, nonatomic, retain) NSArray *fromAddresses;
@property (nonatomic) BOOL hasReceipt;
@property (nonatomic) BOOL internal;
@property (nonatomic) BOOL send;
@property (nullable, nonatomic, retain) NSArray *toAddresses;
@property (nullable, nonatomic, copy) NSString *transactionHash;
@property (nonatomic) int64_t blockNumber;
@property (nullable, nonatomic, copy) NSString *blockHash;



@end

NS_ASSUME_NONNULL_END
